// MGC
//
// FiatSetZFBVC.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetZFBVC.h"
#import "FiatFootSuspensionView.h"
#import "FiatSetCommonCell.h"
#import "FiatSetVerifierCell.h"
#import "FiatSetCodeCell.h"
#import "FiatSetRemarkCell.h"
#import "FiatSetAccountVM.h"
#import "MGImagePickerHelper.h"
#import "FrontPhotographVM.h"
#import "FiatSetAccountModel.h"
#import "accountBankModel.h"
#import "accountZfbModel.h"
#import "accountWxModel.h"
#import "UIImageView+WebCache.h"
#import "MGFiatExampleView.h"

@interface FiatSetZFBVC ()<UITableViewDelegate,UITableViewDataSource,FiatFootSuspensionDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * normalSectionView;
@property (nonatomic, strong) FiatFootSuspensionView * footSuspensionView;
@property (nonatomic, strong) FiatSetAccountVM * viewModel;
@property (nonatomic, strong) UIImage * codeImage;
@property (nonatomic, strong) FrontPhotographVM * imageViewModel;
@property (nonatomic, strong) accountZfbModel * zfbModel;
@property (nonatomic, strong) accountWxModel * wxModel;
@property (nonatomic, strong) FiatSetAccountModel *  accountModel;
///示例
@property (nonatomic, strong) MGFiatExampleView *exampleView;
@end

@implementation FiatSetZFBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    //修改信息需要访问接口
    if ([self.changeStatus isEqualToString:@"2"]) {
        [self getNewData];
    }
    [self dropDownToRefreshData];
    
    
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


-(void)getNewData{
    
    //订阅信号
    @weakify(self);
    [self.viewModel.getAccountSignal subscribeNext:^(FiatSetAccountModel * model) {
        @strongify(self);
        self.accountModel = model;
        self.zfbModel = model.pay;
        self.wxModel = model.micro;
        
        [self.tableView reloadData];
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
}


-(void)setUpViews{
    if([self.payType integerValue] == 2){
        self.title = kLocalizedString(@"支付宝");
    }else{
        self.title = kLocalizedString(@"微信");
    }
 
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
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
    [self.tableView registerClass:[FiatSetCodeCell class] forCellReuseIdentifier:@"codeCell"];
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
    if(section == 0||section == 3){
        return Adapted(6);
    }
    return CGFLOAT_MIN;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return Adapted(48);
    }else if (indexPath.section == 1){
        return Adapted(141);
    }else if (indexPath.section == 2){
        return Adapted(198);
    }else if (indexPath.section == 3){
        return Adapted(48*3);
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 1;
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
        FiatSetCommonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0){
            cell.titleLabel.text = kLocalizedString(@"收款人") ;
            cell.subTextFiled.placeholder = kLocalizedString(@"请输入收款人姓名");
            @weakify(self);
            cell.subTextFiled.didChangeBlock = ^(NSString *text) {
                @strongify(self);
                self.viewModel.payeeName = text;
            };
            
            if([self.changeStatus integerValue]==2){
                if([self.payType integerValue]==2)//支付宝
                {
                    cell.subTextFiled.text = self.zfbModel.payeeName;
                    self.viewModel.payeeName = self.zfbModel.payeeName;
                }else{//微信
                    cell.subTextFiled.text = self.wxModel.payeeName;
                    self.viewModel.payeeName = self.wxModel.payeeName;
                }
                
            }
            
        }else if(indexPath.row == 1){
            if([self.payType integerValue] == 2){
                cell.titleLabel.text = kLocalizedString(@"支付宝账号");
                cell.subTextFiled.placeholder = kLocalizedString(@"请输入支付宝账号");
                @weakify(self);
                cell.subTextFiled.didChangeBlock = ^(NSString *text) {
                    @strongify(self);
                    self.viewModel.payeeAccount = text;
                };
                
                if([self.changeStatus integerValue]==2){
            
                    cell.subTextFiled.text = self.zfbModel.payeeAccount;
                    self.viewModel.payeeAccount = self.zfbModel.payeeAccount;
                    
                }
                
            }else{
                cell.titleLabel.text = kLocalizedString(@"微信账号");
                cell.subTextFiled.placeholder = kLocalizedString(@"请输入微信账号");
                @weakify(self);
                cell.subTextFiled.didChangeBlock = ^(NSString *text) {
                    @strongify(self);
                    self.viewModel.payeeAccount = text;
                };
                
                if([self.changeStatus integerValue]==2){
                
                cell.subTextFiled.text = self.wxModel.payeeAccount;
                self.viewModel.payeeAccount = self.wxModel.payeeAccount;
                    
                    
                }
                
            }
            
        }
        
        return cell;
    }else if (indexPath.section == 1){
        FiatSetCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"codeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadCodeClick)];
        
        [cell.codeImageImageV addGestureRecognizer:tap];
   
        if([self.changeStatus integerValue]==2){
            if([self.payType integerValue]==2){
                [cell.codeImageImageV sd_setImageWithURL:[NSURL URLWithString:_zfbModel.payeeAccountUrl]];
            }else{
                [cell.codeImageImageV sd_setImageWithURL:[NSURL URLWithString:_wxModel.payeeAccountUrl]];
            }
        }
        [[[cell.lookExampleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            [self.exampleView show];
        }];
        return cell;
        
    }else if(indexPath.section == 2){
        
        FiatSetRemarkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"remarkCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        cell.remarkTextView.isChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.summary = text;
        };
        
        if([self.changeStatus integerValue]==2){
            if([self.payType integerValue]==2)//支付宝
            {
                cell.remarkTextView.text = self.zfbModel.summary;
                self.viewModel.summary = self.zfbModel.summary;
            }else{//微信
                cell.remarkTextView.text = self.wxModel.summary;
                self.viewModel.summary = self.wxModel.summary;
            }
            
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
        
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
            // 1.系统分割线,移到屏幕外
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
            
        }
        
        return cell;
    }
    
}

