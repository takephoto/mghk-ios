//
//  MGComplainRecordVC.m
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGComplainRecordVC.h"

#import "FiatComplainVC.h"
#import "FiatComplainHeadView.h"
#import "MGPaymentInfoCell.h"
#import "ACMediaFrame.h"
#import "FiatDetailedInstructionsCell.h"
#import "FiatFootSuspensionView.h"
#import "MGComplainVM.h"
#import "MGCheckComplainModel.h"
#import "MGCheckComplainVM.h"
#import "MGComplainImageCell.h"


@interface MGComplainRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * normalSectionView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) CGFloat mediaH;
@property (nonatomic, strong) ACSelectMediaView *mediaView;
@property (nonatomic, strong) MGCheckComplainVM *viewModel;
@property (nonatomic, strong) MGCheckComplainModel *model;
///查看申诉
@property (nonatomic, strong) MGCheckComplainModel *checkComplainModel;
///支付方式
@property (nonatomic, strong) NSString *payType;
///标签
@property (nonatomic, strong) NSMutableArray *titleArr;
///详细
@property (nonatomic, strong) NSMutableArray *detailArr;
///银行卡
@property (nonatomic, assign) NSInteger bankNum;
///支付宝
@property (nonatomic, assign) NSInteger aliPayNum;
///微信
@property (nonatomic, assign) NSInteger weCheckNum;
@end

@implementation MGComplainRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"申诉");
    self.view.backgroundColor = kBackGroundColor;
    [self getData];
    
}
- (void)getData{
    @weakify(self);
    self.viewModel.sellBuy = self.sellBuy;
    self.viewModel.fiatDealTradeOrderId = self.fiatDealTradeOrderId;
    [self.viewModel.checkComplainSignal subscribeNext:^(id x) {
        @strongify(self);
        self.model = x;
        self.payType = [self payTypeStrArrWithType:self.model.payType];
        [self setUpTableViews];
    }];
}
-(void)setUpTableViews{
    
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 44.0f;//推测高度
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    
    //分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = kLineColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    float footHeight = 0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, footHeight, 0));
    }];
    
    
    [self.tableView registerClass:[MGPaymentInfoCell class] forCellReuseIdentifier:@"MGPaymentInfoCell"];
    [self.tableView registerClass:[FiatDetailedInstructionsCell class] forCellReuseIdentifier:@"FiatDetailedInstructionsCell"];
    [self.tableView registerClass:[MGComplainImageCell class] forCellReuseIdentifier:@"MGComplainImageCell"];
    
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * normalSectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"normalSectionView"];
    if (normalSectionView == nil) {
       normalSectionView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
    }
    if (section == 0 || section == 1) {
        normalSectionView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }else {
        normalSectionView.backgroundColor = white_color;
    }
    return normalSectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0 || section == 1){
        return Adapted(12);
    } else if (section == 2){
        return Adapted(15);
    } else if (section == 3){
        return Adapted(5);
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        return Adapted(230);
    }
    return UITableViewAutomaticDimension;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0){
        return 1;
    }else if (section == 1){
        return self.detailArr.count;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        MGPaymentInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MGPaymentInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoTitleLabel.text = kLocalizedString(@"支付方式");
        cell.infoLabel.text = self.payType;
        cell.lineView.hidden = YES;
        return cell;
    }else if (indexPath.section == 1){
        MGPaymentInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MGPaymentInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoTitleLabel.text = self.titleArr[indexPath.row];
        cell.infoLabel.text = self.detailArr[indexPath.row];
        return cell;
    }else if(indexPath.section == 2){
        
        MGComplainImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MGComplainImageCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageArr = self.model.payeeAccountUrl;
        cell.titleLabel.font = H15;
        cell.titleLabel.textColor = kTextColor;
        return cell;
    }else if(indexPath.section == 3){
        FiatDetailedInstructionsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FiatDetailedInstructionsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.userInteractionEnabled = NO;
        cell.textView.text = self.model.summary;
        [cell needTextViewBorder:NO];
        return cell;
        
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (NSArray *)payTypeStrArrWithType:(NSInteger)type
{
    NSString *payType = @"";
    switch (type) {
        case 1:
            payType = kLocalizedString(@"银行卡支付");
            break;
        case 2:
            payType = kLocalizedString(@"支付宝支付");
            break;
        case 3:
            payType = kLocalizedString(@"微信支付");
            break;
            
        default:
            break;
    }
    return payType;
}

- (NSMutableArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [NSMutableArray new];
        
        if (self.model.payType == 1) { // 银行卡
            if (self.model.bankName.length>0) {
                [_titleArr addObject:kLocalizedString(@"转账银行")];
            }
            if (self.model.bankBrachName.length>0) {
                [_titleArr addObject:kLocalizedString(@"转账银行开户行")];
            }
            if (self.model.transactionNum.length>0) {
                    [_titleArr addObject:@"输入银行账号"];
                }
            }
            if (self.model.fiatDealTradeOrderId.length>0) {
                [_titleArr addObject:kLocalizedString(@"银行交易单号")];
            }
            
        } else if (self.model.payType == 2){ // 支付宝
            if (self.model.payeeName.length>0) {
                [_titleArr addObject:kLocalizedString(@"收款人姓名")];
            }
            if (self.model.payeeAccount.length>0) {
                [_titleArr addObject:kLocalizedString(@"收款人支付宝账号")];
            }
            if (self.model.transactionNum.length>0) {
                [_titleArr addObject:kLocalizedString(@"支付宝订单号")];
            }
        }
        else if (self.model.payType == 2){ // 支付宝
            if (self.model.payeeName.length>0) {
                [_titleArr addObject:kLocalizedString(@"收款人姓名")];
            }
            if (self.model.payeeAccount.length>0) {
                [_titleArr addObject:kLocalizedString(@"收款人微信账号")];
            }
            if (self.model.transactionNum.length>0) {
               [_titleArr addObject:kLocalizedString(@"支付交易单号")];
            }

    }
    
    return _titleArr;
}

- (NSArray *)detailArr
{
    if (!_detailArr) {
        _detailArr = [NSMutableArray new];
        if (self.model.payType == 1) { // 银行卡
            if (self.model.bankName.length>0) {
                [_detailArr addObject:self.model.bankName];
            }
            if (self.model.bankBrachName.length>0) {
                [_detailArr addObject:self.model.bankBrachName];
            }
            if (self.model.transactionNum.length>0) {
                [_detailArr addObject:self.model.transactionNum];
            }
            if (self.model.fiatDealTradeOrderId.length>0) {
                [_detailArr addObject:self.model.fiatDealTradeOrderId];
            }
        } else {
            if (self.model.payeeName.length>0) {
                [_detailArr addObject:self.model.payeeName];
            }
            if (self.model.payeeAccount.length>0) {
                [_detailArr addObject:self.model.payeeAccount];
            }
            if (self.model.transactionNum.length>0) {
                [_detailArr addObject:self.model.transactionNum];
            }
        }
        
        
        
        
        
        
    }
    
    return _detailArr;
}

-(UIView *)normalSectionView{
    if(!_normalSectionView){
        _normalSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
        _normalSectionView.backgroundColor = kRedColor;
    }
    return _normalSectionView;
}
- (MGCheckComplainVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MGCheckComplainVM new];
    }
    return _viewModel;
}







@end

