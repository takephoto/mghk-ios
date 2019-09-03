//
//  UIViewController+JLNavButton.m
//  MGCPay
//
//  Created by Joblee on 2017/11/2.
//  Copyright © 2017年 Joblee. All rights reserved.
//

#import "UIViewController+JLNavButton.h"
#import "NSString+QSExtension.h"
#import "UIButton+TWButton.h"
#pragma mark - 判断系统版本高于或者低于某一个版本

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define kStatusBarStyle UIStatusBarStyleLightContent //状态栏样式


@implementation UIViewController (JLNavButton)
///左侧一个图片按钮的情况
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(-12, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.tag = 10000;
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5 * SCREEN_WIDTH /375.0,0,0)];
    }
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    ///spaceItem主要是为了解决左侧留白区域点击没效果
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //2.3将宽度设为负值
    spaceItem.width = -15;
    
    //2.4将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarButtonItem];
    
}



/**
 右侧一个图片按钮的情况
 
 @param firstImage 按钮图片
 @param action 响应方法
 */
- (void)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,44,44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 *SCREEN_WIDTH /375.0)];
    }
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

/**
 右侧为文字item的情况
 
 @param itemTitle itemtitle
 @param action 响应方法
 */
- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action
{
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,88,44)];
    [rightbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kTextColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:Adapted(15)];
    [rightbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        rightbBarButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}

/**
 左侧为文字item的情况
 
 @param itemTitle itemTitle description
 @param action action description
 */
- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action
{
    UIButton *leftbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [leftbBarButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    leftbBarButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        leftbBarButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [leftbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5  *SCREEN_WIDTH/375.0,0,0)];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbBarButton];
}


/**
 右侧两个图片item的情况
 
 @param firstImage firstImage description
 @param firstAction firstAction description
 @param secondImage secondImage description
 @param secondAction secondAction description
 */
- (void)addRightTwoBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage*)secondImage secondAction:(SEL)secondAction
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,80,44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(44, 6, 30, 30);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:firstAction forControlEvents:UIControlEventTouchUpInside];
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
    }
    [view addSubview:firstButton];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(6, 6, 30, 30);
    [secondButton setImage:secondImage forState:UIControlStateNormal];
    [secondButton addTarget:self action:secondAction forControlEvents:UIControlEventTouchUpInside];
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        secondButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
    }
    [view addSubview:secondButton];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
- (void)setLeftItemImage:(UIImage *)image
{
    
}


///标题颜色 导航颜色 状态栏样式
- (void)setNavBarWithTextColor:(UIColor *)textColor barTintColor:(UIColor *)barTintColor tintColor:(UIColor *)tintColor statusBarStyle:(UIStatusBarStyle)style
{
    //设置标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :  textColor}];
    //设置导航栏的颜色
    self.navigationController.navigationBar.barTintColor = barTintColor;
    //返回按钮颜色
    self.navigationController.navigationBar.tintColor = tintColor;
    //设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = style;
}

//标题颜色 导航颜色  返回按钮图片 状态栏样式
- (void)setNavBarWithTextColor:(UIColor *)textColor barTintColor:(UIColor *)barTintColor backBtnImg:(UIImage *)img statusBarStyle:(UIStatusBarStyle)style{
    
    //设置标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :  textColor}];
    //设置导航栏的颜色
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = barTintColor;
    //返回按钮
    if ([self respondsToSelector:@selector(back)] && img) {
        [self addLeftBarButtonWithImage:img action:@selector(back)];
    }
    //设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = style;
}

- (void)setNavBarStyle:(NavigationBarStyle)style backBtn:(BOOL)need{
    
    switch (style) {
        case NavigationBarStyleWhite:
            [self setNavBarWithTextColor:black_color barTintColor:white_color backBtnImg:need ? IMAGE(@"black_back"): nil statusBarStyle:UIStatusBarStyleDefault];
            break;
        case NavigationBarStyleBlack:
            [self setNavBarWithTextColor:white_color barTintColor:black_color backBtnImg:need ?IMAGE(@"white_back"): nil statusBarStyle:UIStatusBarStyleLightContent];
            break;
        case NavigationBarStyleModena:
            [self setNavBarWithTextColor:white_color barTintColor:kKLineBGColor backBtnImg:need ?IMAGE(@"white_back"): nil statusBarStyle:UIStatusBarStyleLightContent];
            break;
        default:
            break;
    }
}

/**
 设置返回按钮图片
 
 @param image 图片
 */
-(void)setBackUpBtnImgWithImage:(UIImage *)image
{
    UIButton *btn = self.navigationItem.leftBarButtonItems[1].customView;
    [btn setImage:image forState:UIControlStateNormal];
}

#pragma mark - 设置左侧按钮
- (void)setLeftItemWithIcon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)titleColor selector:(SEL)selector {
    //    if(!icon){
    //        icon = [UIImage imageNamed:@"back_more1"];
    //    }
    if(!titleColor){
        titleColor = RGBCOLOR(80, 80, 80);
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[[self ittemLeftItemWithIcon:icon title:title titleColor:titleColor selector:selector], spaceItem];
}

- (UIBarButtonItem *)ittemLeftItemWithIcon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)titleColor selector:(SEL)selector {
    UIBarButtonItem *item;
    if (!icon && title.length == 0) {
        item = [[UIBarButtonItem new] initWithCustomView:[UIView new]];
        return item;
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//图文居左
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateHighlighted];
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(MAIN_SCREEN_WIDTH, MAXFLOAT)];
    float leight = titleSize.width;
    if (icon) {
        leight += icon.size.width;
        [btn setImage:icon forState:UIControlStateNormal];
        [btn setImage:icon forState:UIControlStateHighlighted];
        //        if (title.length == 0) {
        //            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
        //        } else {
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        //        }
    }
    if (title.length == 0) {
        //文字没有的话，点击区域+50
        leight = leight + Adapted(60);
    }else{
        leight = leight + Adapted(30);
    }
    view.frame = CGRectMake(0, 0, leight, 30);
    btn.frame = CGRectMake(-5, 0, leight, 30);
    [view addSubview:btn];
    item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

#pragma mark-- 设置右侧按钮
- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item = [self ittemRightItemWithTitle:title selector:selector];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightItemWithIcon:(UIImage *)icon selector:(SEL)selector {
    UIBarButtonItem *item = [self ittemRightItemWithIcon:icon selector:selector];
    self.navigationItem.rightBarButtonItem = item;
}

- (UIBarButtonItem *)ittemRightItemWithIcon:(UIImage *)icon selector:(SEL)selector {
    UIBarButtonItem *item;
    if (!icon) {
        item = [[UIBarButtonItem new] initWithCustomView:[UIView new]];
        return item;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    float leight = icon.size.width+Adapted(40);
    btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [btn setImage:icon forState:UIControlStateNormal];
    [btn setImage:icon forState:UIControlStateHighlighted];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (UIBarButtonItem *)ittemRightItemWithTitle:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item;
    if (title.length == 0) {
        item = [[UIBarButtonItem new] initWithCustomView:[UIView new]];
        return item;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateHighlighted];
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(MAIN_SCREEN_WIDTH, MAXFLOAT)];
    float leight = titleSize.width;
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}


#pragma mark - Action

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
