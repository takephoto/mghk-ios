// MGC
//
// BaseTabBarController.m
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTabBarController.h"
#import "TWBaseNavigationController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray * vcDataSource;
@property (nonatomic, assign) BOOL loginStatus; //是否需要跳转登录 选择个人中心 跳到登录界面 当登录成功后，回到个人中心
@end

@implementation BaseTabBarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.loginStatus == YES) {//个人中心
        
        BOOL timeout = NO;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"endAppTime"]&&
           [[TWAppTool getCurrentDate] integerValue] - [[[NSUserDefaults standardUserDefaults] objectForKey:@"endAppTime"] integerValue] > BackTimeOut){
            timeout = YES;
        }
        
        if (kUserIsLogin && !timeout) {//已经登录 并且 验证未超时
            
            self.loginStatus = NO;
            self.selectedIndex = 4;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configTabbar];
    [self setViewControllers];
    [self removeTabarTopLine];
}

//tabbar背景色
-(void)configTabbar{
    
    UIView * backView = [UIView new];
    backView.backgroundColor = kNavTintColor;
    backView.frame = self.tabBar.bounds;
    [[UITabBar appearance] insertSubview:backView atIndex:0];
}

- (void)setViewControllers {
    
   
    NSArray * vcArray = @[@"HomePageIndexVC",@"MarketIndexVC",@"CoinDealIndexVC",@"FiatDealIndexVC",@"PersonalCenterIndexVC"];
    NSArray * nameArray = @[kLocalizedString(@"首页"),kLocalizedString(@"行情"),kLocalizedString(@"币币交易"),@"C2C/B2C",kLocalizedString(@"我的")];
    NSArray * norPic = @[@"home_normal",@"market_normal",@"bibi_normal",@"fibi_normal",@"me_normal"];
    NSArray * selectPic = @[@"home_checked",@"market_checked",@"bibi_checked",@"fabi_checked",@"me_checked"];
    for(int i=0;i<vcArray.count;i++){
        Class classs;
        classs = NSClassFromString(vcArray[i]);
        TWBaseNavigationController * nav = [[TWBaseNavigationController alloc]initWithRootViewController:[classs new]];
        [self.vcDataSource addObject:nav];
    }

    self.viewControllers = self.vcDataSource;
    
    //默认
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];

    // 选中
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrSelected[NSForegroundColorAttributeName] = kMainColor;

    for(int i=0;i<nameArray.count;i++){
        UITabBarItem *TabBarItem = [self.tabBar.items objectAtIndex:i];
        //默认
        [TabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
        TabBarItem.image = [[UIImage imageNamed:norPic[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //选中
        [TabBarItem setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
        TabBarItem.selectedImage = [[UIImage imageNamed:selectPic[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        [TabBarItem setTitle:nameArray[i]];
    }
    
    self.delegate = self;
    
}


#pragma mark - 去掉tabBar顶部线条

//去掉tabBar顶部线条
- (void)removeTabarTopLine {
    CGRect rect = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 4) {//进入我的 做登录判断
        BOOL flag = [TWAppTool permissionsValidationHandleFinish:^{
            
        }];
       if(!flag) self.loginStatus = !flag;
        return flag;
    }
    return YES;
}


#pragma 懒加载
-(NSMutableArray *)vcDataSource{
    if(!_vcDataSource){
        _vcDataSource = [NSMutableArray new];
        
    }
    return _vcDataSource;
}


@end
