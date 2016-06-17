//
//  weeklyViewController.m
//  AVWeeklyCalendarView
//
//  Created by Cass on 16/3/21.
//  Copyright © 2016年 Cass. All rights reserved.
//

#import "WeeklyViewController.h"
#import "WeeklyCollectionViewCell.h"
#import "NSDate+CL.h"
#import "AVDateInfoLabel.h"

#define kCollectionViewRows 1
#define kCollectionViewCols 7
#define kDateLabelInfoHeight 40.f
#define kCollectionViewHeight 70.0f
#define kLineViewHeight 1.0f


static const int NUMBER_OF_DAYS = 2048;

@interface WeeklyViewController ()<
UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,
UIScrollViewDelegate>

@property (nonatomic, weak, readwrite) id<WeeklyViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *dailyInfoSubViewContainer;
@property (nonatomic, strong) UIButton *goBackTodayBtn;
@property (nonatomic, strong) AVDateInfoLabel *dateInfoLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WeeklyViewController

+ (CGFloat)aspectHeight {
    return kDateLabelInfoHeight + kCollectionViewHeight;
}

+ (instancetype)attachTo:(UIViewController*)viewController yPos:(CGFloat)yPos delegate:(id<WeeklyViewControllerDelegate>)delegate {
    WeeklyViewController *vc = [[WeeklyViewController alloc] init];
    vc.delegate = delegate;
    [vc attachTo:viewController yPos:yPos];
    return vc;
}

- (void)attachTo:(UIViewController*)viewController yPos:(CGFloat)yPos {
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
    self.view.frame = CGRectMake(0, yPos, CGRectGetWidth(viewController.view.frame), [self.class aspectHeight]);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

+ (instancetype)attachTo:(UIViewController*)viewController containerView:(UIView*)containerView delegate:(id<WeeklyViewControllerDelegate>)delegate {
    WeeklyViewController *vc = [[WeeklyViewController alloc] init];
    vc.delegate = delegate;
    [vc attachTo:viewController containerView:containerView];
    return vc;
}

- (void)attachTo:(UIViewController*)viewController containerView:(UIView*)containerView {
    
    [viewController addChildViewController:self];
    [containerView addSubview:self.view];
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), [self.class aspectHeight]);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

- (NSIndexPath*)indexPathForDate:(NSDate*)date {
    NSInteger days = [self getDaysFrom:self.startDate To:date];
    if (days < 0) {
        return nil;
    }
    return [NSIndexPath indexPathForItem:days inSection:0];
}

