// MGC
//
// FiatTradingVC.m
// MGCEX
//
// Created by MGC on 2018/5/27.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTradingVC.h"
#import "FiatTradingHeadView.h"
#import "FiatTradingInfoCell.h"
#import "FiatCodeHeadVIew.h"
#import "FiatIdentificationCodeCell.h"
#import "FiatBankCardCell.h"
#import "FiatZfbWxCell.h"
#import "FiatTradingModel.h"
#import "FiatFootSuspensionView.h"
#import "FiatTransCodedetailsVM.h"
#import "FiatSetAccountVM.h"
#import "FiatSetAccountModel.h"
#import "LookQrCodeView.h"
#import "CancelDealView.h"
#import "ApplyRemindView.h"
#import "FiatComplainVC.h"
#import "MGComplainRecordVC.h"

@interface FiatTradingVC ()<UITableViewDelegate,UITableViewDataSource,lookCodeImageDelegate,FiatFootSuspensionDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) FiatSetAccountVM * fiatSetAccountVM;
@property (nonatomic, strong) FiatTradingModel *  tradingModel;
@property (nonatomic, strong) FiatCodeHeadVIew * codeHeadView;
@property (nonatomic, strong) UIView * normalSectionView;
@property (nonatomic, strong) FiatFootSuspensionView * footSuspensionView;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) FiatTransCodedetailsVM * viewModel;
@property (nonatomic, strong) FiatTradingModel * model;
@property (nonatomic, strong) FiatSetAccountModel *  accountModel;
@property (nonatomic, strong) accountBankModel * bankModel;
@property (nonatomic, strong) accountZfbModel * zfbModel;
@property (nonatomic, strong) accountWxModel * wxModel;
@property (nonatomic, strong) FiatTradingHeadView * headTableView;
@property (nonatomic, assign) BOOL isBankCard;
@property (nonatomic, assign) BOOL isZFB;
@property (nonatomic, assign) BOOL isWX;
@property (nonatomic, strong) NSMutableArray * payMethodArr;
@property (nonatomic, assign, getter=isSeller) BOOL seller;
@end

@implementation FiatTradingVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNewData];
}

//获取支付方式
-(void)getPaymethodData{
    
    if([self.model.buysell isEqualToString:@"1"]){//买家
        self.fiatSetAccountVM.tradingUserid = self.model.tradingUserid;
    } else if ([self.model.buysell isEqualToString:@"2"]){//卖家
        self.fiatSetAccountVM.tradingUserid = self.model.userId;
    }

    //订阅信号
    @weakify(self);
    [self.fiatSetAccountVM.getAccountSignal subscribeNext:^(FiatSetAccountModel * model) {
        @strongify(self);
        self.accountModel = model;
        self.bankModel = model.bank;
        self.zfbModel = model.pay;
        self.wxModel = model.micro;
        
        [self.payMethodArr removeAllObjects];
        if(self.bankModel.payeeAccount.length>0){
            [self.payMethodArr addObject:@"isBankCard"];
            self.isBankCard = YES;
        }else{
            self.isBankCard = NO;
        }

        if(self.zfbModel.payeeAccount.length>0){
            [self.payMethodArr addObject:@"isZFB"];
            self.isZFB = YES;
        }else{
            self.isZFB = NO;
        }
        
        if(self.wxModel.payeeAccount.length>0){
            [self.payMethodArr addObject:@"isWX"];
            self.isWX = YES;
        }else{
            self.isWX = NO;
        }

        [self.tableView reloadData];
        
    }];
}

