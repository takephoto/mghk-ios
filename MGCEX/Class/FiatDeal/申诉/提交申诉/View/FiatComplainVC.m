// MGC
//
// FiatComplainVC.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatComplainVC.h"
#import "FiatComplainHeadView.h"
#import "FiatPaymentCell.h"
#import "FiatPaymentTextCell.h"
#import "ACMediaFrame.h"
#import "FiatDetailedInstructionsCell.h"
#import "FiatFootSuspensionView.h"
#import "MGComplainVM.h"
#import "NSString+QSExtension.h"



@interface FiatComplainVC ()<UITableViewDelegate,UITableViewDataSource,FiatFootSuspensionDelegate>
@property (nonatomic, strong) UIView * normalSectionView;
@property (nonatomic, strong) FiatFootSuspensionView * footSuspensionView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) CGFloat mediaH;
@property (nonatomic, strong) ACSelectMediaView *mediaView;
@property (nonatomic, strong) MGComplainVM *viewModel;
///支付方式
@property (nonatomic, strong) NSArray *payTypeArr;
///详细
@property (nonatomic, strong) NSArray *detailPlaceholderArr;
///银行卡
@property (nonatomic, assign) NSInteger paytype;
///是否清空填写的账号信息
@property (nonatomic, assign) BOOL shouldClean;
///说明
@property (nonatomic, strong) FiatDetailedInstructionsCell * sumeryCell;
@end

@implementation FiatComplainVC

- (void)viewDidLoad {
    self.paytype = 1;
    [super viewDidLoad];
 
    self.title = kLocalizedString(@"申诉");
    self.view.backgroundColor = kBackGroundColor;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self setUpTableViews];

}

-(void)setUpTableViews{
    
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
    
    FiatComplainHeadView * headView = [[FiatComplainHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(44))];
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.footSuspensionView];
    [self.footSuspensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
    
    [self.tableView registerClass:[FiatPaymentCell class] forCellReuseIdentifier:@"paymentCell"];
    [self.tableView registerClass:[FiatPaymentTextCell class] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerClass:[FiatDetailedInstructionsCell class] forCellReuseIdentifier:@"yijianCell"];
    [self.tableView registerClass:[FiatPaymentCell class] forCellReuseIdentifier:@"paymentCellTitle"];
    

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        if (!_mediaView) {
            ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
            mediaView.type = ACMediaTypePhotoAndCamera;
            mediaView.maxImageSelected = 8;
            mediaView.naviBarBgColor = kNavTintColor;
            mediaView.rowImageCount = 4;
            mediaView.lineSpacing = 10;
            mediaView.interitemSpacing = 20;
            mediaView.sectionInset = UIEdgeInsetsMake(5, 15, 15, 24);
            mediaView.addImage = [UIImage imageNamed:@"icon_ss_add"];
            [mediaView observeViewHeight:^(CGFloat mediaHeight) {
                _mediaH = mediaHeight;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            @weakify(self);
            [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
                @strongify(self);
                [self.viewModel.imageArr removeAllObjects];
                for (ACMediaModel *model in list) {
                    [self.viewModel.imageArr addObject:model.image];
                }
                
            }];
            _mediaView = mediaView;
        }
        
        return _mediaView;
    }
    return self.normalSectionView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.normalSectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 1){
        return Adapted(12);
    }
 
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section == 2 ? MAX(_mediaH, 0.1) : 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0|| indexPath.section == 1){
        return Adapted(48);
    }else if (indexPath.section == 2){
        return Adapted(48);
    }else if (indexPath.section == 3){
        return Adapted(230);
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0){
        return 4;
    }else if (section == 1){
        return self.detailPlaceholderArr.count;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0){
       
        if(indexPath.row == 0){
            FiatPaymentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCellTitle"];
            if (cell == nil) {
                cell = [[FiatPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paymentCellTitle"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.pointButton.hidden = YES;
            [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).offset(Adapted(15));
            }];
            return cell;
        }else{
            FiatPaymentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell"];
            if (cell == nil) {
                cell = [[FiatPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paymentCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.pointButton.selected = self.paytype == indexPath.row?YES:NO;
            cell.titleLabel.text = self.payTypeArr[indexPath.row];
            cell.selectBlock = ^(BOOL selected){
                self.paytype = indexPath.row;
                self.shouldClean = YES;
                [self.tableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.shouldClean = NO;
                });
                
            };
            return cell;
        }
    }else if (indexPath.section == 1){
        FiatPaymentTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        cell.textField.placeholder = self.detailPlaceholderArr[indexPath.row];
        cell.textField.text = self.shouldClean?nil:cell.textField.text;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.didChangeBlock = ^(NSString *text){
            if (self.paytype == 1) {//银行
                switch (indexPath.row) {
                    case 0:
                        self.viewModel.bankName = text;
                        break;
                    case 1:
                        self.viewModel.bankBrachName = text;
                        break;
                    case 2:
                        self.viewModel.payeeAccount = text;
                        break;
                    case 3:
                        self.viewModel.transactionNum = text;
                        break;
                        
                    default:
                        break;
                }
            }else{
                switch (indexPath.row) {
                    case 0:
                        self.viewModel.payeeName = text;
                        break;
                    case 1:
                        self.viewModel.payeeAccount = text;
                        break;
                    case 2:
                        self.viewModel.transactionNum = text;
                        break;
                        
                    default:
                        break;
                }
            }
            
        };
        return cell;
    }else if(indexPath.section == 2){
        
        FiatPaymentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.pointButton.hidden = YES;
        cell.textLabel.textColor = kTextBlackColor;
        cell.titleLabel.text = kLocalizedString(@"交易凭证 (最多上传8张图片)");
        NSArray *subStrArray = [cell.titleLabel.text componentsSeparatedByString:@" "];
        if (subStrArray.count > 1) {
            [cell.titleLabel setAttributedText:[cell.titleLabel.text changeSubStr:subStrArray[1] subStrColor:k99999Color]];
        }
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).offset(Adapted(15));
        }];
        
        cell.lineView.hidden = YES;
        return cell;
    }else{
        self.sumeryCell = [tableView dequeueReusableCellWithIdentifier:@"yijianCell"];
        self.sumeryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.sumeryCell needTextViewBorder:YES];
        return self.sumeryCell;
        
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row != 0) {
            FiatPaymentCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell didBtnClicked:cell.pointButton];
        }
    }
}

