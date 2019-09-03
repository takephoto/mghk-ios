// MGC
//
// PersonalSettingsIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "PersonalSettingsIndexVC.h"
#import "PersonalCenterCell.h"
#import "EnterTextView.h"
#import "CloseGoogleCodeView.h"
#import "GestureViewController.h"
#import "SecondaryValidationView.h"
#import "SettingViewModel.h"
#import "AppDelegate.h"
#import "HomePageIndexVC.h"
#import "SettingtMoneyPasswordVC.h"


@interface PersonalSettingsIndexVC ()
@property (nonatomic, assign) NSInteger verifyType;
@property (nonatomic, strong) SettingViewModel * settingVM;
@property (nonatomic, strong) UserModel * userModel;
@property (nonatomic, copy) NSString * currentLanguage;
@property (nonatomic, assign) BOOL login;
@property (nonatomic, copy) NSString * appVersion;
@property (nonatomic, copy) NSString *app_Version;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation PersonalSettingsIndexVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kAssistColor}];
    [self getUserInfoData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //先用缓存数据
    self.login = kUserIsLogin;
    self.userModel = [TWUserDefault UserDefaultObjectForUserModel];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    self.app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.appVersion = [NSString stringWithFormat:@"APP:%@%@:V%@",appCurName,kLocalizedString(@"版本"),self.app_Version];
    
    [self setUpTableViews];
    
    
}


- (void)getUserInfoData{
    
    
    if(!self.login) {
        self.userModel = nil;
        return;
    }
    
    //订阅信号
    @weakify(self);
    [[self.settingVM.settingLoginCommand executionSignals]
     subscribeNext:^(RACSignal *x) {
         [x subscribeNext:^(UserModel * model) {
             @strongify(self);
             self.userModel = model;
             
         }error:^(NSError *error) {
             @strongify(self);
             [self.tableView reloadData];
             
         }];
         
         [x subscribeCompleted:^{
             @strongify(self);
             [self.tableView reloadData];
         }];
     }];
    //开始刷新
    [self.settingVM.settingLoginCommand execute:@"YES"];
}

-(void)setUpTableViews{
    
    self.title = kLocalizedString(@"设置");
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"personalCell"];
    
}