//获取数据源
-(void)getNewData{
    
    self.viewModel.tradeOrderId = self.tradeOrderId;
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.refreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(FiatTradingModel * model) {
            @strongify(self);
  
            self.model = model;
        
            if([self.model.buysell isEqualToString:@"1"]){//买家
                self.seller = NO;
            } else if ([self.model.buysell isEqualToString:@"2"]){//卖家
                self.seller = YES;
            }
            //配置头部view状态
            self.headTableView.model = model;
            /*
            float height = [UIView getLabelHeightByWidth:MAIN_SCREEN_WIDTH-Adapted(48) Title:model.promptRed font:H15];
            
            

            if(model.reTime.floatValue>0){

                [self.headTableView setFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(130)+height)];
                [self.headTableView.frontView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(Adapted(50)+height);
                }];
            }else{
    
                [self.headTableView setFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(110)+height)];
                [self.headTableView.frontView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(Adapted(30)+height);
                }];
                
                [self.headTableView.msgLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(Adapted(15));
                }];
            }
            
            [self.view layoutIfNeeded];
  */
            //配置底部按钮状态
            [self configFootViewWithModel:model];
            //获取支付方式(买家交易记录下)
            if(!self.seller)[self getPaymethodData];
            
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
    
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
    
    //开始刷新
    [self.viewModel.refreshCommand execute:kIsRefreshY];
}

//标记为已付款已收款
-(void)markPaymentReceived{
    
    //订阅信号
    @weakify(self);
    [self.viewModel.markedPaySignal subscribeNext:^(id x) {
        @strongify(self);
        
        //开始刷新
        [self.viewModel.refreshCommand execute:kIsRefreshY];
        
    }];
    
}

//取消交易
-(void)cancelTrans{
    
    //订阅信号
    @weakify(self);
    [self.viewModel.cancelTransSignal subscribeNext:^(id x) {
        @strongify(self);
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        //开始刷新
        [self.viewModel.refreshCommand execute:kIsRefreshY];
        
    }];
    
}
-(void)configFootViewWithModel:(FiatTradingModel * )model{
 
    
    if([model.buysell integerValue] == 1){//买
        //订单状态
        if([model.orderStatus integerValue] == 1){
            //待付款
            self.footSuspensionView.tradingBuyStatusType = Buy_AlreadyPayment;
        }else if ([model.orderStatus integerValue] == 2 ){//已付款
            if([model.reTime integerValue] >0){
                //没到20分钟发起申诉,提醒弹框
                self.footSuspensionView.tradingBuyStatusType = Buy_BeforeTime;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 52, 0));
                }];
            }else{
                //已过20分钟
                self.footSuspensionView.tradingBuyStatusType = Buy_AfterTime;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 52, 0));
                }];
            }
            
            
            if([model.appealStatus integerValue] == 1){
                //没有申诉申诉状态
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 52, 0));
                }];
               
            }else if ([model.appealStatus integerValue] == 2){
                //申诉中
                self.footSuspensionView.tradingBuyStatusType = Buy_ComplaintRecord;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 3){
                //被申诉
                self.footSuspensionView.tradingBuyStatusType = Buy_BeComplaint;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 4){
                //回诉中
                self.footSuspensionView.tradingBuyStatusType = Buy_BeComplaintRecord;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 5){
                //申诉被驳回
                self.footSuspensionView.tradingBuyStatusType = Buy_ComplaintRejected;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 6){
                //回诉被驳回
                self.footSuspensionView.tradingBuyStatusType = Buy_BeComplaintRejected;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }
            
        }else if ([model.orderStatus integerValue] == 3){//已完成
            self.footSuspensionView.tradingBuyStatusType = Buy_AlreadyComplete;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }else if ([model.orderStatus integerValue] == 6){//已取消
            self.footSuspensionView.tradingBuyStatusType = Buy_AlreadyComplete;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
        
     
    }else{//卖
        
        //订单状态
        if([model.orderStatus integerValue] == 1){
            self.footSuspensionView.tradingSellStatusType = Sell_AlreadyPayment;
        }else if ([model.orderStatus integerValue] == 2){
            if([model.reTime integerValue] >0){
                //没到20分钟发起申诉,提醒弹框
                self.footSuspensionView.tradingSellStatusType = Sell_BeforeTime;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 52, 0));
                }];
            }else{
                //已过20分钟
                self.footSuspensionView.tradingSellStatusType = Sell_AfterTime;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 52, 0));
                }];
            }
            
            
            if([model.appealStatus integerValue] == 1){
                //没有被申诉
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 52, 0));
                }];
     
            }else if ([model.appealStatus integerValue] == 2){
                //被申诉，发起回诉
                self.footSuspensionView.tradingSellStatusType = Sell_BeComplaint;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 3){
                //申诉中，查看申诉记录
                self.footSuspensionView.tradingSellStatusType = Sell_ComplaintRecord;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 4){
                //回诉中，查看回诉记录
                self.footSuspensionView.tradingSellStatusType = Sell_ResertComplaintRecord;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 5){
                //申诉被驳回，重新申诉
                self.footSuspensionView.tradingSellStatusType = Sell_ComplaintRejected;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }else if ([model.appealStatus integerValue] == 6){
                //回诉被驳回 重新回诉
                self.footSuspensionView.tradingSellStatusType = Sell_BeComplaintRejected;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 83, 0));
                }];
            }
            
        }else if ([model.orderStatus integerValue] == 3){
            self.footSuspensionView.tradingSellStatusType = Sell_AlreadyComplete;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }else if ([model.orderStatus integerValue] == 6){
            self.footSuspensionView.tradingSellStatusType = Sell_AlreadyComplete;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
     
        
    }
    
    
}

