// MGC
//
// FiatadvertisingPublishVC.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatadvertisingPublishVC.h"
#import "FiatFootSuspensionView.h"
#import "FiatadvertisingSection0.h"
#import "FiatMethodPaymentHeadView.h"
#import "FiatPayMethodNormalCell.h"
#import "FiatPayCardValidatorCell.h"
#import "FiatPayZFBValidatorCell.h"
#import "FiatpriceAmountCell.h"
#import "FiatMinimumCell.h"
#import "FiatMaximumCell.h"
#import "TTWActionSheetView.h"
#import "AdvertisingPublicView.h"
#import "FiatSetZFBVC.h"
#import "FiatadvertisingPublishVM.h"
#import "MGAdPayWayModel.h"
#import "FiatTransactionRecordsVM.h"
#import "FiatSetBankVC.h"
#import "AllCurrencyModels.h"
#import "AdvertisingPublicViewModel.h"
#import "FiatTransactionRecordsIndecVC.h"
#import "MGInternationalPriceModel.h"
#import "FiatFloatPriceCell.h"
#import "NSString+QSExtension.h"
#import "MGTraderVerificationVC.h"


//银行的信息
#define MGBank @"bank"
//微信的信息
#define MGMicro @"micro"
///支付宝的信息
#define MGPay @"pay"
///添加支付方式
#define MGAddPaywayCellID @"FiatPayMethodNormalCell"
#define kSectionZeroCell @"sectionZeroCell"
#define kCardBankCell @"cardBankCell"
#define kAliPayOrWechatCell @"aliPayOrWechatCell"
#define kFloatPriceCell @"floatPriceCell"
#define kPriceCell @"priceCell"
#define kMinCell @"minCell"
#define kMaxCell @"maxCell"



@interface FiatadvertisingPublishVC ()<UITableViewDelegate,UITableViewDataSource,FiatFootSuspensionDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * normalSectionView;
@property (nonatomic, strong) FiatFootSuspensionView * footSuspensionView;
@property (nonatomic, strong) FiatMethodPaymentHeadView * payMethHeadView;
@property (nonatomic, strong) UIView * tableHeadView;
@property (nonatomic, strong) FiatadvertisingPublishVM *viewModel;
@property (nonatomic, strong) FiatTransactionRecordsVM *fiatTransactionRecordsVM;
///默认的币种
@property (nonatomic, strong) NSString *defaultTradeTypeStr;
///默认的币种
@property (nonatomic, strong) NSString *defaultCoinTypeStr;
///支付类型
@property (nonatomic, strong) NSDictionary *payWayDic;
///币种列表
@property (nonatomic, strong) NSArray <AllCurrencyModels *> *coinTypeArr;
///当前选择的交易类型
@property (nonatomic, assign) NSInteger currentTradeType;
///当前选择的币种
@property (nonatomic, assign) NSInteger currentCoinType;
///单价
@property (nonatomic, strong) UITextField *priceTextField;
///数量
@property (nonatomic, strong) UITextField *numberTextField;
///最低数量
@property (nonatomic, strong) UITextField *minTextField;
///最低额度
@property (nonatomic, strong) UITextField *minAmountTextField;
///最高数量
@property (nonatomic, strong) UITextField *maxTextField;
///最高额度
@property (nonatomic, strong) UITextField *maxAmountTextField;
///该币种可用数量
@property (nonatomic, strong) NSString *availableNumber;
///银行卡
@property (nonatomic, assign) NSInteger bankNum;
///支付宝
@property (nonatomic, assign) NSInteger aliPayNum;
///微信
@property (nonatomic, assign) NSInteger weCheckNum;
///国际行情价格
@property (nonatomic, strong) MGInternationalPriceModel *internationalPriceModel;
///是否选择国际行情价
@property (nonatomic, assign) BOOL isSelectedInternetionalPrice;
///单价
@property (nonatomic, strong) NSString *textPrice;

