//
//  FDCalendarCell.h
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YXDateHelpObject.h"

#import "FDCalendarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDCalendarCell : UICollectionViewCell

//当前月份
@property (nonatomic, strong) NSDate *currentDate;

- (void) updateWithObj:(NSDate *)obj model:(FDCalendarModel *)model;

@end

NS_ASSUME_NONNULL_END
