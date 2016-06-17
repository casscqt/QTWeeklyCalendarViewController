//
//  WeeklyCollectionViewCell.h
//  AVWeeklyCalendarView
//
//  Created by Cass on 16/3/21.
//  Copyright © 2016年 Cass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;

+ (NSString*)cellIdentifier;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
