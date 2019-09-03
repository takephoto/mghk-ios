// MGC
//
// FrontPhotographVC.m
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FrontPhotographVC.h"
#import "IDCardPhotographView.h"
#import "IDCardProgressView.h"
#import "IDCardFrontSampleCell.h"
#import "IDCardExampleTextCell.h"
#import "MGImagePickerHelper.h"
#import "ReversePhotographVC.h"
#import "BindingIndentityIndexVC.h"
#import "FrontPhotographVM.h"

@interface FrontPhotographVC ()
@property (nonatomic, strong) IDCardPhotographView * headView;
@property (nonatomic, strong) FrontPhotographVM * viewModel;
@end

@implementation FrontPhotographVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(@"身份证认证");
    self.view.backgroundColor = white_color;
    
    //固定的头部进度条
    IDCardProgressView * progressView = [[IDCardProgressView alloc]initWithImage:@"sfjc2" step:2 style:1 frame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(80))];
    [self.view addSubview:progressView];
    
    [self.tableView registerClass:[IDCardFrontSampleCell class] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerClass:[IDCardExampleTextCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(progressView.mas_bottom);
    }];
    
  
    _headView = [[IDCardPhotographView alloc]initWithPhotograph:@"sczm-sfz" titleLabel:kLocalizedString(@"请上传您的身份证正面图片") frame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(300))];
    self.tableView.tableHeaderView = _headView;
    
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
        return Adapted(140);
    }else{
        return Adapted(80);
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
        IDCardFrontSampleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.pics = @[@"zq-sfzm",@"qszd--sfzm",@"mh-sfzm",@"sg-sfzm"];
        return cell;
    }else{
        IDCardExampleTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textHint1.text = kLocalizedString(@"1、提交的信息必须真实有效");
        cell.textHint2.text = kLocalizedString(@"2、上传图片必须清晰");
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

//下一步
-(void)nextStepClick{
    
    self.viewModel.image = self.headView.photographImageV.image;
    //订阅信号
    @weakify(self);
    [self.viewModel.upImageSignal subscribeNext:^(UpImageModel * model) {
        @strongify(self);
        
        [[NSUserDefaults standardUserDefaults]setObject:model.imageName forKey:IdentityFront];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ReversePhotographVC * vc = [ReversePhotographVC new];
        [self.navigationController pushViewController:vc animated:NO];
    }];
    

}


-(FrontPhotographVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[FrontPhotographVM alloc]init];
    }
    return _viewModel;
}


@end
