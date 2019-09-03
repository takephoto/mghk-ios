// MGC
//
// LabguageRegionVC.m
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "LabguageRegionVC.h"
#import "LabguageRegionCell.h"
#import "LabguageRegionModel.h"
#import "AppDelegate.h"

@interface LabguageRegionVC ()
{
    NSArray * _titleLabels;
    NSArray * _subTitleLabels;
    NSInteger currentType;
}

@end

@implementation LabguageRegionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kBackGroundColor;
    [self.tableView registerClass:[LabguageRegionCell class] forCellReuseIdentifier:@"cell"];
    [self getData];
    
}

//获取数据源
-(void)getData{
    //获取当前语言

    NSString *currentLanguage = [NSBundle getPreferredLanguage];

    if([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        //简体中文
        currentType = 0;
    }
    else if([currentLanguage rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        //繁体
        currentType = 1;
    }else if ([currentLanguage rangeOfString:@"en"].location != NSNotFound){
        //英语
        currentType = 2;
    }

    _titleLabels = @[@"简体中文",@"繁體中文",@"English"];
    
    for(int i=0;i<_titleLabels.count;i++){
        LabguageRegionModel * model = [[LabguageRegionModel alloc]init];
        model.country = _titleLabels[i];
        
        if(i == currentType){
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
        [self.dataArray addObject:model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LabguageRegionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    LabguageRegionModel * model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.country;
    cell.isSelect = model.isSelect;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.dataArray.count-1) {
        cell.separatorInset = UIEdgeInsetsMake(0, MAIN_SCREEN_WIDTH, 0, 0);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(48);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.dataArray enumerateObjectsUsingBlock:^(LabguageRegionModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isSelect = NO;
        if(idx == indexPath.row){
            model.isSelect = YES;
        }
    }];

    [self.tableView reloadData];
    
    //重新设置语言
    [self changeLanguageTo:[self setUserlanguage:indexPath.row]];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeLangue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
}

- (void)changeLanguageTo:(NSString *)language {
    // 设置语言
    [NSBundle setLanguage:language];
    
    // 然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:myLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 我们要把系统windown的rootViewController替换掉
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseTabBarController *tabVC = [[BaseTabBarController alloc] init];
    delegate.window.rootViewController = tabVC;
    
}

-(NSString *)setUserlanguage:(NSInteger )index{
    if(index == 0){
        return  [self languageFormat:@"zh-Hans"];//简体
    }else if(index == 1){
        return  [self languageFormat:@"zh-Hant"];//繁体
    }else if(index == 2){
        return  [self languageFormat:@"en"];//英语
    }
    return @"en";
    }


///语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
- (NSString *)languageFormat:(NSString*)language {
    if([language rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        return @"zh-Hans";//简体中文
    }
    else if([language rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        return @"zh-Hant";//繁体
    }
    else
    {
        //字符串查找
        if([language rangeOfString:@"-"].location != NSNotFound) {
            //除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
            NSArray *ary = [language componentsSeparatedByString:@"-"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return language;
}



@end
