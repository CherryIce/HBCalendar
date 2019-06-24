//
//  ViewController.m
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import "ViewController.h"

#import "Calendar/CalendarView.h"

@interface ViewController ()

@property (nonatomic , retain) CalendarView * calendar;

@end

@implementation ViewController

- (CalendarView *)calendar{
    if (!_calendar) {
        _calendar = [[CalendarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame) + 44, [UIScreen mainScreen].bounds.size.width, [CalendarView getMonthTotalHeight:[NSDate date]]) Date:[NSDate date]];
        [self.view addSubview:self.calendar];
    }
    return _calendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar.maxDate = [[YXDateHelpObject manager] getDataFromStrFormat:@"yyyy-MM-dd" String:@"2019-12-01"];//[[YXDateHelpObject manager] getNextMonth:[NSDate date]];
    self.calendar.minDate = [[YXDateHelpObject manager] getDataFromStrFormat:@"yyyy-MM-dd" String:@"2018-01-01"];
    
    __weak typeof(self) weakSelf = self;
    self.calendar.leftRightCall = ^(NSDate * _Nonnull date) {
        weakSelf.calendar.currentDate = date;
        weakSelf.calendar.dataArray = @[];
    };
    self.calendar.sendSelectDate = ^(NSDate * _Nullable selDate) {
        NSLog(@"%@",[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-M-d" Date:selDate]);
    };
    self.calendar.selectYearAndMonthCall = ^{
      //时间选择器
    };
}


@end