/**
 取消
 */
-(void)sendValueLeftClick
{
    
}
/**
 提交
 */
- (void)sendValueRightClick{

    self.viewModel.fiatDealTradeOrderId = self.fiatDealTradeOrderId;
    self.viewModel.payType = [NSString stringWithFormat:@"%ld",self.paytype];
    self.viewModel.fiatDealTradeOrderId = self.fiatDealTradeOrderId;
    self.viewModel.sellBuy = self.sellBuy;
    if (self.viewModel.payType.length < 1) {
        [TTWHUD showCustomMsg:kLocalizedString(@"选择支付方式")];
        return;
    }
    if (self.paytype == 1) {
        if (self.viewModel.bankName.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入转账银行")];
            return;
        }
        if (self.viewModel.bankBrachName.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入转账银行开户行")];
            return;
        }
        if (self.viewModel.payeeAccount.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入银行账号")];
            return;
        }
        if (self.viewModel.transactionNum.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输银行交易单号")];
            return;
        }
    }else if (self.paytype = 2){
        if (self.viewModel.payeeName.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入收款人姓名")];
            return;
        }
        if (self.viewModel.payeeAccount.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入收款人支付宝账号")];
            return;
        }
        if (self.viewModel.transactionNum.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入支付宝订单号")];
            return;
        }
    }else if (self.paytype = 3){
        if (self.viewModel.payeeName.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入收款人姓名")];
            return;
        }
        if (self.viewModel.payeeAccount.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入收款人微信号")];
            return;
        }
        if (self.viewModel.transactionNum.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入支付交易单号")];
            return;
        }
    }
    
    
    ///暂不支持上传视频
    self.viewModel.evidenceAUrl = @"";

    self.viewModel.summary = self.sumeryCell.textView.text;
    [self.viewModel.uploadImagesSignal subscribeNext:^(id x) {
        [self.viewModel.commitComplainSignal subscribeNext:^(id x) {
            
            [TTWHUD showCustomMsg:kLocalizedString(@"提交成功")];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
}

- (NSArray *)payTypeArr
{
    if (!_payTypeArr) {
        _payTypeArr = @[kLocalizedString(@"支付方式"),kLocalizedString(@"银行卡支付"),kLocalizedString(@"支付宝支付"),kLocalizedString(@"微信支付")];
    }
    return _payTypeArr;
}
- (NSArray *)detailPlaceholderArr
{
    switch (self.paytype) {
        case 1://银行卡
            _detailPlaceholderArr = @[kLocalizedString(@"请输入转账银行"),kLocalizedString(@"请输入转账银行开户行"),kLocalizedString(@"请输入银行账号"),kLocalizedString(@"请输入银行交易单号")];
            break;
        case 2://支付宝
            _detailPlaceholderArr = @[kLocalizedString(@"请输入收款人姓名"),kLocalizedString(@"请输入收款人支付宝账号"),kLocalizedString(@"请输入支付宝订单号")];
            break;
        case 3://微信
            _detailPlaceholderArr = @[kLocalizedString(@"请输入收款人姓名"),kLocalizedString(@"请输入收款人微信账号"),kLocalizedString(@"请输入支付交易单号")];
            break;
            
        default:
            break;
    }
    return _detailPlaceholderArr;
}
-(FiatFootSuspensionView *)footSuspensionView{
    if(!_footSuspensionView){
        _footSuspensionView = [[FiatFootSuspensionView alloc] initWithFrame:CGRectZero];
        _footSuspensionView.tradingSellStatusType = Sell_Complaint;
        _footSuspensionView.btnDelegate = self;
        
    }
    return _footSuspensionView;
}
-(UIView *)normalSectionView{
    if(!_normalSectionView){
        _normalSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
        _normalSectionView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _normalSectionView;
}
- (MGComplainVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MGComplainVM new];
    }
    return _viewModel;
}







@end
