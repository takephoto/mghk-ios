// MGC
//
// AnnouncementDetailVC.m
// MGCEX
//
// Created by MGC on 2018/6/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AnnouncementDetailVC.h"

@interface AnnouncementDetailVC ()
@property (nonatomic, strong) UIScrollView * scrollView;
@end

@implementation AnnouncementDetailVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)back{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.titleStr){
        self.title = self.titleStr;
    }
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self loadUrlWithString:self.urlStr];
    self.view.backgroundColor = [UIColor whiteColor];

    
}



@end
