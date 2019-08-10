//
//  YFHealthManage.m
//  Health
//
//  Created by 叶增峰 on 16/8/10.
//  Copyright © 2016年 叶增峰. All rights reserved.
//

#import "HealthManage.h"

@implementation HealthManage

+ (id)sharedInstance {
    static dispatch_once_t once;
    static id instance = nil;
    dispatch_once( &once, ^{ instance = [[self alloc] init]; } );
    return instance;
}

- (void)getPermissions {
    //判断设备是否支持
    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"设备不支持");
        return;
    }
    
    self.healthStore = [[HKHealthStore alloc] init];
    //设置读数据权限
    HKObjectType *stepCountReadType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSet *readTypes = [NSSet setWithObjects:stepCountReadType, nil];
    //设置写数据权限
    HKObjectType *stepCountShareType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSet *shareTypes = [NSSet setWithObjects:stepCountShareType, nil];

    [self.healthStore requestAuthorizationToShareTypes:shareTypes readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"请求权限成功");
        } else {
            NSLog(@"请求权限失败");
        }
    }];

    
}

- (NSPredicate*)predicateToday {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    //NSPredicate *predicate = [HKQuery predicateForObjectsFromDevices:[NSSet setWithObjects:[HKDevice localDevice], nil]];
    return predicate;
}

- (void)getStepCountToday:(void(^)(int steps))completion {
    int __block steps = 0;
    //获取当天日期
    NSPredicate *predicate = [self predicateToday];
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //NSSortDescriptors用来告诉healthStore怎么样按照开始时间将结果排序。
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    //NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:0
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                for(HKQuantitySample *result in results) {
                                                                    HKQuantity *quantity = result.quantity;
                                                                    HKUnit *countUnit = [HKUnit countUnit];
                                                                    double count = [quantity doubleValueForUnit:countUnit];
                                                                    steps = steps + count;
                                                                }
                                                                completion(steps);
                                                            }];
    
    [self.healthStore executeQuery:sampleQuery];

}

- (void)setStepCountWithSteps:(double)steps startDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(void(^)(BOOL success))completion {
    //查询采样信息
    HKQuantityType *stepsQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //创建HKQuantity存储数据
    HKQuantity *stepsQuantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:steps];
    
    //设备信息
    /*
    NSString *strName = [[UIDevice currentDevice] name];
    NSString *strModel = [[UIDevice currentDevice] model];
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
    HKDevice *device = [[HKDevice alloc] initWithName:strName manufacturer:@"Apple" model:strModel hardwareVersion:strModel firmwareVersion:strModel softwareVersion:strSysVersion localIdentifier:localeIdentifier UDIDeviceIdentifier:localeIdentifier];
    
    HKQuantitySample *stepsQuantitySample = [HKQuantitySample quantitySampleWithType:stepsQuantityType quantity:stepsQuantity startDate:startDate endDate:endDate device:device metadata:nil];
    */
    
    HKQuantitySample *stepsQuantitySample = [HKQuantitySample quantitySampleWithType:stepsQuantityType
                                                                            quantity:stepsQuantity
                                                                           startDate:startDate
                                                                             endDate:endDate];
    
    [self.healthStore saveObject:stepsQuantitySample withCompletion:^(BOOL success, NSError * _Nullable error) {
        completion(success);
    }];
}

@end
