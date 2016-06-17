//
//  WeeklyViewController.h
//  AVWeeklyCalendarView
//
//  Created by Cass on 16/3/21.
//  Copyright © 2016年 Cass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeeklyViewController;

@protocol WeeklyViewControllerDelegate <NSObject>
@required
- (void) weeklyViewController:(WeeklyViewController *)weeklyViewController didSelectDate:(NSDate *)selectedDate;
@end

@interface WeeklyViewController : UIViewController

@property (nonatomic, weak, readonly) id<WeeklyViewControllerDelegate> delegate;

+ (CGFloat)aspectHeight;

+ (instancetype)attachTo:(UIViewController*)viewController yPos:(CGFloat)yPos delegate:(id<WeeklyViewControllerDelegate>)delegate;
+ (instancetype)attachTo:(UIViewController*)viewController containerView:(UIView*)containerView delegate:(id<WeeklyViewControllerDelegate>)delegate;

@end
