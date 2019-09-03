// MGC
//
// HandIdentityCardVC.m
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HandIdentityCardVC.h"
#import "IDCardPhotographView.h"
#import "IDCardProgressView.h"
#import "HandIdentityExampleCell.h"
#import "IDCardExampleTextCell.h"
#import "MGImagePickerHelper.h"
#import "BindingIndentityIndexVC.h"
#import "FrontPhotographVM.h"
#import "HandIdentityCardVM.h"

@interface HandIdentityCardVC ()
@property (nonatomic, strong) IDCardPhotographView * headView;
@property (nonatomic, strong) FrontPhotographVM * viewModel;
@property (nonatomic, strong) HandIdentityCardVM * nextViewModel;
@end

@implementation HandIdentityCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(@"身份证认证");
    self.view.backgroundColor = white_color;
    
    //固定的头部进度条
    IDCardProgressView * progressView = [[IDCardProgressView alloc]initWithImage:@"sfjc4" step:4 style:1 frame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(80))];
    [self.view addSubview:progressView];
    
    [self.tableView registerClass:[HandIdentityExampleCell class] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerClass:[IDCardExampleTextCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(progressView.mas_bottom);
    }];
    
    
    _headView = [[IDCardPhotographView alloc]initWithPhotograph:@"sczj_scsfz" titleLabel:kLocalizedString(@"请上传您的手持身份证和平台认证说明") frame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(300))];
    self.tableView.tableHeaderView = _headView;
    [_headView.nextBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
    
    @weakify(self);
    //点击上传拍照
    self.headView.takeUpBtnBlock = ^(UIImageView *imageV) {
        @strongify(self);
        [self showPicker];
    };
    
    //点击图片拍照
    self.headView.takePictureBlock = ^(UIImageView *imageV) {
        @strongify(self);
        [self showPicker];
    };
    
    //上一步
    self.headView.upBtnBlock = ^(UIButton *button) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:NO];
    };
    
    //下一步
    self.headView.nextBtnBlock = ^(UIButton *button) {
        @strongify(self);
       [self nextStepClick];
    };
    
}

-(void)back{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:kLocalizedString(@"确认退出认证?")
                                                                   message:kLocalizedString(@"退出后不会保存当前资料")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self popToViewControllerWithClass:@"BindingIndentityIndexVC"];
                                                              
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return Adapted(200);
    }else{
        return Adapted(140);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        HandIdentityExampleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.pics = @[@"zq_scsfz",@"cw_scsfz"];
        return cell;
    }else{
        IDCardExampleTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textHint1.text = kLocalizedString(@"1、上传的图片必须真实有效，身份证内容清晰可见");
        cell.textHint2.text = kLocalizedString(@"1、上传的图片必须真实有效，身份证内容清晰可见");
        cell.textHint3.text = kLocalizedString(@"3、拍照时必须漏出肘关节");
        return cell;
    }
    return nil;
}
-(void)showPicker{
    @weakify(self);
    [MGImagePickerHelper mg_openCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary orientationStyle:TTWSysOrientationLandscape didSelectImage:^(UIImage *image) {
        @strongify(self);
        if(image){
            self.headView.photographImageV.image = [TWAppTool addWatermarkWithImage:image supImageV:_headView.photographImageV];
            self.headView.photographImageV.hidden = NO;
            self.headView.takeUpBtnImageV.hidden = YES;
            self.headView.nextBtn.enabled = YES;
           
        }
        
    } didCancle:^(UIImagePickerController *picker) {
        
    }];
}

//下一步,总提交
-(void)nextStepClick{

    self.viewModel.image = self.headView.photographImageV.image;

    self.nextViewModel.type = @"1";
    self.nextViewModel.identityNum = [[NSUserDefaults standardUserDefaults] objectForKey:IdentityNumber];
    self.nextViewModel.fullName = [[NSUserDefaults standardUserDefaults] objectForKey:IdentityName];
    self.nextViewModel.name = @"name";
    self.nextViewModel.frontCardUrl = [[NSUserDefaults standardUserDefaults] objectForKey:IdentityFront];
    self.nextViewModel.backCardUrl = [[NSUserDefaults standardUserDefaults] objectForKey:IdentityReverse];

    //订阅信号,先上传图片
    @weakify(self);
    [self.viewModel.upImageSignal subscribeNext:^(UpImageModel * model) {
        @strongify(self);
        self.nextViewModel.holdCardurl = model.imageName;
        
        [self SubmitInformation];
        
    }];
    
    
}

-(void)SubmitInformation{
    @weakify(self);
    [self.nextViewModel.authenticationSignal subscribeNext:^(id x) {
        @strongify(self);
    
        [TTWHUD showCustomMsg:kLocalizedString(@"提交成功")];
        [self popToViewControllerWithClass:@"BindingIndentityIndexVC"];
    }];
}


-(FrontPhotographVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[FrontPhotographVM alloc]init];
    }
    return _viewModel;
}

-(HandIdentityCardVM *)nextViewModel{
    if(!_nextViewModel){
        _nextViewModel = [[HandIdentityCardVM alloc]init];
    }
    return _nextViewModel;
}

@end