#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.login){
        return 5;
    }else{
        return 5;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if (section == 1){
        return 2;
    }
//    }else if (section == 2){
//        return 1;
//
//    }else if (section == 3){
//        return 2;
//
//    }else if (section == 4){
//        return 2;
//
//    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
    sectionView.backgroundColor = kBackGroundColor;
    return sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0){
        cell.titleLabel.text = NSLocalizedString(@"语言", nil);
        cell.subLabel.text = self.currentLanguage;
        cell.personCellType = 0;
    }else if (indexPath.section == 1){
        
        if(indexPath.row ==0){
            cell.titleLabel.text = kLocalizedString(@"版本更新");
            cell.subLabel.text = [NSString stringWithFormat:@"%@:%@",kLocalizedString(@"版本号"),self.app_Version];
            cell.personCellType = 1;
        }else if(indexPath.row ==1){
            cell.titleLabel.text = kLocalizedString(@"关于我们");
            cell.personCellType = 1;
        }
    }
    /*
    if(indexPath.section == 0){
        cell.titleLabel.text = NSLocalizedString(@"语言", nil);
        cell.subLabel.text = self.currentLanguage;
        cell.personCellType = 0;
    }else if (indexPath.section == 1){
        if(indexPath.row ==0){
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"登录密码");
            cell.titleLabel.textColor = kTextColor;
            cell.subLabel.text = ([self.userModel.isphone boolValue] || [self.userModel.isemail boolValue])? kLocalizedString(@"已设置"):kLocalizedString(@"未设置");
            cell.subLabel.textColor = ([self.userModel.isphone boolValue] || [self.userModel.isemail boolValue])? kAssistColor:kRedColor;
            
            
        }else if(indexPath.row ==1){
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"资金密码");
            cell.subLabel.text = ([self.userModel.issetacc boolValue])? kLocalizedString(@"已设置"):kLocalizedString(@"未设置");
            cell.subLabel.textColor = ([self.userModel.issetacc boolValue])?kAssistColor:kRedColor;
         
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"资金密码");
            cell.subLabel.text = ([self.userModel.issetacc boolValue])? kLocalizedString(@"已设置"):kLocalizedString(@"未设置");
            cell.subLabel.textColor = ([self.userModel.issetacc boolValue])?kAssistColor:kRedColor;
            
        }
    }else if (indexPath.section == 2){
        cell.titleLabel.text = kLocalizedString(@"谷歌身份验证器");
        cell.personCellType = 2;
        [cell.cellSwitch setOn:([self.userModel.google boolValue])? YES:NO];
        if(![self.userModel.isgoogle boolValue]){//没有认证过，就默认关闭
            [cell.cellSwitch setOn:NO];
        }
    }else if (indexPath.section == 3){
        if(indexPath.row ==0){
            
            cell.titleLabel.text = kLocalizedString(@"手势密码");
            cell.personCellType = 2;
            if([[NSUserDefaults standardUserDefaults]objectForKey:gestureFinalSaveKey]){
                [cell.cellSwitch setOn:YES];
            }else{
                [cell.cellSwitch setOn:NO];
            }
            
        }else if(indexPath.row ==1){
            cell.titleLabel.text = kLocalizedString(@"指纹登录");
            cell.personCellType = 2;
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"touchID"]){
                [cell.cellSwitch setOn:YES];
            }else{
                [cell.cellSwitch setOn:NO];
            }
            
            
        }
    }else if (indexPath.section == 4){
        if(indexPath.row ==0){
            cell.titleLabel.text = kLocalizedString(@"版本更新");
            cell.subLabel.text = [NSString stringWithFormat:@"%@:%@",kLocalizedString(@"版本号"),self.app_Version];
            cell.personCellType = 1;
        }else if(indexPath.row ==1){
            cell.titleLabel.text = kLocalizedString(@"关于我们");
            cell.personCellType = 1;
        }
    }
     */
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(48);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Adapted(12);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(indexPath.section==1 || indexPath.section==2 || indexPath.section==3){
        BOOL isVali = [TWAppTool permissionsValidationHandleFinish:^{
            
        }];
        
        if(isVali == NO){
            return;
        }
    }
    
    if(indexPath.section == 0){
        [self pushViewControllerWithName:@"LabguageRegionVC"];
        
    }else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            [TTWHUD showCustomMsg:self.appVersion];
        }else{
            [self pushViewControllerWithName:@"AboutUsVC"];
        }
    }
    
    /*
    if(indexPath.section == 0){
        [self pushViewControllerWithName:@"LabguageRegionVC"];
        
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            if([self.userModel.isphone boolValue] ||[self.userModel.isemail boolValue]){
                //修改密码
                [self pushViewControllerWithName:@"ResertLoginPasswordVC"];
            }
        }else if (indexPath.row == 1){
            if([self.userModel.issetacc boolValue]){
                //修改资金密码
                SettingtMoneyPasswordVC * vc = [[SettingtMoneyPasswordVC alloc]init];
                vc.isSeting = NO;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                //设置资金密码
                SettingtMoneyPasswordVC * vc = [[SettingtMoneyPasswordVC alloc]init];
                vc.isSeting = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }else if(indexPath.section == 2){
        
        if(![self.userModel.isgoogle boolValue]){
            //去开启谷歌认证
            [self pushViewControllerWithName:@"BindingGoogleVC"];
            
        }else{
            //开启或关闭谷歌二次验证
            [self openCloseGoogleCodeWithIndex:indexPath];
        }
        
        
    }else if(indexPath.section == 3){
        if(indexPath.row == 0){//手势开关
            _verifyType = 1;
            [self openGesturesPasswordWithsIndex:indexPath];
        }else{//指纹开关
            _verifyType = 2;
            [self openFingerprintPasswordWithIndex:indexPath];
        }
        
    }else if(indexPath.section == 4){//版本更新
        if(indexPath.row == 0){
        
            [TTWHUD showCustomMsg:self.appVersion];
        }else{
            [self pushViewControllerWithName:@"AboutUsVC"];
        }
    }
     */
}

