//
//  YFHealthManage.h
//  Health
//
//  Created by 叶增峰 on 16/8/10.
//  Copyright © 2016年 叶增峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <UIKit/UIKit.h>

@interface HealthManage : NSObject

@property (nonatomic,strong) HKHealthStore *healthStore;

+ (id)sharedInstance;

/**
 *  获取权限
 */
- (void)getPermissions;

/**
 *  获取当天时间段
 */
- (NSPredicate*)predicateToday;

/**
 *  获取当天步数
 */
- (void)getStepCountToday:(void(^)(int steps))completion;

/**
 *  写入步数
 *
 *  @param steps     步数
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *  @param completion   完成回调
 */
- (void)setStepCountWithSteps:(double)steps startDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(void(^)(BOOL success))completion;

@end
