//
//  WeeklyCollectionViewCell.m
//  AVWeeklyCalendarView
//
//  Created by Cass on 16/3/21.
//  Copyright © 2016年 Cass. All rights reserved.
//

#import "WeeklyCollectionViewCell.h"
#import "NSDate+CL.h"

@interface WeeklyCollectionViewCell()

/* 日历显示 每天 SuperView */
@property (nonatomic, strong) UIView *dateLabelContainer;
/* 日历显示 周几 Label */
@property (nonatomic, strong) UILabel *weekLabel;
/* 日历显示 几号 Label */
@property (nonatomic, strong) UILabel *dateLabel;
/* 动画View */
@property (nonatomic, strong) UIView *animationView;

@end

#define DATE_LABEL_SIZE 36
#define DATE_LABEL_HEIGHT 70
#define DATE_LABEL_FONT_SIZE 13
#define WEEK_LABEL_HEIGHT 25

@implementation WeeklyCollectionViewCell

+ (NSString*)cellIdentifier {
    return NSStringFromClass([self class]);
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.dateLabelContainer];
    }
    
    return self;
}

/* 日历显示 每天 View */
-(UIView *)dateLabelContainer
{
    if(!_dateLabelContainer){
        float x = (self.bounds.size.width - DATE_LABEL_SIZE)/2;
        _dateLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(x, 0, DATE_LABEL_SIZE, DATE_LABEL_HEIGHT)];
        _dateLabelContainer.backgroundColor = [UIColor clearColor];

        [_dateLabelContainer addSubview:self.animationView];
        [_dateLabelContainer addSubview:self.dateLabel];
        [_dateLabelContainer addSubview:self.weekLabel];
        
    }
    return _dateLabelContainer;
}

/** 显示 周几 的label */
- (UILabel *)weekLabel
{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, DATE_LABEL_SIZE, 13)];
        _weekLabel.backgroundColor = [UIColor clearColor];
        _weekLabel.textAlignment = NSTextAlignmentCenter;
        _weekLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        _weekLabel.font = [UIFont systemFontOfSize:DATE_LABEL_FONT_SIZE];
    }
    return _weekLabel;
}

/** 显示 几号 的label */
-(UILabel *)dateLabel
{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:DATE_LABEL_FONT_SIZE];
    }
    
    return _dateLabel;
    
}

-(UIView *)animationView
{
    if (!_animationView) {
        _animationView = [[UIView alloc]initWithFrame:CGRectMake(0, 28, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _animationView.layer.cornerRadius = DATE_LABEL_SIZE/2;
        _animationView.clipsToBounds = YES;
    }
    return _animationView;
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    //画今天是几号
    if ([self.date isDateToday]) {
        self.dateLabel.text = @"今天";
    }else{
        self.dateLabel.text = [self.date getDateOfMonth];
    }
    
    //画今天是周几
    if ([[self.date getDayOfWeekShortString] isEqualToString:@"日"]||[[self.date getDayOfWeekShortString] isEqualToString:@"一"]) {
        self.weekLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    }else{
        self.weekLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    }
    self.weekLabel.text = [self.date getDayOfWeekShortString];
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected];
    
    if([self.date isDateToday]){
        
        self.animationView.backgroundColor = [UIColor colorWithRed:255.0/255 green:132.0/255 blue:32.0/255 alpha:1];
        
        //修改当天日期的颜色
        if (selected) {
            self.animationView.transform = CGAffineTransformMakeScale(0, 0);
            if (animated) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.animationView.transform = CGAffineTransformMakeScale(1, 1);
                }];
            } else {
                self.animationView.transform = CGAffineTransformMakeScale(1, 1);
            }
        }
        
        //修改当天日期字体颜色
        self.dateLabel.textColor = [UIColor whiteColor];
        
    }else{
        //修改选中日期背景颜色
        self.animationView.backgroundColor = (selected)?[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]: [UIColor clearColor];
        self.animationView.transform = CGAffineTransformMakeScale(0, 0);
        //修改当天日期的颜色
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                self.animationView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        } else {
            self.animationView.transform = CGAffineTransformMakeScale(1, 1);
        }
        
        //修改选中日期字体
        self.dateLabel.textColor = (selected)?[UIColor whiteColor]:[UIColor blackColor];
    }
}

@end
