// MGC
//
// IDCardPhotographView.m
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "IDCardPhotographView.h"
#import "IDCardProgressView.h"
@interface IDCardPhotographView()
@property (nonatomic, strong) IDCardProgressView * headView;
@property (nonatomic, copy) NSString * photograph;
@property (nonatomic, copy) NSString * titlemsg;

@end
@implementation IDCardPhotographView

-(id)initWithPhotograph:(NSString *)photograph titleLabel:(NSString *)titlemsg frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titlemsg = titlemsg;
        self.photograph = photograph;
        [self setUpPhotograph];
    }
    return self;
}

-(void)setUpPhotograph{
    
    //标题
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.titlemsg;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(Adapted(5));

    }];
    
    //四角边框
    UIImageView * borderImageV = [[UIImageView alloc]init];
    [self addSubview:borderImageV];
    borderImageV.userInteractionEnabled = YES;
    borderImageV.image = IMAGE(@"waikunag");
    [borderImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(40));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(262));
        make.height.mas_equalTo(Adapted(173));
    }];

    //底色图
    UIImageView * impressionImageV = [[UIImageView alloc]init];
    [borderImageV addSubview:impressionImageV];
    impressionImageV.userInteractionEnabled = YES;
    impressionImageV.image = [UIImage imageWithColor:RGBCOLOR(248, 246, 246)];
    impressionImageV.backgroundColor = [UIColor lightGrayColor];
    [impressionImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(borderImageV);
        make.centerY.mas_equalTo(borderImageV);
        make.width.mas_equalTo(Adapted(242));
        make.height.mas_equalTo(Adapted(148));
    }];
    
    //拍照按钮图
    _takeUpBtnImageV = [[UIImageView alloc]init];
    [impressionImageV addSubview:_takeUpBtnImageV];
    _takeUpBtnImageV.userInteractionEnabled = YES;
    _takeUpBtnImageV.image =  IMAGE(NSLocalizedString(self.photograph,nil));
    [_takeUpBtnImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 拍照按钮+号
    UIImageView *addImageView = [UIImageView new];
    [impressionImageV addSubview:addImageView];
    addImageView.image = IMAGE(@"id_verify_add");
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(Adapted(40));
        make.centerX.mas_equalTo(borderImageV);
        make.centerY.mas_equalTo(borderImageV);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotograph:)];
    [_takeUpBtnImageV addGestureRecognizer:tap];
    
    //点击上传
    UILabel * upLabel = [[UILabel alloc]init];
    [_takeUpBtnImageV addSubview:upLabel];
    upLabel.textColor = white_color;
    upLabel.font = H15;
    upLabel.text = kLocalizedString(@"点击上传");
    upLabel.textAlignment = NSTextAlignmentCenter;
    [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_takeUpBtnImageV);
        make.width.mas_equalTo(_takeUpBtnImageV);
        make.height.mas_equalTo(Adapted(20));
//        make.bottom.mas_equalTo(_takeUpBtnImageV.mas_bottom).offset(Adapted(-20));
        make.top.mas_equalTo(_takeUpBtnImageV.mas_top).offset(Adapted(106.));
    }];

    //拍照后的照片
    _photographImageV = [[UIImageView alloc]init];
    [impressionImageV addSubview:_photographImageV];
    _photographImageV.userInteractionEnabled = YES;
    _photographImageV.hidden = YES;
    //_photographImageV.contentMode = UIViewContentModeScaleAspectFit;
    [_photographImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    UITapGestureRecognizer * tapPhotograph = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhotograph:)];
    [_photographImageV addGestureRecognizer:tapPhotograph];

    //上一步
    UIButton * upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:upBtn];
    [upBtn setTitle:kLocalizedString(@"上一步") forState:UIControlStateNormal];
    [upBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    upBtn.layer.cornerRadius = Adapted(2);
    upBtn.layer.borderColor = kRedColor.CGColor;
    upBtn.layer.borderWidth = 1;
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(50));
        make.width.mas_equalTo(Adapted(115));
        make.height.mas_equalTo(Adapted(40));
        make.top.mas_equalTo(borderImageV.mas_bottom).offset(Adapted(24));
    }];
    [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    //下一步
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:nextBtn];
    [nextBtn setTitle:kLocalizedString(@"下一步") forState:UIControlStateNormal];
    [nextBtn setTitleColor:white_color forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = Adapted(2);
    nextBtn.enabled = NO;
    nextBtn.clipsToBounds = YES;
    [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-50));
        make.width.mas_equalTo(Adapted(115));
        make.height.mas_equalTo(Adapted(40));
        make.top.mas_equalTo(borderImageV.mas_bottom).offset(Adapted(24));
    }];
    self.nextBtn = nextBtn;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//上一步
-(void)upBtnClick:(UIButton *)button{
    if(self.upBtnBlock){
        self.upBtnBlock(button);
    }
}

//下一步
-(void)nextBtnClick:(UIButton *)button{
    if(self.nextBtnBlock){
        self.nextBtnBlock(button);
    }
}

//点击上传拍照按钮
-(void)takePhotograph:(UIGestureRecognizer *)tap{
    if(self.takeUpBtnBlock){
        self.takeUpBtnBlock((UIImageView *)tap.view);
    }
}

-(void)tapPhotograph:(UIGestureRecognizer *)tap{
    if(self.takePictureBlock){
        self.takePictureBlock((UIImageView *)tap.view);
    }
}
@end
