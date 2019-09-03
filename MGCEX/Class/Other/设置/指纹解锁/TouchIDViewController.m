// MGC
//
// TouchIDViewController.m
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TouchIDViewController.h"
#import "LoginIndexVC.h"

@interface TouchIDViewController ()
/// 指纹解锁按钮
@property(nonatomic, strong) QSButton *touchIDButton;
/// 无法识别指纹按钮
@property(nonatomic, strong) UIButton *unVerifyTDButton;
@end

@implementation TouchIDViewController


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleButtonAction];
}
-(void)back{
    
    if(self.navigationController.presentingViewController){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DWTouchIDUNlock dw_setMandatoryUseTouchID:NO];
//    self.title = kLocalizedString(@"验证Touch ID中...");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :  [UIColor blackColor]}];
    self.view.backgroundColor = kBackGroundColor;
    self.navigationController.navigationBar.barTintColor = kBackGroundColor;
    
    _touchIDButton = [QSButton buttonWithType:UIButtonTypeCustom];
    [_touchIDButton setImage:[UIImage imageNamed:@"zw_b"] forState:UIControlStateNormal];
    [_touchIDButton setTitle:kLocalizedString(@"指纹登录") forState:UIControlStateNormal];
    [_touchIDButton setTitleColor:k99999Color forState:UIControlStateNormal];
    [_touchIDButton addTarget:self action:@selector(handleButtonAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_touchIDButton];
    _touchIDButton.style = QSButtonImageStyleTop;
    _touchIDButton.frame = CGRectMake(0, 0, 150, 300);
    _touchIDButton.center = CGPointMake(MAIN_SCREEN_WIDTH/2.0, (MAIN_SCREEN_HEIGHT/2.0- (64*2)));
    
    _unVerifyTDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_unVerifyTDButton setTitle:kLocalizedString(@"无法识别指纹") forState:UIControlStateNormal];
    [_unVerifyTDButton setTitleColor:k99999Color forState:UIControlStateNormal];
    _unVerifyTDButton.titleLabel.font = H15;
    [_unVerifyTDButton addTarget:self action:@selector(handleUnVerifyTDButtonAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_unVerifyTDButton];
    [_unVerifyTDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(Adapted(150));
        make.height.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(Adapted(-30));
    }];
    
}

- (void)handleButtonAction
{

        @weakify(self);
        [DWTouchIDUNlock dw_touchIDWithMsg:kLocalizedString(@"验证成功后直接进入") cancelTitle:nil otherTitle:nil enabled:YES touchIDAuthenticationSuccessBlock:^(BOOL success) {
            @strongify(self);
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KillLogin];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endAppTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(self.navigationController.presentingViewController){
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
//            [self.navigationController popViewControllerAnimated:YES];
        } operatingrResultBlock:^(DWOperatingTouchIDResult operatingTouchIDResult, NSError *error, NSString *errorMsg) {
            @strongify(self);

            if(operatingTouchIDResult == DWTouchIDResultTypeVersionNotSupport){
                [TTWHUD showCustomMsg:kLocalizedString(@"指纹功能已关闭，请开启")];
            }

        }];
 
}

// 处理无法识别指纹按钮事件
- (void)handleUnVerifyTDButtonAction
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"touchID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [TWAppTool gotoIndexVCLoginRootVc];
}


- (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}


@end
