//
//  MGSecurityCenterVC.m
//  MGCEX
//
//  Created by HFW on 2018/7/17.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGSecurityCenterVC.h"
#import "PersonalCenterCell.h"
#import "BindingIndentityIndexVC.h"
#import "SettingtMoneyPasswordVC.h"
#import "CloseGoogleCodeView.h"
#import "EnterTextView.h"
#import "SettingViewModel.h"

@interface MGSecurityCenterVC ()

@property (nonatomic, assign) NSInteger verifyType;
@property (nonatomic, strong) SettingViewModel * settingVM;
@property (nonatomic, assign) BOOL login;

@end

@implementation MGSecurityCenterVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfoData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //先用缓存数据
    self.login = kUserIsLogin;
    self.userModel = [TWUserDefault UserDefaultObjectForUserModel];
}

- (void)setUpTableViewUI{
    
    [super setUpTableViewUI];
    self.title = kLocalizedString(@"安全中心");
    
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorColor = kLineColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"personalCell"];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(10))];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    //去除多余分割线
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(16))];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
}
#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0) return 4;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) return Adapted(10);
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = kBackGroundColor;
        return header;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
        
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
    }
    
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.titleLabel.text = kLocalizedString(@"手机号码认证");
            if([self.userModel.isphone boolValue]){
                cell.personCellType = 1;
                cell.subLabel.text = [TWAppTool mg_securePhoneMailText:_userModel.phone];
                cell.subLabel.textColor = kAssistColor;
            }else{
                cell.personCellType = 0;
                cell.subLabel.text = kLocalizedString(@"未绑定");
                cell.subLabel.textColor = kRedColor;
            }
            
        }else if (indexPath.row == 1){
            cell.titleLabel.text = kLocalizedString(@"邮箱认证");
            if([self.userModel.isemail boolValue]){
                cell.personCellType = 1;
                cell.subLabel.text = [TWAppTool mg_securePhoneMailText:_userModel.email];
                cell.subLabel.textColor = kAssistColor;
            }else{
                cell.personCellType = 0;
                cell.subLabel.text = kLocalizedString(@"未绑定");
                cell.subLabel.textColor = kRedColor;
            }
            
        }else if (indexPath.row == 2){
            
            cell.titleLabel.text = kLocalizedString(@"身份认证");
            if([self.userModel.isidentity integerValue] == 0){
                cell.personCellType = 0;
                cell.subLabel.text = kLocalizedString(@"未绑定");
                cell.subLabel.textColor = kRedColor;
            }else if([self.userModel.isidentity integerValue] == 1){
                cell.personCellType = 1;
                cell.subLabel.text = kLocalizedString(@"审核中");
                cell.subLabel.textColor = kAssistColor;
            }else if([self.userModel.isidentity integerValue] == 2){
                cell.personCellType = 1;
                cell.subLabel.text = kLocalizedString(@"审核成功");
                cell.subLabel.textColor = kAssistColor;
            }else if([self.userModel.isidentity integerValue] == 3){
                cell.personCellType = 0;
                cell.subLabel.text = kLocalizedString(@"审核失败");
                cell.subLabel.textColor = kRedColor;
            }
        }else if (indexPath.row == 3){
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"资金密码");
            cell.subLabel.text = ([self.userModel.issetacc boolValue])? kLocalizedString(@"已设置"):kLocalizedString(@"未设置");
            cell.subLabel.textColor = ([self.userModel.issetacc boolValue])?kAssistColor:kRedColor;
        }
    } else if (indexPath.section == 1){
        
        if(indexPath.row ==0){//登录密码
            
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"登录密码");
            cell.titleLabel.textColor = kTextColor;
            cell.subLabel.text = ([self.userModel.isphone boolValue] || [self.userModel.isemail boolValue])? kLocalizedString(@"已设置"):kLocalizedString(@"未设置");
            cell.subLabel.textColor = ([self.userModel.isphone boolValue] || [self.userModel.isemail boolValue])? kAssistColor:kRedColor;
        } else if(indexPath.row == 1){//手势密码
            cell.titleLabel.text = kLocalizedString(@"手势密码");
            cell.personCellType = 2;
            if([[NSUserDefaults standardUserDefaults]objectForKey:gestureFinalSaveKey]){
                [cell.cellSwitch setOn:YES];
            }else{
                [cell.cellSwitch setOn:NO];
            }
        } else if(indexPath.row == 2){//指纹解锁
            
            cell.titleLabel.text = kLocalizedString(@"指纹登录");
            cell.personCellType = 2;
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"touchID"]){
                [cell.cellSwitch setOn:YES];
            }else{
                [cell.cellSwitch setOn:NO];
            }
        } else if(indexPath.row == 3){//谷歌验证
            
            cell.titleLabel.text = kLocalizedString(@"谷歌身份验证器");
            cell.personCellType = 2;
            [cell.cellSwitch setOn:([self.userModel.google boolValue])? YES:NO];
            if(![self.userModel.isgoogle boolValue]){//没有认证过，就默认关闭
                [cell.cellSwitch setOn:NO];
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(48);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){//手机号码认证
            
            if(![self.userModel.isphone boolValue]){
                [self pushViewControllerWithName:@"BindingPhoneVC"];
            }
        } else if(indexPath.row == 1){//邮箱认证
            
            if(![self.userModel.isemail boolValue]){
                [self pushViewControllerWithName:@"BindingMailVC"];
            }
        } else if(indexPath.row == 2){//身份认证
            
            if([self.userModel.isidentity integerValue] == 0 || [self.userModel.isidentity integerValue] == 3){
                if([self.userModel.isidentity integerValue] == 3){
                    BindingIndentityIndexVC * vc = [[BindingIndentityIndexVC alloc]init];
                    vc.summary = self.userModel.summary;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self pushViewControllerWithName:@"BindingIndentityIndexVC"];
                }
            }
        } else if(indexPath.row == 3){//资金密码
            
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
    } else if(indexPath.section == 1){
        
        if(indexPath.row == 0){//登录密码
            
            if([self.userModel.isphone boolValue] ||[self.userModel.isemail boolValue]){
                //修改密码
                [self pushViewControllerWithName:@"ResertLoginPasswordVC"];
            }
        } else if(indexPath.row == 1){//手势密码
            
            _verifyType = 1;
            [self openGesturesPasswordWithsIndex:indexPath];
        } else if(indexPath.row == 2){//指纹登录
            
            _verifyType = 2;
            [self openFingerprintPasswordWithIndex:indexPath];
        } else if(indexPath.row == 3){//谷歌验证器
            
            if(![self.userModel.isgoogle boolValue]){
                //去开启谷歌认证
                [self pushViewControllerWithName:@"BindingGoogleVC"];
                
            }else{
                //开启或关闭谷歌二次验证
                [self openCloseGoogleCodeWithIndex:indexPath];
            }
        }
    }
}

#pragma mark - Private
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

#pragma mark - LazyLoad
- (SettingViewModel *)settingVM{
    
    if (!_settingVM) {
        _settingVM = [SettingViewModel new];
    }
    return _settingVM;
}


@end