@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation FiatadvertisingPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultTradeTypeStr = kLocalizedString(@"买入");
    self.viewModel.buysell = @"1";
    
    [self setUpTableViews];
    [self setUpNavs];
    [self bindGetNewData];
    self.viewModel.tradeCode = @"BTC";
    
}
-(void)viewWillAppear:(BOOL)animated
{
    ///获取支付方式
    @weakify(self)
    [self.viewModel.payWaySignal subscribeNext:^(id x) {
        @strongify(self)
        self.payWayDic = x;
        [self.tableView reloadData];
    }];
    
    // 获取商家申请信息
    [self getTraderVerificationStatus];
}

#pragma mark -- 获得商家认证状态

- (void)getTraderVerificationStatus
{
    @weakify(self)
    [self.viewModel.getForMerChartSignal subscribeNext:^(id response) {
        @strongify(self)
        NSNumber *applyStatus = response[response_data][@"applyStatus"];
        self.viewModel.applyStatus = [applyStatus integerValue];
        self.viewModel.summary = response[response_data][@"summary"];
        switch (self.viewModel.applyStatus) {
            case MGMerchantsNotApply:
            {
                [self showTableHeadView:YES];
                self.infoLabel.text = kLocalizedString(@"申请成为商家后，交易额度无上限，前往商家认证");
                [self.infoLabel setAttributedText:[self.infoLabel.text changeSubStr:kLocalizedString(@"商家认证") subStrColor:kRedColor]];

            }
                break;
            case MGMerchantsApplying:
            {
                [self showTableHeadView:YES];
                self.infoLabel.text = kLocalizedString(@"申请成为商家后，交易额度无上限，商家认证中");
                [self.infoLabel setAttributedText:[self.infoLabel.text changeSubStr:kLocalizedString(@"商家认证") subStrColor:kRedColor]];
            }
                break;
            case MGMerchantsApplySuccess:
            {
                [self showTableHeadView:NO];
            }
                break;
           case MGMerchantsApplyFailed:
            {
                [self showTableHeadView:YES];
                self.infoLabel.text = kLocalizedString(@"申请成为商家后，交易额度无上限，请重新商家认证");
                [self.infoLabel setAttributedText:[self.infoLabel.text changeSubStr:kLocalizedString(@"商家认证") subStrColor:kRedColor]];

            }
                break;
        }
    } error:^(NSError *error) {
        @strongify(self)
        // 您还不是商家
        NSNumber *code = [error.userInfo objectForKey:@"code"];
        if ([code integerValue] == 318) {
            [self showTableHeadView:YES];
            self.infoLabel.text = kLocalizedString(@"申请成为商家后，交易额度无上限，前往商家认证");
            [self.infoLabel setAttributedText:[self.infoLabel.text changeSubStr:kLocalizedString(@"商家认证") subStrColor:kRedColor]];
        }
    }];
}
#pragma mark -- 获取币种
- (void)bindGetNewData{
    ///获取币种
    @weakify(self);
    [self.fiatTransactionRecordsVM.allCurrencySignal subscribeNext:^(NSMutableArray * currencySource) {
        @strongify(self);
        self.coinTypeArr = currencySource;
        self.defaultCoinTypeStr = self.coinTypeArr[0].shortName;
        self.viewModel.tradeCode = self.defaultCoinTypeStr;
        [self.tableView reloadData];
        [self getCoinNumber];

    }];
}
#pragma mark -- 查询国际价格
- (void)checkPrice
{
    @weakify(self);
    [self.viewModel.getPriceSignal subscribeNext:^(id x) {
        @strongify(self);
        self.internationalPriceModel = x;
        [self.tableView reloadData];
    }];
}
/**
 获取币种的可用数量
 */
