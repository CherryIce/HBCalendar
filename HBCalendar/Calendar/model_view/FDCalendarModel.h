//
//  FDCalendarModel.h
//  HBCalendar
//
//  Created by 1 on 2019/6/21.
//  Copyright © 2019 com.fdyoumi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDCalendarModel : NSObject

@property (nonatomic , copy) NSString * endsNum ;

@property (nonatomic , copy) NSString * dueNum ;

@property (nonatomic , copy) NSString * todayPlanIncomeNum;

@property (nonatomic , assign) BOOL isExist;

@end

NS_ASSUME_NONNULL_END