//开启/关闭谷歌验证器
-(void)openCloseGoogleCodeWithIndex:(NSIndexPath *)index{
    
    PersonalCenterCell * cell = [self.tableView cellForRowAtIndexPath:index];
    if(cell.cellSwitch.isOn == NO){//开启
        @weakify(self);
        CloseGoogleCodeView * open = [[CloseGoogleCodeView alloc]initWithSupView:self.view Title:kLocalizedString(@"开启谷歌验证器安全验证") message:kLocalizedString(@"登录密码") placeholder:kLocalizedString(@"请输入登录密码") sureBtnTitle:kLocalizedString(@"提交") sureBtnClick:^(NSString * password, NSString * code){
            @strongify(self);
            [self openEndCloseGoogle:password code:code status:@"1"];
            
        }cancelBtnClick:^{
            
        }];
        
        [open show];
    }else{
        @weakify(self);
        CloseGoogleCodeView * close = [[CloseGoogleCodeView alloc]initWithSupView:self.view Title:kLocalizedString(@"关闭谷歌验证器安全验证") message:kLocalizedString(@"登录密码") placeholder:kLocalizedString(@"请输入登录密码") sureBtnTitle:kLocalizedString(@"提交") sureBtnClick:^(NSString * password, NSString * code){
            @strongify(self);
            [self openEndCloseGoogle:password code:code status:@"0"];
        }cancelBtnClick:^{
            
        }];
        
        [close show];
    }
    
}

//开启关闭手势安全验证
-(void)openGesturesPasswordWithsIndex:(NSIndexPath *)index{
    
    PersonalCenterCell * cell = [self.tableView cellForRowAtIndexPath:index];
    
    //如果指纹是开启状态，提示他取消
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"touchID"]&&cell.cellSwitch.isOn==NO){
        [TTWHUD showCustomMsg:kLocalizedString(@"手势验证和指纹验证只能开启一个，请先关闭指纹验证")];
        return;
    }
    
    if(cell.cellSwitch.isOn==NO){//将要去开启
        @weakify(self);
        EnterTextView * open = [[EnterTextView alloc]initWithSupView:self.view Title:kLocalizedString(@"开启手势安全验证") message:kLocalizedString(@"登录密码") placeholder:kLocalizedString(@"请输入登录密码") sureBtnTitle:kLocalizedString(@"提交") sureBtnClick:^(NSString *password){
            @strongify(self);
            [self openVerifyPassword:cell password:password];
            
        }cancelBtnClick:^{
            
        }];
        
        [open show];
    }else{//关闭
        @weakify(self);
        EnterTextView * close = [[EnterTextView alloc]initWithSupView:self.view Title:kLocalizedString(@"关闭手势安全验证") message:kLocalizedString(@"登录密码") placeholder:kLocalizedString(@"请输入登录密码") sureBtnTitle:kLocalizedString(@"提交") sureBtnClick:^(NSString *password){
            @strongify(self);
            [self openVerifyPassword:cell password:password];
        }cancelBtnClick:^{
            
        }];
        
        [close show];
    }
}

//开启关闭指纹安全验证
-(void)openFingerprintPasswordWithIndex:(NSIndexPath *)index{
    
    PersonalCenterCell * cell = [self.tableView cellForRowAtIndexPath:index];
    
    //当前设备不支持指纹
    if (![DWTouchIDUNlock dw_validationTouchIDIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error) {}]) {
        [cell.cellSwitch setOn:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"touchID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [TTWHUD showCustomMsg:kLocalizedString(@"当前设备未开启指纹功能")];
        return;
    }
    
    //如果手势是开启状态，提示他取消
    if([[NSUserDefaults standardUserDefaults]objectForKey:gestureFinalSaveKey]&&cell.cellSwitch.isOn==NO){
        [TTWHUD showCustomMsg:kLocalizedString(@"手势验证和指纹验证只能开启一个，请先关闭手势验证")];
        return;
    }
    
    if(cell.cellSwitch.isOn == NO){//去开启
        @weakify(self);
        EnterTextView * open = [[EnterTextView alloc]initWithSupView:self.view Title:kLocalizedString(@"开启指纹安全验证") message:kLocalizedString(@"登录密码") placeholder:kLocalizedString(@"请输入登录密码") sureBtnTitle:kLocalizedString(@"提交") sureBtnClick:^(NSString *password){
            @strongify(self);
            [self openVerifyPassword:cell password:password];
            
        }cancelBtnClick:^{
            
        }];
        [open show];
        
    }else{//关闭
        @weakify(self);
        EnterTextView * close = [[EnterTextView alloc]initWithSupView:self.view Title:kLocalizedString(@"关闭指纹安全验证") message:kLocalizedString(@"登录密码") placeholder:kLocalizedString(@"请输入登录密码") sureBtnTitle:kLocalizedString(@"提交") sureBtnClick:^(NSString *password){
            @strongify(self);
            [self openVerifyPassword:cell password:password];
            
        }cancelBtnClick:^{
            
        }];
        
        [close show];
    }
}

