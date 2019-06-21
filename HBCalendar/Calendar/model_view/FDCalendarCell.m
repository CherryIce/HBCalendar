//
//  FDCalendarCell.m
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import "FDCalendarCell.h"

@interface FDCalendarCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dayL;
@property (weak, nonatomic) IBOutlet UILabel *blueLab;
@property (weak, nonatomic) IBOutlet UILabel *redLab;

@end

@implementation FDCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _dayL.layer.cornerRadius = 17;
    _bgView.layer.cornerRadius = 22;
    _blueLab.layer.cornerRadius = 8;
    _redLab.layer.cornerRadius = 8;
}

- (void) updateWithObj:(id) obj model:(FDCalendarModel *)model{
    if ([[YXDateHelpObject manager] checkSameMonth:obj AnotherMonth:_currentDate]) {
        [self showDateFunctionWithObj:obj model:model];
    } else {
        [self showSpaceFunction];
    }
}


//MARK: - otherMethod
- (void)showSpaceFunction {
    //其他月份在当前页的部分数据
    [self setHidden:true];
}

- (void)showDateFunctionWithObj:(id)obj model:(FDCalendarModel *)model {
    //当前月数据
    [self setHidden:false];
    
    _dayL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:obj];
    
    NSInteger index = [[YXDateHelpObject manager] getNumberInWeek:obj];
    if (index == 1 || index == 7) {
        _dayL.textColor = [UIColor redColor];
    }else{
        _dayL.textColor = [UIColor darkTextColor];
    }
    
    if ([[YXDateHelpObject manager] isSameDate:obj AnotherDate:[NSDate date]]) {
        _dayL.backgroundColor = [UIColor orangeColor];
        _bgView.backgroundColor = [UIColor colorWithRed:249/255.0 green:243/255.0 blue:196/255.0 alpha:1.0];
        //判断model的数据决定红蓝存在不存在
        [self isShowSomething:model];
    } else {
        _dayL.backgroundColor = [UIColor clearColor];
        _bgView.backgroundColor = [UIColor clearColor];
        [self isShowSomething:model];
    }
    
    //选中状态颜色的改变,不做
    //    if (_selectDate) {
    //        if ([[YXDateHelpObject manager] isSameDate:obj AnotherDate:_selectDate]) {
    //
    //        } else {
    //            _dayL.backgroundColor = [UIColor clearColor];
    //            _dayL.textColor = [UIColor blackColor];
    //
    //        }
    //
    //    }
}

- (void) isShowSomething:(FDCalendarModel *) model
{
    //判断model的数据决定红蓝存在不存在
    if (model.isExist) {
        if ([self stringIsZeroOrNull:model.endsNum] && (![self stringIsZeroOrNull:model.dueNum] || ![self stringIsZeroOrNull:model.todayPlanIncomeNum])) {
            //红在蓝不在
            _blueLab.hidden = true;
            _redLab.hidden = false;
            _redLab.text = [NSString stringWithFormat:@"%d间",[model.dueNum intValue] + [model.todayPlanIncomeNum intValue]];
        }else if (![self stringIsZeroOrNull:model.endsNum] && ([self stringIsZeroOrNull:model.dueNum] && [self stringIsZeroOrNull:model.todayPlanIncomeNum])){
            //蓝在红不在
            _redLab.hidden = true;
            _blueLab.hidden = false;
            _blueLab.text = model.endsNum;
        }else if (![self stringIsZeroOrNull:model.endsNum] && (![self stringIsZeroOrNull:model.dueNum] || ![self stringIsZeroOrNull:model.todayPlanIncomeNum])){
            //红蓝同时在
            _blueLab.hidden = false;
            _redLab.hidden = false;
            _redLab.text = [NSString stringWithFormat:@"%d间",[model.dueNum intValue] + [model.todayPlanIncomeNum intValue]];
            _blueLab.text = model.endsNum;
        }
        else{
            // 判断失误红蓝都不在
            _blueLab.hidden = true;
            _redLab.hidden = true;
        }
    }else{
        _blueLab.hidden = true;
        _redLab.hidden = true;
    }
}

/** 字符串是@“0“或者为空 */
- (BOOL) stringIsZeroOrNull:(NSString *) string{
    if ([string isEqualToString:@"0"]) {
        return true;
    }
    return [[YXDateHelpObject manager] isNull:string];
}

@end
