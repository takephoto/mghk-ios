// MGC
//
// MandatoryUpDataVC.m
// MGCEX
//
// Created by MGC on 2018/6/13.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "MandatoryUpDataVC.h"

@interface MandatoryUpDataVC ()

@end

@implementation MandatoryUpDataVC

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
    
   // NSLog(@"self.urlStr=== %@",self.urlStr);
//    [self addScriptMessageSelName:@[@"Location",@"Share"]];
//    self.minimumFontSize = 40;

    
}


@end
