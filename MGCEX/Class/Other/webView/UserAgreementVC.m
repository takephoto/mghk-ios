// MGC
//
// UserAgreementVC.m
// MGCEX
//
// Created by MGC on 2018/6/22.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "UserAgreementVC.h"

@interface UserAgreementVC ()

@end

@implementation UserAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.titleStr){
        self.title = self.titleStr;
    }
    
    self.title = kLocalizedString(@"用户协议");
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
 
    
    [self loadUrlWithUrl:self.url];
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)back{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