#pragma mark - 下拉刷新
- (void)dropDownToRefreshData
{
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        //开始刷新
        [self.viewModel.refreshCommand execute:kIsRefreshY];
    }];
    
    // 设置自动切换透明度
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置header
    self.tableView.mj_header = header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpTableViews];
    [self dropDownToRefreshData];
    [self.view addSubview:self.footSuspensionView];
    [self.footSuspensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloTableViewTime) name:krelodeOrderTime object:nil];
    
}

-(void)reloTableViewTime{
    //刷新列表
    [self.viewModel.refreshCommand execute:kIsRefreshY];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpTableViews{
    
    self.title = kLocalizedString(@"交易详情");
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 85, 0));
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedSectionHeaderHeight = 44.0f;
    //解决折叠动画跳动 问题
    self.tableView.estimatedSectionFooterHeight = 0.f;
    self.tableView.sectionFooterHeight = 0.f;
    //分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGB(0xdddddd);
    self.tableView.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.headTableView = [[FiatTradingHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(92))];
    self.tableView.tableHeaderView = self.headTableView;
    
    [self.tableView registerClass:[FiatTradingInfoCell class] forCellReuseIdentifier:@"cellInfo"];
    [self.tableView registerClass:[FiatIdentificationCodeCell class] forCellReuseIdentifier:@"codeCell"];
    [self.tableView registerClass:[FiatBankCardCell class] forCellReuseIdentifier:@"bankCell"];
    [self.tableView registerClass:[FiatZfbWxCell class] forCellReuseIdentifier:@"zfbCell"];
    
    //测试数据
    self.tradingModel = [FiatTradingModel new];
    self.tradingModel.isShow = NO;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 2){
      
        self.codeHeadView.backgroundColor = white_color;
        self.codeHeadView.codeLabel.text = self.model.payIdentificationCode;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewShow:)];
        [self.codeHeadView addGestureRecognizer:tap];
        self.codeHeadView.jiantouBtn.hidden = self.isSeller;
        self.codeHeadView.userInteractionEnabled = !self.isSeller;
        return self.codeHeadView;
    }

    return self.normalSectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(section == 1){
        return Adapted(6);
    }
    else if(section == 2){
        return Adapted(48);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0){
        return 6;
    }else if (section == 1){
        return self.seller ? 2 : 1;
    }else if (section == 2){
      
        return self.tradingModel.isShow? 1:0;
    }else if (section == 3){
       return  self.payMethodArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0){
        FiatTradingInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfo"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0){
            cell.leftLabel.text = kLocalizedString(@"交易单价");
            cell.rightLabel.text = [NSString stringWithFormat:@"%@CNY",self.model.priceVal];
        } else if(indexPath.row == 1){
            cell.leftLabel.text = kLocalizedString(@"交易数量");
            cell.rightLabel.text =  [NSString stringWithFormat:@"%@%@",self.model.tradeQuantity, self.model.tradeCode];
        } else if (indexPath.row == 2){
            cell.leftLabel.text = kLocalizedString(@"交易总价");
            cell.rightLabel.text = [NSString stringWithFormat:@"%@CNY",self.model.tradeAmount];
        } else if(indexPath.row == 3){
            cell.leftLabel.text = kLocalizedString(@"交易号");
            cell.rightLabel.text = self.model.tradeOrderId;
        } else if(indexPath.row == 4){
            cell.leftLabel.text = kLocalizedString(@"创建时间");
            cell.rightLabel.text =  self.model.orderTime;
        } else if (indexPath.row == 5){
            cell.leftLabel.text = kLocalizedString(@"交易内容");
            cell.rightLabel.text = self.model.promptNote;
        }
        
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
        }
        return cell;
    }else if (indexPath.section == 1){
        FiatTradingInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfo"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){//卖家名称 买家名称
            if (self.seller) {
                cell.leftLabel.text = kLocalizedString(@"买家名称");
                cell.rightLabel.text = self.model.cueName;
            } else {
                cell.leftLabel.text = kLocalizedString(@"卖家名称");
                cell.rightLabel.text = self.model.shopName;
            }
            cell.lineView.hidden = NO;
        }else if (indexPath.row == 1){//联系买家
            
            cell.leftLabel.text = kLocalizedString(@"联系买家");
            cell.lineView.hidden = NO;
        }
        return cell;
    }else if(indexPath.section == 2){
       
        FiatIdentificationCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"codeCell"];
        @weakify(self);
        cell.closeBlock = ^{
            @strongify(self);
            [self headViewShow:nil];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 3){
        
        if(indexPath.row == 0){
    
            NSString * str = _payMethodArr[0];
            if([str isEqualToString:@"isBankCard"]){
                FiatBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bankCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.bankModel = self.bankModel;
                if(_payMethodArr.count == 1){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
                
            }else if ([str isEqualToString:@"isZFB"]){
                FiatZfbWxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zfbCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.zfbModel = self.zfbModel;
                cell.btnDelegate = self;
                if(_payMethodArr.count == 1){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
                
            }else if ([str isEqualToString:@"isWX"]){
                FiatZfbWxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zfbCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.wxModel = self.wxModel;
                cell.btnDelegate = self;
                if(_payMethodArr.count == 1){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
          
                return cell;
            }
            
            
        }else if (indexPath.row == 1){
            NSString * str = _payMethodArr[1];
            if([str isEqualToString:@"isBankCard"]){
                FiatBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bankCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.bankModel = self.bankModel;
                if(_payMethodArr.count == 2){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
                
            }else if ([str isEqualToString:@"isZFB"]){
                FiatZfbWxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zfbCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.zfbModel = self.zfbModel;
                cell.btnDelegate = self;
                if(_payMethodArr.count == 2){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
                
                
            }else if ([str isEqualToString:@"isWX"]){
                FiatZfbWxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zfbCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.wxModel = self.wxModel;
                cell.btnDelegate = self;
                if(_payMethodArr.count == 2){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
            }
        
        }else if (indexPath.row == 2){
            
            NSString * str = _payMethodArr[2];
            if([str isEqualToString:@"isBankCard"]){
                FiatBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bankCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.bankModel = self.bankModel;
                if(_payMethodArr.count == 3){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
                
            }else if ([str isEqualToString:@"isZFB"]){
                FiatZfbWxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zfbCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.zfbModel = self.zfbModel;
                cell.btnDelegate = self;
                if(_payMethodArr.count == 3){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
                
                
            }else if ([str isEqualToString:@"isWX"]){
                FiatZfbWxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zfbCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.wxModel = self.wxModel;
                cell.btnDelegate = self;
                if(_payMethodArr.count == 3){
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
                }
                return cell;
            }
            
        }
    }
    
    return nil;
}

#pragma mark-- lookCodeImageDelegate

//看二维码。index： 2 支付宝。 3微信
- (void)lookCodeImageWithType:(NSInteger)index{
    
 
    NSString * imageUrl;
    if(index == 2){
        imageUrl = _zfbModel.payeeAccountUrl;
    }else if (index == 3){
        imageUrl = _wxModel.payeeAccountUrl;
    }

    LookQrCodeView * view = [[LookQrCodeView alloc]initWithSupView:self.view imageUrl:imageUrl sureBtnClick:^{

    } cancelBtnClick:^{

    }];
    [view show];
    
}

#pragma mark-- buttonClick
-(void)headViewShow:(UITapGestureRecognizer *)tap{
    
    self.codeHeadView.jiantouBtn.selected = !self.codeHeadView.jiantouBtn.selected;
    if(self.codeHeadView.jiantouBtn.selected == YES){
        self.tradingModel.isShow = YES;
    }else{
        self.tradingModel.isShow = NO;
    }

    [self.tableView beginUpdates];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
     [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
//    [self.tableView reloadData];
}

#pragma mark-- FiatFootSuspensionDelegate
//底部按钮点击事件
//点击右边按钮
- (void)sendValueRightClick{
    
    FiatTradingModel * model = self.model;
    if([model.buysell integerValue] == 1){//买
        //订单状态
        if([model.orderStatus integerValue] == 1){
            //标记为已付款
            [self markPaymentReceived];
            
        }else if ([model.orderStatus integerValue] == 2 ){//已付款
       
            if([model.appealStatus integerValue] == 1){
                //标记为已付款
                if([model.reTime integerValue] >0){
 
                    
                    //没到20分钟发起申诉,提醒弹框
                    ApplyRemindView * view = [[ApplyRemindView alloc]initWithSupView:self.view timeout:self.headTableView.complaintsTimeout sureBtnClick:^{
                        
                    } cancelBtnClick:^{
                        
                    }];
                    
                    [view show];
                    return;
                }else{
                    //跳申诉界面
                    FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                    vc.sellBuy = model.buysell;
                    vc.fiatDealTradeOrderId = self.tradeOrderId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else if ([model.appealStatus integerValue] == 2){
                //申诉中 查看申诉记录
                MGComplainRecordVC * vc = [[MGComplainRecordVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
               
            }else if ([model.appealStatus integerValue] == 3){
                //被申诉 按钮变发起回诉
                FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.appealStatus integerValue] == 4){
                //回诉中  查看回诉记录
                MGComplainRecordVC * vc = [[MGComplainRecordVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
               
            }else if ([model.appealStatus integerValue] == 5){
                //申诉被驳回  重新申诉
                FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
             
            }else if ([model.appealStatus integerValue] == 6){
                //回诉被驳回  重新回诉
                FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
               
            }
            
        }else if ([model.orderStatus integerValue] == 3){//已完成
            self.footSuspensionView.tradingBuyStatusType = Buy_AlreadyComplete;
        }else if ([model.orderStatus integerValue] == 6){//已取消
            self.footSuspensionView.tradingBuyStatusType = Buy_AlreadyComplete;
        }
        
        
    }else{//卖
        
        
        //标记为已收款
        [self markPaymentReceived];
    
    }
}

//点击左边按钮
- (void)sendValueLeftClick{
    
    FiatTradingModel * model = self.model;
    
    if([self.model.buysell integerValue] == 1){
        //买家取消订单
        @weakify(self);
        CancelDealView * view = [[CancelDealView alloc]initWithSupView:self.view sureBtnClick:^{
            @strongify(self);
            [self cancelTrans];
        } cancelBtnClick:^{
            
        }];
        
        [view show];
    } else{
        //卖家申诉
        if ([model.orderStatus integerValue] == 2){
            
            if([model.appealStatus integerValue] == 1){
                //没有被申诉
                if([model.reTime integerValue] >0){
                    //没到20分钟发起申诉,提醒弹框
                    ApplyRemindView * view = [[ApplyRemindView alloc]initWithSupView:self.view timeout:self.headTableView.complaintsTimeout sureBtnClick:^{
                        
                    } cancelBtnClick:^{
                        
                    }];
                    
                    [view show];
                    return;
                }else{
                    //跳申诉界面
                    FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                    vc.sellBuy = model.buysell;
                    vc.fiatDealTradeOrderId = self.tradeOrderId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else if ([model.appealStatus integerValue] == 2){
                //被申诉，发起回诉
                FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.appealStatus integerValue] == 3){
                //申诉中，查看申诉记录
                MGComplainRecordVC * vc = [[MGComplainRecordVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.appealStatus integerValue] == 4){
                //回诉中，查看回诉记录
                MGComplainRecordVC * vc = [[MGComplainRecordVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.appealStatus integerValue] == 5){
                //申诉被驳回，重新申诉
                FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.appealStatus integerValue] == 6){
                //回诉被驳回 重新回诉
                FiatComplainVC * vc = [[FiatComplainVC alloc]init];
                vc.sellBuy = model.buysell;
                vc.fiatDealTradeOrderId = self.tradeOrderId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        }else if ([model.orderStatus integerValue] == 3){
            self.footSuspensionView.tradingSellStatusType = Sell_AlreadyComplete;
        }else if ([model.orderStatus integerValue] == 6){
            self.footSuspensionView.tradingSellStatusType = Sell_AlreadyComplete;
        }
        
    }
    
    
    
}

#pragma mark-- 懒加载
-(FiatCodeHeadVIew *)codeHeadView{
    if(!_codeHeadView){
        _codeHeadView = [[FiatCodeHeadVIew alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(48))];
        
        
        
    }
    return _codeHeadView;
}


-(FiatFootSuspensionView *)footSuspensionView{
    if(!_footSuspensionView){
        _footSuspensionView = [[FiatFootSuspensionView alloc] initWithFrame:CGRectZero];
        _footSuspensionView.btnDelegate = self;
    }
    return _footSuspensionView;
}

-(FiatTransCodedetailsVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[FiatTransCodedetailsVM alloc]init];
    }
    return _viewModel;
}

-(FiatSetAccountVM *)fiatSetAccountVM{
    if(!_fiatSetAccountVM){
        _fiatSetAccountVM = [[FiatSetAccountVM alloc]init];
    }
    return _fiatSetAccountVM;
}

-(NSMutableArray *)payMethodArr{
    if(!_payMethodArr){
        _payMethodArr = [NSMutableArray new];
    }
    return _payMethodArr;
}
@end