//验证登录密码是否正确
-(void)openVerifyPassword:(PersonalCenterCell *)cell password:(NSString *)password{
    
    self.settingVM.loginPasswoed = password;
    //订阅信号
    @weakify(self);
    [self.settingVM.verifyLoainSignal subscribeNext:^(id x) {
        @strongify(self);
        
        if(self.verifyType == 1){//处理手势
            if(cell.cellSwitch.isOn == NO){
                [cell.cellSwitch setOn:YES];
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                gestureVc.type = GestureViewControllerTypeSetting;
                [self.navigationController pushViewController:gestureVc animated:YES];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:gestureFinalSaveKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [cell.cellSwitch setOn:NO];
            }
            
        }else{//处理指纹
            if(cell.cellSwitch.isOn == NO){
                [cell.cellSwitch setOn:YES];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"touchID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [cell.cellSwitch setOn:NO];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"touchID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
    }];
    
}


-(void)openEndCloseGoogle:(NSString *)password code:(NSString *)code status:(NSString *)status{
    
    
    self.settingVM.GooglePassword = password;
    self.settingVM.GoogleCode = code;
    self.settingVM.GoogleStatus = status;
    //订阅信号
    @weakify(self);
    [self.settingVM.openCloseGoogleSignal subscribeNext:^(UserModel * model) {
        @strongify(self);
        
        if([status integerValue]==1){
            [TTWHUD showCustomMsg:kLocalizedString(@"成功开启谷歌验证")];
            self.userModel.google = @"1";
        }else{
            [TTWHUD showCustomMsg:kLocalizedString(@"已关闭谷歌验证")];
            self.userModel.google = @"0";
        }
        [self.tableView reloadData];
    }];
}

#pragma mark-- 懒加载

-(NSString *)currentLanguage{
    
    _currentLanguage = [NSBundle getPreferredLanguage];
    
    if([_currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        _currentLanguage = kLocalizedString(@"简体中文");
    }
    else if([_currentLanguage rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        //繁体
        _currentLanguage = NSLocalizedString(@"繁体中文",nil);
    }else if ([_currentLanguage rangeOfString:@"en"].location != NSNotFound){
        //英语
        _currentLanguage = NSLocalizedString(@"英语",nil);
    }
    
    return _currentLanguage;
    
}

-(SettingViewModel *)settingVM{
    if(!_settingVM){
        _settingVM = [[SettingViewModel alloc]init];
    }
    return _settingVM;
}

-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.frame =  CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(70.0));
        UIButton *quitBtn = [[UIButton alloc]init];
        [quitBtn setTitleColor:white_color forState:UIControlStateNormal];
        [quitBtn setBackgroundColor:kRedColor];
        ViewRadius(quitBtn, Adapted(2));
        [quitBtn setTitle:kLocalizedString(@"退出") forState:UIControlStateNormal];
        [quitBtn.titleLabel setFont:H15];
        [_footerView addSubview:quitBtn];
        [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Adapted(30));
            make.left.mas_equalTo(Adapted(16));
            make.right.mas_equalTo(Adapted(-16));
            make.bottom.mas_equalTo(0);
        }];
        @weakify(self);
        [[quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            @strongify(self);
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:kLocalizedString(@"确认退出当前账户？")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLogin];
                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                      [TWUserDefault DeleSaveUserModel];
                                                                      [TWAppTool permissionsValidationHandleFinish:^{
                                                                          
                                                                      }];
                                                                      //
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     
                                                                 }];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
    return _footerView;
}

@end