- (NSDate*)dateForIndexPath:(NSIndexPath*)indexPath {
    return [self.startDate addDays:indexPath.item];
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    if (![_selectedDate isEqual:selectedDate]) {
        _selectedDate = selectedDate;
        if (self.dateInfoLabel != nil) {
            self.dateInfoLabel.date = selectedDate;
        }
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated {
    NSDate *monday = [selectedDate getWeekStartDate:1];
    NSIndexPath *indexPath = [self indexPathForDate:monday];
    if (indexPath == nil) {
        return;
    }
    
    self.selectedDate = selectedDate;
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.startDate = [[[NSDate new] getWeekStartDate:1] addDays:-(NUMBER_OF_DAYS/2)];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.dailyInfoSubViewContainer];
    [self.view addSubview:self.lineView];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    [self.collectionView registerClass:[WeeklyCollectionViewCell class] forCellWithReuseIdentifier:[WeeklyCollectionViewCell cellIdentifier]];
}

/**
 *  界面显示后，选择当天日期
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.selectedDate == nil) {
        [self setSelectedDate:[NSDate date] animated:NO];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeeklyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WeeklyCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    NSDate *date = [self dateForIndexPath:indexPath];
    cell.date = date;
    cell.selected = [self.selectedDate isEqual:date];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBER_OF_DAYS;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect collectionViewFrame = self.collectionView.frame;
    CGFloat cellWidth = collectionViewFrame.size.width/kCollectionViewCols;
    CGFloat cellHeight = collectionViewFrame.size.height/kCollectionViewRows;
    return CGSizeMake(cellWidth, cellHeight);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldSelectedIndexPath = [self indexPathForDate:self.selectedDate];
    if (oldSelectedIndexPath != nil) {
        [(WeeklyCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:oldSelectedIndexPath] setSelected:NO animated:NO];
    }
    self.selectedDate = [self dateForIndexPath:indexPath];
    [(WeeklyCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(weeklyViewController:didSelectDate:)]){
        [self.delegate weeklyViewController:self didSelectDate:self.selectedDate];
    }
    
}

/** 手动滑动，调用的方法 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateGobackButtonStatus];
    
    NSInteger day = [[self.selectedDate getWeekDay] integerValue];
    NSIndexPath *firstIndexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x+1, 1)];
    NSDate *firstDate = [self dateForIndexPath:firstIndexPath];
//    [self setSelectedDate:[firstDate addDays:day-1] animated:NO];
    
    static const int days[] = {7, 1, 2, 3, 4, 5, 6};
    NSDate *date = [firstDate addDays:days[day] - 1];
    
    //未滑动页面则不重新选择日期
    if (![date isEqual:self.selectedDate]) {
        
        NSIndexPath *oldSelectedIndexPath = [self indexPathForDate:self.selectedDate];
        if (oldSelectedIndexPath != nil) {
            [(WeeklyCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:oldSelectedIndexPath] setSelected:NO animated:NO];
        }
        
        self.selectedDate = date;
        [(WeeklyCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[self indexPathForDate:self.selectedDate]] setSelected:YES animated:YES];
        
        
        if ([self.delegate respondsToSelector:@selector(weeklyViewController:didSelectDate:)]){
            [self.delegate weeklyViewController:self didSelectDate:self.selectedDate];
        }
    }
}


/** 系统滑动，调用的方法 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 手动点击按钮时，动画结束后调用该方法
    [self updateGobackButtonStatus];
}

/** 课表按钮显示文案 */
- (void)updateGobackButtonStatus {
    
    [self.goBackTodayBtn setTitle:(
                                   [[self.collectionView indexPathsForVisibleItems] containsObject:[self indexPathForDate:[NSDate new]]] ? @"课表" : @"今天"
                                   )
                         forState:UIControlStateNormal];
}

- (void)rollBackToToday
{
    [self setSelectedDate:[NSDate date] animated:YES];
    if ([self.delegate respondsToSelector:@selector(weeklyViewController:didSelectDate:)]){
        [self.delegate weeklyViewController:self didSelectDate:[NSDate date]];
    }
    
}

#pragma mark - getter方法

-(UIView *)dailyInfoSubViewContainer
{
    if(!_dailyInfoSubViewContainer){
        _dailyInfoSubViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kDateLabelInfoHeight)];
        _dailyInfoSubViewContainer.userInteractionEnabled = YES;
        [_dailyInfoSubViewContainer addSubview:self.goBackTodayBtn];
        [_dailyInfoSubViewContainer addSubview:self.dateInfoLabel];

    }
    return _dailyInfoSubViewContainer;
}


- (UIButton *)goBackTodayBtn
{
    if (!_goBackTodayBtn) {
        _goBackTodayBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, 50, 30)];
        _goBackTodayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_goBackTodayBtn setImage:[UIImage imageNamed:@"nav_schedule_nor"] forState:UIControlStateNormal];
        [_goBackTodayBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
        [_goBackTodayBtn setTitle:@"课表" forState:UIControlStateNormal];
        
        [_goBackTodayBtn addTarget:self action:@selector(rollBackToToday) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _goBackTodayBtn;
}


/** 显示 年月 label */
- (AVDateInfoLabel *)dateInfoLabel
{
    if(!_dateInfoLabel){
        _dateInfoLabel = [[AVDateInfoLabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100 , 10, 100, 30)];
        _dateInfoLabel.textAlignment = NSTextAlignmentCenter;
        _dateInfoLabel.userInteractionEnabled = YES;
    }
    _dateInfoLabel.font = [UIFont systemFontOfSize:13];
    _dateInfoLabel.textColor = [UIColor grayColor];
    return _dateInfoLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kDateLabelInfoHeight, self.view.frame.size.width, kCollectionViewHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];

    }
    return _collectionView;
}


- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kDateLabelInfoHeight + kCollectionViewHeight - kLineViewHeight, self.view.frame.size.width, kLineViewHeight)];
        _lineView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255  blue:235.0/255  alpha:1];
        
    }
    return _lineView;
}


@end
