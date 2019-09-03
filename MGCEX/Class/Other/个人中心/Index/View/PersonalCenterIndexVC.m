//
//  PersonalCenterIndexVC.m
//  MGCEX
//
//  Created by HFW on 2018/7/20.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "PersonalCenterIndexVC.h"
#import "PersonalCenterHeadVIew.h"
#import "PersonalCenterCell.h"
#import "UserInformationVM.h"
#import "MGShareVC.h"
#import "MGTraderVerificationVC.h"
#import "BindingIndentityIndexVC.h"
#import "MGSecurityCenterVC.h"

@interface PersonalCenterIndexVC ()
@property (nonatomic, strong) UserInformationVM * viewModel;
@property (nonatomic, strong) UserModel * userModel;
@property (nonatomic, strong) PersonalCenterHeadVIew * headView;
@property (nonatomic, strong) UIView * tableFooterView;
@property (nonatomic, assign) BOOL isRequestOK;

@end

@implementation PersonalCenterIndexVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self getUserInfoData];
    [self getFiatInfoData];
    [self getCoinInfoData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//获取个人用户信息
- (void)getUserInfoData{
    
    self.isRequestOK = YES;
    //订阅信号
    @weakify(self);
    [self.viewModel.userInfoSignal subscribeNext:^(UserModel *model) {
        @strongify(self);
        //self.isRequestOK = YES;
        self.userModel = model;
        self.headView.userName.text = model.userName;
        [self.tableView reloadData];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取法币信息
-(void)getFiatInfoData{
    
    self.viewModel.type = @"N";
    self.viewModel.istrue = @"1";
    //订阅信号
    @weakify(self);
    [self.viewModel.fiatInfoSignal subscribeNext:^(FiatAccountModel *model) {
        @strongify(self);
        
        self.headView.FiatbtcCount = model.btcCount;
        self.headView.FiatcnySum = model.cnySum;
        
        [self.headView.collectionView reloadData];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}


//获取币币信息
-(void)getCoinInfoData{
    
    self.viewModel.type = @"N";
    self.viewModel.istrue = @"1";
    //订阅信号
    @weakify(self);
    [self.viewModel.coinInfoSignal subscribeNext:^(CoinAccountModel *model) {
        @strongify(self);
        self.headView.CoinbtcCount = model.btcCount;
        self.headView.CoincnySum =  model.cnySum;
        [self.headView.collectionView reloadData];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isExtendLayout = NO;
    //先用缓存数据
    self.userModel = [TWUserDefault UserDefaultObjectForUserModel];
    [self setUpTableViews];
    self.headView.userName.text = self.userModel.userName;
    
    @weakify(self);
    [self dropDownToRefreshData:^{
        @strongify(self);
        [self getUserInfoData];
        [self getFiatInfoData];
        [self getCoinInfoData];
    }];
    
}


-(void)setUpTableViews{
    
    _headView = [[PersonalCenterHeadVIew alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(250) + kStatusBarHeight)];
    self.tableView.tableHeaderView = _headView;
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorColor = kLineColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"personalCell"];
    
    @weakify(self);
    self.headView.itemBlock = ^(NSInteger index) {
        @strongify(self);
        
        if(index == 0){
            [self pushViewControllerWithName:@"FiatCapitalAccountVC"];
        }else{
            [self pushViewControllerWithName:@"CoinCapitalAccountVC"];
        }
    };
}

#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
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
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
        
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
    }
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){//交易记录
            
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"交易记录");
        }else if (indexPath.row == 1){//安全中心
            
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"安全中心");
        } else if (indexPath.row == 2){//支付设置
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"C2C/B2C支付设置");
        } else if(indexPath.row == 3){//商家认证
            switch ([TWUserDefault UserDefaultObjectForUserModel].isApplyForMerchart) {
                case MGMerchantsNotApply:
                {
                    cell.personCellType = withArrow;
                    cell.subLabel.text =  kLocalizedString(@"未认证");
                    cell.subLabel.textColor = kRedColor;
                }
                    break;
                case MGMerchantsApplying:
                {
                    cell.personCellType = noArrow;
                    cell.subLabel.text =  kLocalizedString(@"审核中");
                    cell.subLabel.textColor = kAssistColor;
                }
                    break;
                case MGMerchantsApplySuccess:
                {
                    cell.personCellType = noArrow;
                    cell.subLabel.text =  kLocalizedString(@"已验证");
                    cell.subLabel.textColor = kAssistColor;
                }
                    break;
                case MGMerchantsApplyFailed:
                {
                    cell.personCellType = withArrow;
                    cell.subLabel.text =  kLocalizedString(@"审核不过");
                    cell.subLabel.textColor = kRedColor;
                }
                    break;
                    
                default:
                    break;
            }
            cell.titleLabel.text = kLocalizedString(@"商家认证");
        } else if(indexPath.row == 4){//我的邀请码
            cell.personCellType = 0;
            NSString *myInviteSting = [NSString stringWithFormat:@"%@：%@",kLocalizedString(@"我的邀请码"),[TWUserDefault UserDefaultObjectForUserModel].myInviteCode];
            cell.subLabel.text = myInviteSting;
            cell.titleLabel.text = kLocalizedString(@"分享");
        } else if(indexPath.row == 5){//设置
            
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"设置");
        }
    }
    /*
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
     }
     else if([self.userModel.isidentity integerValue] == 1){
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
     
     }
     }else if (indexPath.section == 1){
     cell.personCellType = 0;
     cell.titleLabel.text = kLocalizedString(@"交易记录");
     
     }else if (indexPath.section == 2){
     
     switch ([TWUserDefault UserDefaultObjectForUserModel].isApplyForMerchart) {
     case MGMerchantsNotApply:
     {
     cell.personCellType = withArrow;
     cell.subLabel.text =  kLocalizedString(@"未认证");
     cell.subLabel.textColor = kRedColor;
     }
     break;
     case MGMerchantsApplying:
     {
     cell.personCellType = noArrow;
     cell.subLabel.text =  kLocalizedString(@"审核中");
     cell.subLabel.textColor = kAssistColor;
     
     }
     break;
     case MGMerchantsApplySuccess:
     {
     cell.personCellType = noArrow;
     cell.subLabel.text =  kLocalizedString(@"已验证");
     cell.subLabel.textColor = kAssistColor;
     }
     break;
     case MGMerchantsApplyFailed:
     {
     cell.personCellType = withArrow;
     cell.subLabel.text =  kLocalizedString(@"审核不过");
     cell.subLabel.textColor = kRedColor;
     
     }
     break;
     
     default:
     break;
     }
     cell.titleLabel.text = kLocalizedString(@"商家认证");
     
     }
     else if (indexPath.section == 3){
     cell.personCellType = 0;
     cell.titleLabel.text = kLocalizedString(@"C2C/B2C支付设置");
     
     }else if (indexPath.section == 4){
     cell.personCellType = 0;
     NSString *myInviteSting = [NSString stringWithFormat:@"%@：%@",kLocalizedString(@"我的邀请码"),[TWUserDefault UserDefaultObjectForUserModel].myInviteCode];
     cell.subLabel.text = myInviteSting;
     cell.titleLabel.text = kLocalizedString(@"分享");
     
     } else if (indexPath.section == 5){
     cell.personCellType = 0;
     cell.titleLabel.text = kLocalizedString(@"设置");
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
    
    if(self.isRequestOK == NO)  return;
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){//交易记录
            [self pushViewControllerWithName:@"FiatTransactionRecordsIndecVC"];
        } else if(indexPath.row == 1){//安全中心
            MGSecurityCenterVC *vc = [MGSecurityCenterVC new];
            vc.userModel = self.userModel;
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 2){//支付设置
            [self pushViewControllerWithName:@"FiatSetAccountVC"];
        } else if(indexPath.row == 3){//商家认证
            [self gotoTraderVerificationVC];
        } else if(indexPath.row == 4){//分享
            MGShareVM *vm = [[MGShareVM alloc] initWithInvitationCode:[TWUserDefault UserDefaultObjectForUserModel].myInviteCode];
            MGShareVC *vc = [[MGShareVC alloc] initWithViewModel:vm];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 5){//设置
            [self pushViewControllerWithName:@"PersonalSettingsIndexVC"];
        }
    }
    
    /*
     if(indexPath.section == 0){
     if(indexPath.row == 0){
     if(![self.userModel.isphone boolValue]){
     [self pushViewControllerWithName:@"BindingPhoneVC"];
     }
     
     }else if (indexPath.row == 1){
     if(![self.userModel.isemail boolValue]){
     [self pushViewControllerWithName:@"BindingMailVC"];
     }
     
     }else if (indexPath.row == 2){
     
     if([self.userModel.isidentity integerValue] == 0 || [self.userModel.isidentity integerValue] == 3){
     if([self.userModel.isidentity integerValue] == 3){
     BindingIndentityIndexVC * vc = [[BindingIndentityIndexVC alloc]init];
     vc.summary = self.userModel.summary;
     [self.navigationController pushViewController:vc animated:YES];
     }else{
     [self pushViewControllerWithName:@"BindingIndentityIndexVC"];
     }
     
     }
     
     }
     }else if (indexPath.section == 1){
     [self pushViewControllerWithName:@"FiatTransactionRecordsIndecVC"];
     }else if (indexPath.section == 2){ // 商家认证
     [self gotoTraderVerificationVC];
     }else if (indexPath.section == 3){ // C2C/B2C支付设置
     [self pushViewControllerWithName:@"FiatSetAccountVC"];
     
     }else if (indexPath.section == 4){ // 分享
     MGShareVM *vm = [[MGShareVM alloc] initWithInvitationCode:[TWUserDefault UserDefaultObjectForUserModel].myInviteCode];
     MGShareVC *vc = [[MGShareVC alloc] initWithViewModel:vm];
     [self.navigationController pushViewController:vc animated:YES];
     } else if(indexPath.section == 5){//设置
     [self pushViewControllerWithName:@"PersonalSettingsIndexVC"];
     }
     */
}

- (void)gotoTraderVerificationVC
{
    MGMerchantsApplyStatus applyStatus = [TWUserDefault UserDefaultObjectForUserModel].isApplyForMerchart;
    NSString *sectionTitleText = @"";
    switch (applyStatus) {
        case MGMerchantsNotApply:
        {
            sectionTitleText = @"";
        }
            break;
        case MGMerchantsApplying:
        {
            sectionTitleText = @"";
        }
            break;
        case MGMerchantsApplySuccess:
        {
            sectionTitleText = kLocalizedString(@"恭喜您已通过审核");
        }
            break;
        case MGMerchantsApplyFailed:
        {
            sectionTitleText = [TWUserDefault UserDefaultObjectForUserModel].summary;
        }
            break;
    }
    MGTraderVerificationVM *vm = [[MGTraderVerificationVM alloc] initWithSectionTitleText:sectionTitleText applyStatus:applyStatus];
    MGTraderVerificationVC *vc = [[MGTraderVerificationVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}


-(UserInformationVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[UserInformationVM alloc]init];
    }
    return _viewModel;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(16))];
        _tableFooterView.backgroundColor = [UIColor clearColor];
    }
    return _tableFooterView;
}


@end
