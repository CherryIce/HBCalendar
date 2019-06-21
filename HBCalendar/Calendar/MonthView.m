//
//  MonthView.m
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import "MonthView.h"

#import "CollectionViewCell.h"

@interface MonthView()<UICollectionViewDataSource,UICollectionViewDelegate>

//当前月份
@property (nonatomic, strong) NSDate *currentDate;
//选中日期
@property (nonatomic, strong) NSDate *selectDate;
//有特殊事件的数组
@property (nonatomic, strong) NSArray * dataArray;
//显示当月日期
@property (nonatomic, strong) UICollectionView *collectionV;

@end

static NSString * CellID = @"CollectionViewCell";

@implementation MonthView

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _currentDate = date;
        [self setCollectionView];
    }
    return self;
}

//MARK: - settingView
- (void)setCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((self.frame.size.width - 1) / 7, dayCellH);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 6 * dayCellH) collectionViewLayout:layout];
    _collectionV.scrollEnabled = NO;
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionV];
    
    [_collectionV registerNib:[UINib nibWithNibName:CellID bundle:nil] forCellWithReuseIdentifier:CellID];
    
    [self updateCalendraWuthDate:_currentDate dataArray:nil];
}

//MARK: - dateMethod
//获取cell的日期 (日 -> 六   格式,如需修改星期排序只需修改该函数即可)
- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    NSDate *firstOfMonth = [[YXDateHelpObject manager] GetFirstDayOfMonth:_currentDate];
    NSInteger ordinalityOfFirstDay = [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstOfMonth];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = (1 - ordinalityOfFirstDay) + indexPath.item;
    return [myCalendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
}

//MARK: - collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[YXDateHelpObject manager] getRows:_currentDate] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    /** 根据情况显示不同的东西 */
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];
    [self updateWithObj:cellDate cell:cell];
    return cell;
}

//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectDate = [self dateForCellAtIndexPath:indexPath];
    if (_sendSelectDate) {
        _sendSelectDate(_selectDate);
    }
    //选中需要改变颜色才刷新
    //[_collectionV reloadData];
}

#pragma mark --- cell显示 ---
- (void) updateWithObj:(NSDate *)obj cell:(CollectionViewCell *)cell{
    if ([[YXDateHelpObject manager] checkSameMonth:obj AnotherMonth:_currentDate]) {
        [self showDateFunctionWithObj:obj cell:cell];
    } else {
        [self showSpaceFunctionCell:cell];
    }
}


//MARK: - otherMethod
- (void)showSpaceFunctionCell:(CollectionViewCell *)cell {
    cell.hidden = true;
}

- (void)showDateFunctionWithObj:(NSDate *)obj cell:(CollectionViewCell *)cell {
    
    cell.hidden = false;
    
    cell.dayLab.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:obj];
    
    NSInteger index = [[YXDateHelpObject manager] getNumberInWeek:obj];
    if (index == 1 || index == 7) {
        cell.dayLab.textColor = [UIColor redColor];
    }else{
        cell.dayLab.textColor = [UIColor darkTextColor];
    }
    
    if ([[YXDateHelpObject manager] isSameDate:obj AnotherDate:[NSDate date]]) {
        cell.dayLab.backgroundColor = [UIColor orangeColor];
    } else {
        cell.dayLab.backgroundColor = [UIColor clearColor];
    }
    
    //选中状态颜色的改变,不做
    //    if (_selectDate) {
    //        if ([[YXDateHelpObject manager] isSameDate:obj AnotherDate:_selectDate]) {
    //
    //        } else {
    //            cell.dayLab.backgroundColor = [UIColor clearColor];
    //            cell.dayLab.textColor = [UIColor darkTextColor];
    //
    //        }
    //
    //    }
}

#pragma mark -- 更新当前数据 --
- (void)updateCalendraWuthDate:(NSDate *)currentDate dataArray:(nullable NSArray *)dataArray{
    _dataArray = dataArray;
    _currentDate = currentDate;
    [_collectionV reloadData];
}

@end
