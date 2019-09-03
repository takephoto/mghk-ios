//
//  MGTransferTVC.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTransferTVC.h"
#import "MGTransferAccountCell.h"
#import "MGTransferCoinTypeCell.h"
#import "MGTransferInputCell.h"
#import "TTWActionSheetView.h"
#import "FiatTransactionRecordsVM.h"
#import "MGTransferVM.h"

#define kMGTransferAccountCell @"MGTransferAccountCell"
#define kMGTransferCoinTypeCell @"MGTransferCoinTypeCell"
#define kMGTransferInputCell @"MGTransferInputCell"

@interface MGTransferTVC ()
///cell id
@property (nonatomic, strong) NSArray *cellIdArr;
///提交按钮
@property (nonatomic, strong) QSButton *summitBtn;
///
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) TTWActionSheetView * sheetView;
@property (nonatomic, strong) FiatTransactionRecordsVM *fiatTransactionRecordsVM;
@property (nonatomic, strong) MGTransferVM *transferVM;
///币种列表
@property (nonatomic, strong) NSArray <AllCurrencyModels *> *coinTypeArr;
///该币种可用数量
@property (nonatomic, strong) NSString *availableNumber;
///当前选择的币种
@property (nonatomic, assign) NSInteger currentCoinType;
///保存上一次选择的类型
@property (nonatomic, assign) NSInteger lastCoinType;
///划转数量
@property (nonatomic, strong) NSString *transferNum;
@end



@implementation MGTransferTVC

- (void)viewWillAppear:(BOOL)animated{
    
     [self setNavBarStyle:NavigationBarStyleBlack backBtn:YES];
//     [self setNavBarWithTextColor:white_color barTintColor:black_color tintColor:black_color statusBarStyle:UIStatusBarStyleLightContent];
}

-(void)bindViewModel
{
    ///获取币种
    @weakify(self);
    [self.fiatTransactionRecordsVM.allCurrencySignal subscribeNext:^(NSMutableArray * currencySource) {
        @strongify(self);
        if (currencySource && currencySource.count>0) {
            self.coinTypeArr = currencySource;
            self.transferVM.tradeCode = self.defaultCoinTypeStr;
            [self.tableView reloadData];
            [self getCoinNumber];
        }
    }];
}


/**
 获取币种的可用数量
 */
- (void)getCoinNumber
{
    @weakify(self);
    [self.transferVM.getAvailableNumSignal subscribeNext:^(id x) {
        @strongify(self);
        self.lastCoinType = self.currentCoinType;
        self.availableNumber = [NSString stringWithFormat:@"%@",x];
        [self.tableView reloadData];
    }error:^(NSError *error) {
        self.currentCoinType = self.lastCoinType;
        self.defaultCoinTypeStr = self.coinTypeArr[self.lastCoinType].shortName;
    }];
}

-(void)setUpTableViewUI
{
    [super setUpTableViewUI];
    self.title = kLocalizedString(@"资金划转");
    
    self.transferVM.type = self.type;
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MGTransferAccountCell class] forCellReuseIdentifier:kMGTransferAccountCell];
    [self.tableView registerClass:[MGTransferCoinTypeCell class] forCellReuseIdentifier:kMGTransferCoinTypeCell];
    [self.tableView registerClass:[MGTransferInputCell class] forCellReuseIdentifier:kMGTransferInputCell];
    self.tableView.tableFooterView  = self.footerView;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Adapted(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdArr[indexPath.section]];
    if (indexPath.section == 0) {
        MGTransferAccountCell *tCell = (MGTransferAccountCell*)cell;
        tCell.type = self.transferVM.type;
    }
    else if (indexPath.section == 1) {
        MGTransferCoinTypeCell *tCell = (MGTransferCoinTypeCell*)cell;
        [tCell.changeBtn setTitle:self.defaultCoinTypeStr forState:UIControlStateNormal];
        @weakify(self);
        //监听币种切换按钮
        [[[tCell.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:tCell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            NSMutableArray *arr = [NSMutableArray new];
            for (AllCurrencyModels *model in self.coinTypeArr) {
                [arr addObject:model.shortName];
            }
            ///弹出选择列表
            _sheetView = [[TTWActionSheetView alloc]initWithTitle:@"" selectIndex:self.currentCoinType cancelButtonTitle:kLocalizedString(@"取消")  destructiveButtonTitle:@"" otherButtonTitles:arr handler:^(TTWActionSheetView *actionSheetView, NSInteger buttonIndex) {
                if (buttonIndex >= 0) {
                    self.currentCoinType = buttonIndex;
                    self.defaultCoinTypeStr = self.coinTypeArr[self.currentCoinType].shortName;
                    self.transferVM.tradeCode = self.defaultCoinTypeStr;
                    [self getCoinNumber];
                }
            }];
            [self.sheetView show];
        }];

    }else if (indexPath.section == 2){
        MGTransferInputCell *tCell = (MGTransferInputCell*)cell;
        tCell.availableLab.text = string(kLocalizedString(@"可用数量:"), self.availableNumber);
        @weakify(self);
        ///监听textfield
        [[[tCell.numTextFiled rac_textSignal]takeUntil:tCell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            @strongify(self);
            self.transferNum = x;
        }];

        //监听按钮(全部划转)
        [[[tCell.allBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:tCell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self);
            tCell.numTextFiled.text = self.availableNumber;
            self.transferNum = self.availableNumber;
        }];
    }
    
    return cell;
}

- (NSArray *)cellIdArr
{
    if (!_cellIdArr) {
        _cellIdArr = @[kMGTransferAccountCell,kMGTransferCoinTypeCell,kMGTransferInputCell];
    }
    return _cellIdArr;
}

-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.frame =  CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(70.0));
        _summitBtn = [[UIButton alloc]init];
        [_summitBtn setTitleColor:white_color forState:UIControlStateNormal];
        [_summitBtn setBackgroundColor:kRedColor];
        ViewRadius(_summitBtn, 2);
        [_summitBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
        [_summitBtn.titleLabel setFont:H15];
        [_footerView addSubview:_summitBtn];
        [_summitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Adapted(30));
            make.left.mas_equalTo(Adapted(16));
            make.right.mas_equalTo(Adapted(-16));
            make.bottom.mas_equalTo(0);
        }];
        @weakify(self);
        [[_summitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            @strongify(self);
            if ([self.transferNum doubleValue] > [self.availableNumber doubleValue]) {
                [TTWHUD showCustomMsg:kLocalizedString(@"划转数量不能大于可用数量")];
                return;
            }
            self.transferVM.availableBalance = self.transferNum;
            [self.transferVM.transferSignal subscribeNext:^(id x) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }];
    }
    return _footerView;
}
-(FiatTransactionRecordsVM *)fiatTransactionRecordsVM{
    if(!_fiatTransactionRecordsVM){
        _fiatTransactionRecordsVM = [[FiatTransactionRecordsVM alloc]init];
    }
    return _fiatTransactionRecordsVM;
}

- (MGTransferVM *)transferVM{
    if (!_transferVM) {
        _transferVM = [MGTransferVM new];
    }
    return _transferVM;
}


@end
