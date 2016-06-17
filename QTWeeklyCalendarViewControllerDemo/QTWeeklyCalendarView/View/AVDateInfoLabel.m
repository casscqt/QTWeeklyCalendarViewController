//
//  AVDateInfoLabel.m
//  AVWeeklyCalendarView
//
//  Created by Cass on 16/3/22.
//  Copyright © 2016年 Cass. All rights reserved.
//

#import "AVDateInfoLabel.h"

@implementation AVDateInfoLabel





-(void)setDate:(NSDate *)date
{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy 年 M 月"];
    NSString *strDate = [dayFormatter stringFromDate:date];
    [self setText:strDate];
}
@end