//上传二维码
-(void)upLoadCodeClick{
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:1];
    FiatSetCodeCell * cell = [self.tableView cellForRowAtIndexPath:index];
    @weakify(self);
    [MGImagePickerHelper mg_openCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary orientationStyle:TTWSysOrientationLandscape didSelectImage:^(UIImage *image) {
        @strongify(self);
        if(image){
            cell.codeImageImageV.image = image;
            self.imageViewModel.image = image;
        }
        
    } didCancle:^(UIImagePickerController *picker) {
        
    }];
}

//提交
- (void)sendValueRightClick;{
    
    //上传图片
    @weakify(self);
    [self.imageViewModel.upImageSignal subscribeNext:^(UpImageModel * model) {
        @strongify(self);
        [self nextStep:model.imageName];
    }];

}

//总提交
-(void)nextStep:(NSString *)imageName{
    
    self.viewModel.status = self.changeStatus;
    self.viewModel.payType = self.payType;
    self.viewModel.payeeAccountUrl = imageName;
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


-(void)dealloc{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    FiatSetVerifierCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //防止倒计时没结束就返回，导致计时器不销毁
    if(cell.codeButton.timer&&cell.codeButton.timeOutNumber>0){
        //保存时间戳
        NSDate * date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:@(cell.codeButton.timeOutNumber) forKey:FiatbindingWXNumberdown];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:FiatbindingWXNumberdownTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //销毁定时器
        dispatch_source_cancel(cell.codeButton.timer);
        cell.codeButton.timer = nil;
    }
    
    
}

#pragma mark-- 懒加载
-(UIView *)exampleView
{
    if (!_exampleView) {
        _exampleView = [[MGFiatExampleView alloc]initWithSupView:self.view];
    }
    return _exampleView;
}
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

-(FrontPhotographVM *)imageViewModel{
    if(!_imageViewModel){
        _imageViewModel = [FrontPhotographVM new];
    }
    return _imageViewModel;
}
@end
