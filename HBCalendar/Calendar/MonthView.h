//
//  MonthView.h
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDCalendarCell.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat const dayCellH = 55;//日期cell高度

@interface MonthView : UIView

//回传选中日期
@property (nonatomic, copy) void(^sendSelectDate)(NSDate * _Nullable selDate);
//初始化
- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date;

- (void)updateCalendraWuthDate:(NSDate *)currentDate dataArray:(nullable NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
