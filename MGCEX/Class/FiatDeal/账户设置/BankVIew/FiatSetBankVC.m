// MGC
//
// FiatSetBankVC.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetBankVC.h"
#import "FiatFootSuspensionView.h"
#import "FiatSetCommonCell.h"
#import "FiatSetRemarkCell.h"
#import "FiatSetVerifierCell.h"
#import "FiatSetAccountVM.h"
#import "RegisterIndexVM.h"
#import "AdvertisingPublicView.h"
#import "FiatSetAccountModel.h"
#import "accountBankModel.h"
#import "accountZfbModel.h"
#import "accountWxModel.h"

@interface FiatSetBankVC ()<UITableViewDelegate,UITableViewDataSource,FiatFootSuspensionDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * normalSectionView;
@property (nonatomic, strong) FiatFootSuspensionView * footSuspensionView;
@property (nonatomic, strong) FiatSetAccountVM * viewModel;

@property (nonatomic, strong) FiatSetAccountModel *  accountModel;
@property (nonatomic, strong) accountBankModel * bankModel;


@end

@implementation FiatSetBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self getNewData];
    [self dropDownToRefreshData];
}

-(void)getNewData{
    
    //订阅信号
    @weakify(self);
    [self.viewModel.getAccountSignal subscribeNext:^(FiatSetAccountModel * model) {
        @strongify(self);
        self.accountModel = model;
        self.bankModel = model.bank;

        [self.tableView reloadData];
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];

}

#pragma mark - 下拉刷新
- (void)dropDownToRefreshData
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewData];
    }];
    
    // 设置自动切换透明度
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置header
    self.tableView.mj_header = header;
}



-(void)setUpViews{
    
    self.title = kLocalizedString(kLocalizedString(@"银行卡"));
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 53, 0));
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    
    //分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGB(0xdddddd);
    self.tableView.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView registerClass:[FiatSetCommonCell class] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerClass:[FiatSetRemarkCell class] forCellReuseIdentifier:@"remarkCell"];
    [self.tableView registerClass:[FiatSetVerifierCell class] forCellReuseIdentifier:@"verifierCell"];
    
    
    [self.view addSubview:self.footSuspensionView];
    [self.footSuspensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    return self.normalSectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0||section == 2){
        return Adapted(6);
    }
    return CGFLOAT_MIN;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return Adapted(48);
    }else if (indexPath.section == 1){
        return Adapted(200);
    }else if (indexPath.section == 2){
        return Adapted(48*3);
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0){
        return 4;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0){
        FiatSetCommonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0){
            cell.titleLabel.text = kLocalizedString(@"收款人");
            cell.subTextFiled.placeholder = kLocalizedString(@"请输入收款人姓名");

            @weakify(self);
            cell.subTextFiled.didChangeBlock = ^(NSString *text) {
                @strongify(self);
                self.viewModel.payeeName = text;
            };
            
            if([self.changeStatus integerValue]==2){
                cell.subTextFiled.text = self.bankModel.payeeName;
                self.viewModel.payeeName = self.bankModel.payeeName;
            }
            
        }else if(indexPath.row == 1){
            cell.titleLabel.text = kLocalizedString(@"收款银行");
            cell.subTextFiled.placeholder = kLocalizedString(@"请输入收款银行");
            @weakify(self);
            cell.subTextFiled.didChangeBlock = ^(NSString *text) {
                @strongify(self);
                self.viewModel.bankName = text;
            };
            
            if([self.changeStatus integerValue]==2){
                cell.subTextFiled.text = self.bankModel.bankName;
                self.viewModel.bankName = self.bankModel.bankName;
            }
            
        }else if(indexPath.row == 2){
            cell.titleLabel.text = kLocalizedString(@"开户支行") ;
            cell.subTextFiled.placeholder = kLocalizedString(@"请输入收款银行开户支行") ;
            @weakify(self);
            cell.subTextFiled.didChangeBlock = ^(NSString *text) {
                @strongify(self);
                self.viewModel.bankBrachName = text;
            };
            
            if([self.changeStatus integerValue]==2){
                cell.subTextFiled.text = self.bankModel.bankBrachName;
                self.viewModel.bankBrachName = self.bankModel.bankBrachName;
            }
            
        }else if(indexPath.row == 3){
            cell.titleLabel.text = kLocalizedString(@"银行卡账号") ;
            cell.subTextFiled.placeholder = kLocalizedString(@"请输入银行卡账号") ;
            @weakify(self);
            cell.subTextFiled.didChangeBlock = ^(NSString *text) {
                @strongify(self);
                self.viewModel.payeeAccount = text;
                
            };
            
            if([self.changeStatus integerValue]==2){
                cell.subTextFiled.text = self.bankModel.payeeAccount;
                self.viewModel.payeeAccount = self.bankModel.payeeAccount;
            }
        }
        
        return cell;
    }else if (indexPath.section == 1){
        FiatSetRemarkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"remarkCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        cell.remarkTextView.isChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.summary = text;
        };
        
        if([self.changeStatus integerValue]==2){
            cell.remarkTextView.text = self.bankModel.summary;
            self.viewModel.summary = self.bankModel.summary;
        }
        
        return cell;
        
    }else{
        
        FiatSetVerifierCell * cell = [tableView dequeueReusableCellWithIdentifier:@"verifierCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        @weakify(self);
        cell.password.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.reMoneyPassword = text;
        };
        
        cell.verifierCode.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.code = text;
        };
        
        cell.verifierBlock = ^(NSString *string) {
            self.viewModel.loginNum = string;
        };
        
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {
            // 1.系统分割线,移到屏幕外
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
            
        }
        return cell;
    }
}

//提交
- (void)sendValueRightClick;{
 
    self.viewModel.status = self.changeStatus;
    self.viewModel.payType = self.payType;
    //订阅信号
    @weakify(self);
    [self.viewModel.setAccountSignal subscribeNext:^(id x) {
        @strongify(self);
        if([self.changeStatus integerValue]== 1){
            [TTWHUD showCustomMsg:@"设置成功"];
        }else{
            [TTWHUD showCustomMsg:kLocalizedString(@"修改成功")];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
        
    }];
}

//取消
- (void)sendValueLeftClick;{
    NSLog(@"22222");
}


#pragma mark-- 懒加载

-(UIView *)normalSectionView{
    if(!_normalSectionView){
        _normalSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
        _normalSectionView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _normalSectionView;
}


-(FiatFootSuspensionView *)footSuspensionView{
    if(!_footSuspensionView){
        _footSuspensionView = [[FiatFootSuspensionView alloc] initWithFrame:CGRectZero];
        _footSuspensionView.tradingSellStatusType = Sell_Complaint;
        _footSuspensionView.btnDelegate = self;
        
    }
    return _footSuspensionView;
}

-(FiatSetAccountVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[FiatSetAccountVM alloc]init];
    }
    return _viewModel;
}
@end
