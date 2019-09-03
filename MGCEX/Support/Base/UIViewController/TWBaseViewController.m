// MGC
//
// TWBaseViewController.m
// IOSFrameWork
//
// Created by MGC on 2018/4/26.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#>

#define BGCOLOR UIColorFromRGB(0xFFFFFF);

#import "TWBaseViewController.h"
#import "TTWNetwork.h"


@interface TWBaseViewController ()

///不需要返回按钮的控制器
@property (nonatomic, strong) NSArray *vcNoBackBtnArr;
@end

@implementation TWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置view是否渗透
    [self setIsExtendLayout:NO];

    //设置背景颜色
    self.view.backgroundColor = kBackGroundColor;
    [self bindViewModel];
    //导航文字标题返回按钮设置
    [self setUpNavUI];
    //初始化视图
    [self setupSubviews];
    //摇一摇成为第一响应
#ifdef DEBUG
    [self becomeFirstResponder];
#endif
}

#ifdef DEBUG
//摇一摇代理
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
{
    if (motion== UIEventSubtypeMotionShake) {
        [self changeAPI];
    }
}

//摇一摇执行方法
-(void)changeAPI{
    
    NSString * str = [NSString stringWithFormat:@"%@",[TTWNetworkHandler sharedInstance].host_api];
    if([str rangeOfString:@"192.168.0.64:8021"].location !=NSNotFound){
        str = [NSString stringWithFormat:@"森海:%@",[TTWNetworkHandler sharedInstance].host_api];
    } else if ([str rangeOfString:@"www.MEIB.IO"].location !=NSNotFound){
        str = [NSString stringWithFormat:@"当前生产环境:%@",HOST];
    }   else if ([str rangeOfString:@"192.168.0.63:8021"].location !=NSNotFound){
        str = [NSString stringWithFormat:@"开发环境:%@",[TTWNetworkHandler sharedInstance].host_api];
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:str
                                                                   message:@"切换API"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* wangAction = [UIAlertAction actionWithTitle:@"森海192.168.0.64:8021" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           [TTWNetworkHandler sharedInstance].host_api = @"http://192.168.0.64:8021/api/";
                                                           
                                                           
                                                       }];
    UIAlertAction* huangAction = [UIAlertAction actionWithTitle:@"黄剑192.168.0.122:8021" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           [TTWNetworkHandler sharedInstance].host_api = @"http://192.168.0.122:8021/api/";
                                                           
                                                           
                                                       }];
    UIAlertAction* devAction = [UIAlertAction actionWithTitle:@"开发192.168.0.63:8021" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            
                                                            [TTWNetworkHandler sharedInstance].host_api = @"http://192.168.0.63:8021/api/";
                                                            
                                                            
                                                        }];
    
    
    UIAlertAction* ceshilAction = [UIAlertAction actionWithTitle:@"生产环境www.MEIB.IO" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             [TTWNetworkHandler sharedInstance].host_api = HOST;
                                                             
                                                         }];
    [alert addAction:huangAction];
    [alert addAction:wangAction];
    [alert addAction:devAction];
    [alert addAction:ceshilAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
#endif

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (! [self.vcNoBackBtnArr containsObject:NSStringFromClass([self class])]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //隐藏导航下面的黑线
    self.navBarHairlineImageView.hidden = YES;
#ifdef DEBUG
    //摇一摇取消第一响应者
    [self resignFirstResponder];
#endif
}

-(void)setupSubviews{
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [self.view endEditing:YES];
}

-(UIImageView *)navBarHairlineImageView{
    if(!_navBarHairlineImageView){
        _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    return _navBarHairlineImageView;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark-- 点击背景 隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark- 绑定数据
- (void)bindViewModel{}
#pragma mark- 设置导航样式
-(void)setUpNavUI{
    
    BOOL needBackBtn = [self.vcNoBackBtnArr containsObject:NSStringFromClass([self class])] ? NO : YES;
     [self setNavBarStyle:NavigationBarStyleWhite backBtn:needBackBtn];
    /*
    if (! [self.vcNoBackBtnArr containsObject:NSStringFromClass([self class])]) {
        //默认设置返回按钮图片
        //[self setLeftItemWithIcon:[UIImage imageNamed:@"back"] title:@"" titleColor:[UIColor blackColor] selector:@selector(back)];
      //  [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(back)];
        
    }
    
    //此方法要在plist中设置View controller-based status bar appearance = NO
//    [self setNavBarWithTextColor:black_color barTintColor:kNavTintColor tintColor:black_color statusBarStyle:UIStatusBarStyleDefault];
*/
}

//不需要返回按钮的控制器
- (NSArray *)vcNoBackBtnArr
{
    if (!_vcNoBackBtnArr) {
        _vcNoBackBtnArr = [NSArray arrayWithObjects:@"HomePageIndexVC",@"MarketIndexVC",@"FiatDealIndexVC",@"CoinDealIndexVC",nil];
    }
    return _vcNoBackBtnArr;
}

#pragma mark - override
// 返回箭头事件默认处理，可重载自定义
-(void)back{
    ///点击返回，取消当前页面的所以请求
    [TTWNetworkHandler cancelRequestWithControllerName:NSStringFromClass([self class])];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private
- (void)setIsExtendLayout:(BOOL)isExtendLayout{
    
    if (isExtendLayout) {
        //这行代码导航完全透明
        //[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = YES;
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        self.edgesForExtendedLayout = UIRectEdgeAll;
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


#pragma mark - 回到导航Index

- (void)popToHomePageWithTabIndex:(NSInteger)index
                       completion:(void (^)(void))completion
{
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    NSInteger viewIndex = 0;
    for (UIView *view in keyWindow.subviews)
    {
        if (viewIndex > 0)
        {
            [view removeFromSuperview];
        }
        viewIndex++;
    }
    
    self.tabBarController.selectedIndex = index;
    if ([self.tabBarController presentedViewController]) {
        [self.tabBarController dismissViewControllerAnimated:NO completion:^{
            for (UINavigationController *nav in self
                 .tabBarController.viewControllers) {
                [nav popToRootViewControllerAnimated:NO];
            }
            if (completion)
                completion();
        }];
    } else {
        for (UINavigationController *nav in self
             .tabBarController.viewControllers) {
            [nav popToRootViewControllerAnimated:NO];
        }
        if (completion)
            completion();
    }
}

- (void)pushViewControllerWithName:(id)classOrName {
    if (classOrName) {
        Class classs;
        if ([classOrName isKindOfClass:[NSString class]]) {
            NSString *name = classOrName;
            classs = NSClassFromString(name);
            UIViewController *vc = [classs new];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([classOrName isKindOfClass:[UIViewController class]]||[classOrName isKindOfClass:[UITableView class]]) {
        
            [self.navigationController pushViewController:classOrName animated:YES];
        }
        
        
    }
}

- (void)popToViewControllerWithClass:(id)classOrName {
    if (classOrName) {
        Class classs;
        if ([classOrName isKindOfClass:[NSString class]]) {
            NSString *name = classOrName;
            classs = NSClassFromString(name);
            
            [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:classs]) {
                    [self.navigationController popToViewController:obj animated:YES];
                    *stop = YES;
                    return;
                }
            }];
            
        } else if ([classOrName isKindOfClass:[UIViewController class]]||[classOrName isKindOfClass:[UITableView class]]) {
      
            [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         
                if ([obj isKindOfClass:[classOrName class]]) {
                    [self.navigationController popToViewController:obj animated:YES];
                    *stop = YES;
                    return;
                }
            }];
        }
        
        
    }
}


@end
