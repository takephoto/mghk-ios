// MGC
//
// TableViewErrorView.m
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TableViewErrorView.h"


@interface TableViewErrorView()
@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UILabel * msgLabel;
@end

@implementation TableViewErrorView

singletonImplementation(TableViewErrorView);

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF2F3F5);
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.imageV = [[UIImageView alloc]init];
    [self addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(Adapted(100));
        make.centerY.mas_equalTo(self).offset(Adapted(-50));
    }];
    
    self.msgLabel = [[UILabel alloc]init];
    [self addSubview:self.msgLabel];
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    self.msgLabel.textColor = [UIColor lightGrayColor];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(Adapted(20));
        make.left.right.mas_equalTo(self);
    }];

}

+(void)showErrorWithImage:(UIImage *)image msg:(NSString *)msg toView:(UIView *)toView{
    TableViewErrorView * errorView = [TableViewErrorView sharedTableViewErrorView];
    [toView addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    if(!image){
        image = [UIImage imageNamed:@"NoData"];
    }
    if(!msg){
        msg = kLocalizedString(@"数据出错啦～～");
    }
    errorView.imageV.image = image;
    errorView.msgLabel.text = msg;
}

+(void)hidden;{
    [[TableViewErrorView sharedTableViewErrorView] removeFromSuperview];
}

@end
