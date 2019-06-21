//
//  CalendarView.m
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import "CalendarView.h"

static CGFloat const yearMonthH = 40;   //年月高度
static CGFloat const weeksH = 30;       //周高度

@interface CalendarView()

@property (nonatomic , strong) UIButton * yearMonthBtn;

@property (nonatomic, strong) MonthView * monthV;

@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _currentDate = date;
        [self settingHeaderView];
        [self settingMonthV];
    }
    return self;
}

//MARK: - otherMethod
+ (CGFloat)getMonthTotalHeight:(NSDate *)date{
    NSInteger rows = [[YXDateHelpObject manager] getRows:date];
    return yearMonthH + weeksH + rows * dayCellH;
}

- (void) settingHeaderView
{
    UIView * headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, yearMonthH)];
    headV.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [self addSubview:headV];

    
    _yearMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_yearMonthBtn  setFrame:CGRectMake(headV.frame.size.width - 100, 5, 85, 30)];
    [_yearMonthBtn setTitleColor:[UIColor darkTextColor]  forState:UIControlStateNormal];
    [_yearMonthBtn setAttributedTitle:[self getDateString] forState:UIControlStateNormal];
    [_yearMonthBtn addTarget:self action:@selector(selectYearAndMonthRefresh:) forControlEvents:UIControlEventTouchUpInside];
    [headV addSubview:_yearMonthBtn];
    
    NSArray *weekdays = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat weekdayW = self.frame.size.width/7;
    for (int i = 0; i < 7; i++) {
        UILabel *weekL = [[UILabel alloc] initWithFrame:CGRectMake(i*weekdayW, yearMonthH, weekdayW, weeksH)];
        weekL.textAlignment = NSTextAlignmentCenter;
        weekL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        weekL.text = weekdays[i];
        if (i == 0 || i == 6) {
            weekL.textColor = [UIColor redColor];
        }
        [self addSubview:weekL];
    }
}

- (void) settingMonthV
{
    _monthV = [[MonthView alloc] initWithFrame:CGRectMake(0, yearMonthH + weeksH, self.frame.size.width, self.frame.size.height - yearMonthH - weeksH) Date:[NSDate date]];
    [self addSubview:_monthV];
    
    UISwipeGestureRecognizer * leftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer * rightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    leftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    rightGR.direction = UISwipeGestureRecognizerDirectionRight;
    [_monthV addGestureRecognizer:leftGR];
    [_monthV addGestureRecognizer:rightGR];
    
    __weak typeof(self) weakSelf = self;
    _monthV.sendSelectDate = ^(NSDate * _Nullable selDate) {
        if (weakSelf.sendSelectDate) {
            weakSelf.sendSelectDate(selDate);
        }
    };
}

#pragma mark --- 粗粗粗 ---
- (NSMutableAttributedString *) getDateString {
    NSString * string = [[YXDateHelpObject manager] getStrFromDateFormat:@"MM/yyyy" Date:_currentDate];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger length = [string length];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:15] range:NSMakeRange(0, length)];//设置所有的字体
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size: 24] range:NSMakeRange(0, 2)];
    return attr;
}

#pragma mark ---- 选择年月刷新 ----
- (void) selectYearAndMonthRefresh:(UIButton *) sender
{
    //弹出年月选择器,选完后将选中的NSDate替换掉_currentDate,然后更新按钮显示内容
    if (_selectYearAndMonthCall) {
        _selectYearAndMonthCall();
    }
}

#pragma mark --- 刷新回掉 ---
- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [_monthV updateCalendraWuthDate:_currentDate dataArray:dataArray];
}

#pragma mark ---- 左右滑手势 ----
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender

{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        //下个月
        NSDate * nextDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
        int next = [[YXDateHelpObject manager] campareMonth:nextDate AnotherMonth:_maxDate];
        // 1 代表 nextDate > _maxDate
        if (next != 1) {
            _currentDate = nextDate;
            [_yearMonthBtn setAttributedTitle:[self getDateString] forState:UIControlStateNormal];
            /** 回掉刷新 */
            //左右滑动回掉 然后从外部重设dataArray
            if (_leftRightCall) {
                _leftRightCall(nextDate);
            }
        }
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        //上个月
        NSDate * preDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
        int pre = [[YXDateHelpObject manager] campareMonth:preDate AnotherMonth:_minDate];
        // -1 代表 _minDate > preDate
        if (pre != - 1) {
            _currentDate = preDate;
            [_yearMonthBtn setAttributedTitle:[self getDateString] forState:UIControlStateNormal];
            /** 回掉刷新 */
            //左右滑动回掉 然后从外部重设dataArray
            if (_leftRightCall) {
                _leftRightCall(preDate);
            }
        }
    }
}

#pragma mark --- 大小限制 ---

- (void)setMaxDate:(NSDate *)maxDate{
    _maxDate = maxDate;
}

- (void)setMinDate:(NSDate *)minDate{
    _minDate = minDate;
}

@end