- (void)getCoinNumber
{
    @weakify(self);
    [self.viewModel.getCionNumberSignal subscribeNext:^(id x) {
        @strongify(self);
        self.availableNumber = [NSString stringWithFormat:@"%@",x];
        self.minTextField.text = nil;
        self.minAmountTextField.text = nil;
        self.maxTextField.text = nil;
        self.maxAmountTextField.text = nil;
        self.numberTextField.text = nil;
        self.priceTextField.text = nil;
        self.textPrice = nil;
        [self.tableView reloadData];
        [self checkPrice];
    }];
    
}
-(void)setUpTableViews{
    
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    self.tableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 53, 0));
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;

    //分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = UIColorFromRGB(0xdddddd);
    self.tableView.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.tableView registerClass:[FiatadvertisingSection0 class] forCellReuseIdentifier:kSectionZeroCell];
    [self.tableView registerClass:[FiatPayMethodNormalCell class] forCellReuseIdentifier:MGAddPaywayCellID];
    [self.tableView registerClass:[FiatPayCardValidatorCell class] forCellReuseIdentifier:kCardBankCell];
    [self.tableView registerClass:[FiatPayZFBValidatorCell class] forCellReuseIdentifier:kAliPayOrWechatCell];
    [self.tableView registerClass:[FiatFloatPriceCell class] forCellReuseIdentifier:kFloatPriceCell];
    [self.tableView registerClass:[FiatpriceAmountCell class] forCellReuseIdentifier:kPriceCell];
    [self.tableView registerClass:[FiatMinimumCell class] forCellReuseIdentifier:kMinCell];
    [self.tableView registerClass:[FiatMaximumCell class] forCellReuseIdentifier:kMaxCell];
    
    [self.view addSubview:self.footSuspensionView];
    
    [self.footSuspensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
}


/**
 是否显示表格头部视图

 @param isShow YES 显示 NO 不显示
 */
- (void)showTableHeadView:(BOOL)isShow
{
    if (isShow) {
        self.tableView.tableHeaderView = self.tableHeadView;
    }else{
        self.tableView.tableHeaderView = nil;
    }
    [self.tableView reloadData];
}

