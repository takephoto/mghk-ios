//
//  TestViewController.m
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "TestViewController.h"
#import "MGCoinDealRecordView.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MGCoinDealRecordView *view = [[MGCoinDealRecordView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10*32+50)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
