// MGC
//
// BindingIndentityIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BindingIndentityIndexVC.h"
#import "PersonalCenterCell.h"
#import "MGValidationFailureView.h"

@interface BindingIndentityIndexVC ()

@end

@implementation BindingIndentityIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"身份认证");
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = kLineColor;
    
    if(self.summary.length>0){
        
        MGValidationFailureView * view = [[MGValidationFailureView alloc]initWithMessage:self.summary sureBtnClick:nil cancelBtnClick:nil];
        
        [view show];
    }
    
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
    sectionView.backgroundColor = kBackGroundColor;
    self.tableView.tableHeaderView = sectionView;
    self.tableView.tableFooterView = sectionView;
}

#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0){
        cell.titleLabel.text = kLocalizedString(@"身份证实名认证");

    }else if (indexPath.section == 1){
        cell.titleLabel.text = kLocalizedString(@"护照实名认证");
        
    }
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(48);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        [self pushViewControllerWithName:@"FillInformationVC"];
    }else if (indexPath.section == 1){
        [self pushViewControllerWithName:@"FillPassportInformationVC"];
    }
    
}


@end
