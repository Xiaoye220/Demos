//
//  ViewController.m
//  Health
//
//  Created by 叶增峰 on 16/8/10.
//  Copyright © 2016年 叶增峰. All rights reserved.
//

#import "ViewController.h"
#import "HealthManage.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HKHealthStore *healthStore;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[@"get step count today", @"add 100 steps"];
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    CGFloat y = UIApplication.sharedApplication.statusBarFrame.size.height + 44;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, screenWidth, screenHeight - y)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HealthStepManage
- (void)getStepCountToday {
    [self getPermission];

    //获取当天步数
    [[HealthManage sharedInstance] getStepCountToday:^(int stepsResult){
        //主线程更新ui
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self showAlertWithMessage:[NSString stringWithFormat:@"今日步数: %d", stepsResult]];
        }];
    }];
}

- (void)addSteps {
    [self getPermission];
    
    //写入步数
    NSDate *end = [NSDate date];
    NSDate *start = [end dateByAddingTimeInterval:(-60)];
    [[HealthManage sharedInstance] setStepCountWithSteps:100 startDate:start endDate:end completion:^(BOOL success) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self showAlertWithMessage:[NSString stringWithFormat:@"添加步数%@", success ? @"成功" : @"失败"]];
        }];
    }];
}

- (void)getPermission {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[HealthManage sharedInstance] getPermission];
    });
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selected = self.dataSource[indexPath.row];
    if([selected isEqualToString:@"get step count today"]) {
        [self getStepCountToday];
    } else if([selected isEqualToString:@"add 100 steps"]) {
        [self addSteps];
    }
}

#pragma mark - AlertViewController
- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
