//
//  AAAViewController.m
//  AVWeeklyCalendarView
//
//  Created by Cass on 16/3/22.
//  Copyright © 2016年 Cass. All rights reserved.
//

#import "QTWeeklyCalendarViewControllerDemo.h"
#import "WeeklyViewController.h"

@interface QTWeeklyCalendarViewControllerDemo ()<WeeklyViewControllerDelegate>

@property (nonatomic, strong) WeeklyViewController *datePicker;
@end

@implementation QTWeeklyCalendarViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker = [WeeklyViewController attachTo:self yPos:0 delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)weeklyViewController:(id)weeklyViewController didSelectDate:(NSDate *)selectedDate
{
    NSLog(@"%@",selectedDate);
}

@end