-(void)setUpNavs{
    
    self.title = kLocalizedString(@"广告发布");
    [self addRightBarButtonItemWithTitle:kLocalizedString(@"发布记录") action:@selector(rightItemClick)];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return self.payMethHeadView;
    }
    return self.normalSectionView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
   
    UIView  *normalSectionView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"normalSectionView"];
    if (normalSectionView == nil) {
        normalSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
    }
    normalSectionView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    return normalSectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   if(section == 1){
        return Adapted(48);
    }
    //return CGFLOAT_MIN;
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return Adapted(6);
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 1;
    }else if (section == 4){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0){
        FiatadvertisingSection0 * cell = [tableView dequeueReusableCellWithIdentifier:kSectionZeroCell];
        if(indexPath.row == 0){
            cell.titleLabel.text = kLocalizedString(@"交易类型");
            cell.subLabel.text = self.defaultTradeTypeStr;
            cell.subLabel.textColor = [self.defaultTradeTypeStr isEqualToString:kLocalizedString(@"买入")] ? kGreenColor : kRedColor;
            cell.lineView.hidden = NO;
        }else{
            cell.titleLabel.text = kLocalizedString(@"选择币种");
            cell.subLabel.text = self.defaultCoinTypeStr;
            cell.lineView.hidden = YES;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            MGAdPayWayModel *model = self.payWayDic[MGBank];
            if (model.payeeAccount.length > 0) {//存在收款账号
                FiatPayCardValidatorCell * cell = [tableView dequeueReusableCellWithIdentifier:kCardBankCell];
                cell.model = self.payWayDic[MGBank];
                cell.selectBlock = ^(BOOL selected) {
                    self.bankNum = selected?1:0;
                };
                cell.lineView.hidden = NO;
                return cell;
            }else{//不存在则显示去添加
                return [self getAddPaywayCellWithType:ViaBankCard];
            }
        }else if(indexPath.row == 1){
            MGAdPayWayModel *model = self.payWayDic[MGPay];
            if (model.payeeAccount.length > 0) {
                model.bankName = kLocalizedString(@"支付宝");
                FiatPayZFBValidatorCell * cell = [tableView dequeueReusableCellWithIdentifier:kAliPayOrWechatCell];
                cell.model = self.payWayDic[MGPay];
                cell.selectBlock = ^(BOOL selected) {
                    self.aliPayNum = selected?2:0;
                };
                cell.lineView.hidden = NO;
                return cell;
            }else{
                return [self getAddPaywayCellWithType:ViaAliPay];
            }
            
        }else{
             MGAdPayWayModel *model = self.payWayDic[MGMicro];
            if (model.payeeAccount.length > 0) {
                FiatPayZFBValidatorCell * cell = [tableView dequeueReusableCellWithIdentifier:kAliPayOrWechatCell];
                model.bankName = kLocalizedString(@"微信");
                cell.model = self.payWayDic[MGMicro];
                cell.selectBlock = ^(BOOL selected) {
                    self.weCheckNum = selected?4:0;
                };
                cell.lineView.hidden = YES;
                return cell;
            }else{
                
                return [self getAddPaywayCellWithType:ViaWeChat];
            }
        }
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {//按市价浮动
            FiatFloatPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:kFloatPriceCell];
            KWeakSelf;
            cell.selectBlock = ^(BOOL selected) {
                [self checkPrice];
                self.isSelectedInternetionalPrice = selected;
                cell.lineView.hidden = selected;
                [weakSelf updatePriceCell];
                [self.tableView reloadData];
            };
            return cell;
        }else{
            FiatpriceAmountCell * cell = [tableView dequeueReusableCellWithIdentifier:kPriceCell];
            self.priceTextField = cell.prictTextFiled;
            [RACAble(self, defaultTradeTypeStr) subscribeNext:^(id x) {
                if (self.isSelectedInternetionalPrice) {
                    self.priceTextField.textColor = kTextBlackColor;
                }else{
                    self.priceTextField.textColor = [x isEqualToString:kLocalizedString(@"买入")] ? kGreenColor : kRedColor;
                }
            }];
            self.numberTextField = cell.numberTextFiled;
            cell.coinTypeLab.text = self.defaultCoinTypeStr;
            cell.hintLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"该币种可用数量:"),kNotNumber([self.availableNumber keepDecimal:8])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.priceTextField.didChangeBlock = ^(NSString *text){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                FiatMinimumCell * minCell = [tableView cellForRowAtIndexPath:indexPath];
                indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
                FiatMaximumCell * maxCell = [tableView cellForRowAtIndexPath:indexPath];
                self.textPrice = text;
                minCell.price = cell.prictTextFiled.text;
                maxCell.price = cell.prictTextFiled.text;
                self.minTextField.text = nil;
                self.minAmountTextField.text  = nil;
                self.maxTextField.text  = nil;
                self.maxAmountTextField.text  = nil;
            };
            [self updatePriceCell];
            return cell;
        }
        
    }else if(indexPath.section == 3){
        FiatMinimumCell * cell = [tableView dequeueReusableCellWithIdentifier:kMinCell];
        self.minTextField = cell.minNumerTextField;
        self.minAmountTextField = cell.minAountField;
        cell.unitRight.text = self.defaultCoinTypeStr;
        NSString *price = self.isSelectedInternetionalPrice?self.internationalPriceModel.close:self.priceTextField.text;
        cell.price = price;
        return cell;
        
    }else if(indexPath.section == 4){
        FiatMaximumCell * cell = [tableView dequeueReusableCellWithIdentifier:kMaxCell];
        self.maxTextField = cell.maxNumberTextField;
        self.maxAmountTextField = cell.maxAountField;
        cell.unitRight.text = self.defaultCoinTypeStr;
        NSString *price = self.isSelectedInternetionalPrice?self.internationalPriceModel.close:self.priceTextField.text;
        cell.price = price;

        return cell;
        
    }
    return nil;
}
- (id)getAddPaywayCellWithType:(MGPayWay)payWay{
    FiatPayMethodNormalCell * cell = [self.tableView dequeueReusableCellWithIdentifier:MGAddPaywayCellID];
    cell.payWay = payWay;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(payWay == ViaWeChat){
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            NSArray * arr = @[kLocalizedString(@"买入"),kLocalizedString(@"卖出")];
            [self changeBuyOrSellClick:self.currentTradeType type:0 arr:arr indexPath:indexPath];
        }else{
            NSMutableArray *arr = [NSMutableArray new];
            for (AllCurrencyModels *model in self.coinTypeArr) {
                [arr addObject:model.shortName];
            }
            [self changeBuyOrSellClick:self.currentCoinType  type:1 arr:arr indexPath:indexPath];
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            MGAdPayWayModel *model = self.payWayDic[MGBank];
            if (model.payeeAccount.length < 1) {
                FiatSetBankVC * vc = [[FiatSetBankVC alloc]init];
                vc.payType = @"1";
                vc.changeStatus = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (indexPath.row == 1){
            MGAdPayWayModel *model = self.payWayDic[MGPay];
            if (model.payeeAccount.length < 1) {
                FiatSetZFBVC * vc = [[FiatSetZFBVC alloc]init];
                vc.payType = @"2";
                vc.changeStatus = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }
            
         
        }else if (indexPath.row == 2){
            MGAdPayWayModel *model = self.payWayDic[MGMicro];
            if (model.payeeAccount.length < 1) {
                FiatSetZFBVC * vc = [[FiatSetZFBVC alloc]init];
                vc.payType = @"3";
                vc.changeStatus = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        
    }
}


#pragma mark-- ButtonClick

-(void)rightItemClick{

    FiatTransactionRecordsIndecVC * vc =[[FiatTransactionRecordsIndecVC alloc]init];
    vc.isFromAdvertising = YES;
    [self.navigationController pushViewController:vc animated:YES]; 
}

- (void)updatePriceCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
     FiatpriceAmountCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ( self.isSelectedInternetionalPrice) {
        self.textPrice = nil;
        self.priceTextField.text = [NSString stringWithFormat:@"(%@)%@",kLocalizedString(@"市价"),kNotNumber(self.internationalPriceModel.close)];
        self.priceTextField.enabled = NO;
        self.priceTextField.textColor = kTextBlackColor;
        cell.priceBgView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        cell.priceLineView.hidden = YES;
    }else{
        self.priceTextField.text = self.textPrice;
        self.priceTextField.enabled = YES;
        self.priceTextField.textColor = [self.defaultTradeTypeStr isEqualToString:kLocalizedString(@"买入")] ? kGreenColor : kRedColor;;
        cell.priceBgView.backgroundColor = white_color;
        cell.priceLineView.hidden = NO;
    }
    
}
-(void)changeBuyOrSellClick:(NSInteger) index type:(NSInteger)actionSheetType arr:(NSArray *)arr indexPath:(NSIndexPath *)indexPath{
    

    @weakify(self);
    TTWActionSheetView * sheetView = [[TTWActionSheetView alloc]initWithTitle:@"" selectIndex:index cancelButtonTitle:kLocalizedString(@"取消")  destructiveButtonTitle:@"" otherButtonTitles:arr handler:^(TTWActionSheetView *actionSheetView, NSInteger buttonIndex) {
        @strongify(self);
        if (actionSheetType == 0) {//交易类型:0:交易类型，1:选择币种
            switch (buttonIndex) {
                case 0://买入
                {
                    self.currentTradeType = buttonIndex;
                    self.viewModel.buysell = @"1";
                    self.defaultTradeTypeStr = kLocalizedString(@"买入");
                }
                    break;
                case 1://卖出
                {
                    self.currentTradeType = buttonIndex;
                    self.viewModel.buysell = @"2";
                    self.defaultTradeTypeStr = kLocalizedString(@"卖出");
                    
                }
                    break;
                    
                default:
                    break;
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

        }else{//币种
            self.currentCoinType = buttonIndex;
            self.defaultCoinTypeStr = self.coinTypeArr[self.currentCoinType].shortName;
            self.viewModel.tradeCode = self.defaultCoinTypeStr;
            [self checkPrice];
            [self getCoinNumber];
        }
        
    }];
    [sheetView show];
}
- (NSString*)getPayWay
{
    NSString *payWay = kLocalizedString(@"银行卡");
    switch ([self.viewModel.payVal integerValue]) {
        case 2:
            payWay = kLocalizedString(@"支付宝");
            break;
        case 3:
            payWay = kLocalizedString(@"银行卡、支付宝");
            break;
        case 4:
            payWay = kLocalizedString(@"微信");
            break;
        case 5:
            payWay = kLocalizedString(@"银行卡、微信");
            break;
        case 6:
            payWay = kLocalizedString(@"支付宝、微信");
            break;
        case 7:
            payWay = kLocalizedString(@"银行卡、支付宝、微信");
            break;
        default:
            break;
    }
    return payWay;
}
#pragma mark-- button delegate
-(void)sendValueLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 提交
 */
- (void)sendValueRightClick{
    if ((self.bankNum+self.aliPayNum+self.weCheckNum) == 0) {
        [TTWHUD showCustomMsg:kLocalizedString(@"请选择支付方式")];
        return;
    }
    if (!self.isSelectedInternetionalPrice && [self.priceTextField.text doubleValue] <= 0) {
        [TTWHUD showCustomMsg:kLocalizedString(@"请输入单价")];
        return;
    }
    NSString *price = self.isSelectedInternetionalPrice?self.internationalPriceModel.close:self.priceTextField.text;
    
    if ([self.numberTextField.text doubleValue] <= 0) {
        [TTWHUD showCustomMsg:kLocalizedString(@"数量必须大于0")];
        return;
    }
    if ([self.viewModel.buysell isEqualToString:@"2"]) {//卖出才需要校验
        if ([self.numberTextField.text doubleValue] > [self.availableNumber doubleValue]) {
            [TTWHUD showCustomMsg:kLocalizedString(@"数量不能超过该币种可用数量")];
            return;
        }
    }
    double total = ([price doubleValue] * [self.numberTextField.text doubleValue]);
    if ( [TWUserDefault UserDefaultObjectForUserModel].isMerchants == 1) {//商家
        if (total > 1000000000000) {
            [TTWHUD showCustomMsg:kLocalizedString(@"总价不能超过1000000000000CNY")];
            return;
        }
    }else{//非商家
        if (total > 100000) {
            [TTWHUD showCustomMsg:kLocalizedString(@"总价不能超过100000CNY")];
            return;
        }
    }

    if (([price doubleValue] * [self.numberTextField.text doubleValue]) < 100) {
        [TTWHUD showCustomMsg:kLocalizedString(@"总价不能小于100CNY")];
        return;
    }
    if ([self.minAmountTextField.text doubleValue] < 100) {
        [TTWHUD showCustomMsg:kLocalizedString(@"最小额度不能小于100CNY")];
        return;
    }
    if ([self.minAmountTextField.text doubleValue] > ([price doubleValue] * [self.numberTextField.text doubleValue])) {
        [TTWHUD showCustomMsg:kLocalizedString(@"最小额度不能大于总价")];
        return;
    }
    
    self.viewModel.tradeCode = self.defaultCoinTypeStr;
    self.viewModel.priceVal = price;
    self.viewModel.salesVal = self.numberTextField.text;
    self.viewModel.lowVal = self.minTextField.text;
    self.viewModel.hightVal = self.maxTextField.text;
    self.viewModel.payVal = [NSString stringWithFormat:@"%ld",self.bankNum+self.aliPayNum+self.weCheckNum];
    self.viewModel.type = self.isSelectedInternetionalPrice ? PublicationMarketPriceType : PublicationLimitedPriceType;
#pragma mark -- 发布成功弹出提示
    @weakify(self)
    [self.viewModel.publicSignal subscribeNext:^(id x) {
        @strongify(self)
        //发布成功，弹出提示
        AdvertisingPublicViewModel *model = [AdvertisingPublicViewModel new];
        model.isBuy = [self.viewModel.buysell isEqualToString:@"1"]?YES:NO;
        model.frozen = self.numberTextField.text;
        model.accountName = [TWUserDefault UserDefaultObjectForUserModel].userName;
        model.singlePrice = string(self.priceTextField.text, @"CNY");
        model.number = string(self.numberTextField.text, self.defaultCoinTypeStr);
        NSString *limitPrice = [NSString stringWithFormat:@"%@-%@",self.minAmountTextField.text,self.maxAmountTextField.text];
        model.limitPrice = string(limitPrice, @"CNY");
        model.payWay = [self getPayWay];
        model.symbols = self.defaultCoinTypeStr;
        AdvertisingPublicView * view = [[AdvertisingPublicView alloc]initWithSupView:self.view model:model sureBtnTitle:@"" sureBtnClick:^(NSString *password) {
            [self getCoinNumber];
        } cancelBtnClick:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [view show];
    }];
}

#pragma mark-- 懒加载


-(UIView *)normalSectionView{
    if(!_normalSectionView){
        _normalSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
        _normalSectionView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _normalSectionView;
}

-(FiatMethodPaymentHeadView *)payMethHeadView{
    if(!_payMethHeadView){
        _payMethHeadView = [[FiatMethodPaymentHeadView alloc]init];
        _payMethHeadView.lineView.hidden = NO;
    }
    return _payMethHeadView;
}

- (UIView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(44))];
        _tableHeadView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        UILabel *infoLabel = [[UILabel alloc]init];
        infoLabel.textColor = [UIColor colorWithHexString:@"#2b2c2f"];
        infoLabel.numberOfLines = 0;
        infoLabel.font = H13;
        infoLabel.userInteractionEnabled = YES;
        [_tableHeadView addSubview:infoLabel];
        self.infoLabel = infoLabel;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            [self gotoTraderVerificationVC];
        }];
        [infoLabel addGestureRecognizer:tap];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.right.mas_equalTo(Adapted(-15));
            make.centerY.mas_equalTo(_tableHeadView);
        }];
    }
    return _tableHeadView;
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
            sectionTitleText = self.viewModel.summary;
        }
            break;
    }
    MGTraderVerificationVM *vm = [[MGTraderVerificationVM alloc] initWithSectionTitleText:sectionTitleText applyStatus:applyStatus];
    MGTraderVerificationVC *vc = [[MGTraderVerificationVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}

-(FiatFootSuspensionView *)footSuspensionView{
    if(!_footSuspensionView){
        _footSuspensionView = [[FiatFootSuspensionView alloc] initWithFrame:CGRectZero];
        _footSuspensionView.tradingSellStatusType = Sell_Complaint;
        _footSuspensionView.btnDelegate = self;
         [_footSuspensionView.buttonOne setTitle:kLocalizedString(@"发布") forState:UIControlStateNormal];
        _footSuspensionView.buttonOne.backgroundColor = kGreenColor;
        
    }
    return _footSuspensionView;
}
- (FiatadvertisingPublishVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [FiatadvertisingPublishVM new];
    }
    return _viewModel;
}
-(FiatTransactionRecordsVM *)fiatTransactionRecordsVM{
    if(!_fiatTransactionRecordsVM){
        _fiatTransactionRecordsVM = [[FiatTransactionRecordsVM alloc]init];
    }
    return _fiatTransactionRecordsVM;
}
@end
