//
//  CalendarView.h
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MonthView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarView : UIView

//回传选中日期
@property (nonatomic, copy) void(^sendSelectDate)(NSDate * _Nullable selDate); 

/**
 根据日期获取控件总高度
 
 @param date 日期
 @return return value description
 */
+ (CGFloat)getMonthTotalHeight:(NSDate *)date;

/**
 初始化方法
 
 @param frame 控件尺寸,高度可以调用该类计算方法计算
 @param date 日期
 
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date;

//当前月份
@property (nonatomic, strong) NSDate *currentDate;

//当月数据
@property (nonatomic, strong) NSArray * dataArray;

//最大月份
@property (nonatomic, strong) NSDate * maxDate;

//最小月份
@property (nonatomic, strong) NSDate * minDate;

//左右滑动回掉
@property (nonatomic , copy) void (^leftRightCall) (NSDate * date);

//选择时间回掉
@property (nonatomic , copy) void (^selectYearAndMonthCall) (void);

@end

NS_ASSUME_NONNULL_END
