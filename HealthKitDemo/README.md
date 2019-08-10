# iOS_HealthKit
使用HealthKit读取，写入步数
# 使用
```Objective-C
YFHealthStepManage *stepManage = [YFHealthStepManage sharedInstance];
//获取权限
[stepManage getPermissions];
//获取当天步数
[stepManage getStepCountToday:^(int stepsResult){
    NSLog(@"==============result:%d===============",stepsResult);
    //主线程更新ui
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.step.text = [NSString stringWithFormat:@"当天步数:%d",stepsResult];
    }];
}];
//向Health插入步数
NSDate *end = [NSDate date];
NSDate *start = [end dateByAddingTimeInterval:(-60)];
[stepManage setStepCountWithSteps:10 startDate:start endDate:end];
```