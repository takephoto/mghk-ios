// MGC
//
// FillInformationVC.m
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FillInformationVC.h"
#import "IDCardProgressView.h"
#import "FrontPhotographVC.h"

@interface FillInformationVC ()
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UITextField * nameTextFile;
@property (nonatomic ,strong) UITextField * idCardFile;
@property (nonatomic, strong) UIView * bottomLlineView;
@end

@implementation FillInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = white_color;
    self.title = kLocalizedString(@"身份证认证");
    [self setUpHeadViews];
    [self setUpBottomViews];
}

-(void)setUpHeadViews{
    
    IDCardProgressView * headView = [[IDCardProgressView alloc]initWithImage:@"jindu1-1" step:1 style:1 frame:CGRectMake(0, Adapted(10), MAIN_SCREEN_WIDTH, Adapted(80))];
    [self.view addSubview:headView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = kLocalizedString(@"请填写您的身份证信息");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(Adapted(90));
    }];
    
}

-(void)setUpBottomViews{
    
    NSArray * titleArr = @[kLocalizedString(@"姓名"),kLocalizedString(@"身份证号码")];
    for(int i=0;i<titleArr.count;i++){
        
        //姓名
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapted(15), Adapted(164)+i*Adapted(60), Adapted(100), Adapted(20))];
        [self.view addSubview:nameLabel];
        nameLabel.text = titleArr[i];
        nameLabel.textColor = kTextColor;
        nameLabel.font = H15;
        
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(Adapted(115), Adapted(154)+Adapted(60)*i, MAIN_SCREEN_WIDTH-Adapted(130), Adapted(40))];
        [self.view addSubview:textField];
        textField.placeholder = kLocalizedString(@"请输入");
        textField.tag = 100+i;
        textField.font = H15;
        [textField setValue:k99999Color forKeyPath:@"_placeholderLabel.textColor"];
        
        UIView * nameLine = [[UIView alloc]initWithFrame:CGRectMake(Adapted(15), Adapted(195)+i*Adapted(60), MAIN_SCREEN_WIDTH-Adapted(30), 1)];
        [self.view addSubview:nameLine];
        nameLine.backgroundColor = kLineColor;
        nameLine.alpha = 0.5;
        nameLine.tag = 200+i;
        
    }
    self.nameTextFile = [self.view viewWithTag:100];
    self.idCardFile = [self.view viewWithTag:101];
    self.bottomLlineView = [self.view viewWithTag:201];
    @weakify(self);
    self.nameTextFile.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
    };
    
    self.idCardFile.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
    };

    //下一步
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bottomLlineView.mas_bottom).offset(Adapted(40));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(30));
        make.height.mas_equalTo(Adapted(40));
    }];
    nextBtn.layer.cornerRadius = Adapted(2);
    nextBtn.clipsToBounds = YES;
    [nextBtn setTitle:kLocalizedString(@"下一步") forState:UIControlStateNormal];
    [nextBtn setTitleColor:white_color forState:UIControlStateNormal];
    nextBtn.enabled = NO;
    [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    nextBtn.alpha = 1;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
}

//下一步
-(void)nextBtnClick{
    
//    if(![PredicateTool validateIDCardNumber:self.idCardFile.text]){
//        [TTWHUD showCustomMsg:kLocalizedString(@"身份证格式错误")];
//        return;
//    }
    
    [[NSUserDefaults standardUserDefaults]setObject:self.nameTextFile.text forKey:IdentityName];
    [[NSUserDefaults standardUserDefaults]setObject:self.idCardFile.text forKey:IdentityNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FrontPhotographVC * vc = [[FrontPhotographVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];

}

//改变下一步按钮状态
-(void)changeRegisStatus{
    if(self.nameTextFile.text.length>0&&self.idCardFile.text.length>0){
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}

@end
