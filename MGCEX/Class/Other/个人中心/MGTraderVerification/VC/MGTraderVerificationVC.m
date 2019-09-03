//
//  MGTraderVerificationVC.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTraderVerificationVC.h"
#import "MGTraderVerificationSectionView.h"
#import "MGTraderVerificationCell.h"
#import "MGTraderVerificationFooterView.h"
#import "MGTraderVerificationBottomView.h"
#import "UserAgreementVC.h"

#define kUITableViewCellID              @"kUITableViewCellID"
#define KMGTraderVerificationCellID     @"KMGTraderVerificationCellID"


@interface MGTraderVerificationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MGTraderVerificationVM *viewModel;

@property (nonatomic, strong) MGTraderVerificationSectionView *sectionView;

@property (nonatomic, strong) MGTraderVerificationFooterView *footerView;

@property (nonatomic, strong) MGTraderVerificationBottomView *bottomView;

@end

@implementation MGTraderVerificationVC

- (id)initWithViewModel:(MGTraderVerificationVM *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}


- (void)setupSubviews
{
    // 添加表格视图
    self.title = self.viewModel.navTitleText;
    self.view.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(-54));
    }];
    // 添加表格footer及底部视图
    if ((self.viewModel.applyStatus == MGMerchantsApplySuccess) || (self.viewModel.applyStatus == MGMerchantsApplying)) {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }else{
        self.tableView.tableFooterView = self.footerView;
        [self.footerView congfigWithViewModel:self.viewModel];
        [self.view addSubview:self.bottomView];
        [self.bottomView congfigWithViewModel:self.viewModel];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(self.tableView.mas_bottom);
        }];
    }
    
    // 绑定事件
    [self setupEvent];
    // 网络请求配置数据
    if (self.viewModel.applyStatus == MGMerchantsApplying) {
        [self getTraderVerificationStatus];
    }else{
        [self.tableView reloadData];
    }
    [self getFormerChartWay];
    
    
}

// 获取商家认证
- (void)getTraderVerificationStatus
{
    @weakify(self)
    [self.viewModel.getForMerChartSignal subscribeNext:^(id response) {
        @strongify(self)
        NSNumber *applyStatus = response[response_data][@"applyStatus"];
        self.viewModel.applyStatus = [applyStatus integerValue];
        self.viewModel.nikeName = response[response_data][@"nikeName"];
        if (self.viewModel.applyStatus == MGMerchantsApplying) {
            self.viewModel.sectionTitleText = [NSString stringWithFormat:@"“%@”%@",kNotNull(self.viewModel.nikeName),kLocalizedString(@"商家已经在审核中，请稍等...")];
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
    }];
}

- (void)getFormerChartWay
{
     @weakify(self)
    [self.viewModel.getFormerChartWaySignal subscribeNext:^(id x) {
        @strongify(self)
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }];
}


- (void)setupEvent
{
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        // 协议
        UserAgreementVC *vc = [[UserAgreementVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.bottomView.protocolLabel addGestureRecognizer:tap];
    
    // 立即申请
    [[self.bottomView.applyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.bottomView.checkButton.selected == NO) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请勾选协议")];
            return;
        }
        if (([self.footerView getInputText].length == 0)) {
            [TTWHUD showCustomMsg:kLocalizedString(@"输入的商家名称不能为空")];
            return;
        }
        if (([self.footerView getInputText].length > 8)) {
            [TTWHUD showCustomMsg:kLocalizedString(@"输入的商家名称不能超过8个字")];
            return;
        }
        self.viewModel.nikeName = [self.footerView getInputText];
        [self.viewModel.applySignal subscribeNext:^(NSNumber *applyStatus) {
           
            [TTWHUD showCustomMsg:kLocalizedString(@"成功申请")];
            [self.navigationController popViewControllerAnimated:YES];

        }];
    }];
}


#pragma mark <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellID];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBackGroundColor;
        cell.textLabel.text = self.viewModel.cell0TitleText;
        cell.textLabel.textColor = kTextColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = H15;
        //坑得一匹
//        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(Adapted(15));
//            make.right.mas_equalTo(Adapted(-15));
//            make.center.mas_offset(0);
//        }];
        return cell;
    } else {
        MGTraderVerificationCell * cell =  [tableView dequeueReusableCellWithIdentifier:KMGTraderVerificationCellID];
        if (cell == nil) {
            cell = [[MGTraderVerificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KMGTraderVerificationCellID];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, Adapted(15), 0, Adapted(15));
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell congfigWithViewModel:self.viewModel.cellVMs[indexPath.row -1]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.viewModel.applyStatus == MGMerchantsNotApply) {
        UIView *defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
        defaultView.backgroundColor = kBackGroundColor;
        return defaultView;
    }
     [self.sectionView configWithViewModel:self.viewModel];
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.viewModel.applyStatus == MGMerchantsNotApply) {
        return Adapted(12);
    }
    return UITableViewAutomaticDimension;
}


#pragma mark Private Method

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = Adapted(112);
        _tableView.rowHeight =UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = kBackGroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (MGTraderVerificationSectionView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [[MGTraderVerificationSectionView alloc] init];
        _sectionView.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    }
    return _sectionView;
}

- (MGTraderVerificationFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[MGTraderVerificationFooterView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(135))];
        _footerView.backgroundColor = white_color;
    }
    return _footerView;
}

- (MGTraderVerificationBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[MGTraderVerificationBottomView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT - Adapted(48), MAIN_SCREEN_WIDTH, Adapted(54))];
        _bottomView.backgroundColor = white_color;
    }
    return _bottomView;
}


@end
