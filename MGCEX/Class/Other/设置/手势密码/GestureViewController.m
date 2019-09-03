
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "LoginIndexVC.h"

@interface GestureViewController ()<UINavigationControllerDelegate, CircleViewDelegate>


@property (nonatomic, assign) NSInteger  errorNumber;
/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

@end

@implementation GestureViewController

-(void)back{
//    [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
    if(self.navigationController.presentingViewController){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    (self.type == GestureViewControllerTypeLogin) ? (self.title = @"") : (self.title = kLocalizedString(@"手势密码"));
    [self.view setBackgroundColor:kBackGroundColor];

    self.navigationController.delegate = self;

    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}



#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(Adapted(15), 0, kScreenW-Adapted(15), Adapted(60));
    msgLabel.numberOfLines = 0;
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame)+ Adapted(50));
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    if(self.type == GestureViewControllerTypeLogin){
        [lockView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, CircleViewCenterY*1.3 - TW_TopHeight)];
        self.msgLabel.text = kLocalizedString(@"请输入手势密码");
        self.msgLabel.textColor = kTextColor;
        self.msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame)- Adapted(50));
        //账号
        UILabel * userName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 20)];
        userName.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - Adapted(80));
        [self.view addSubview:userName];
        userName.textColor = kTextColor;
        userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentLogin];
        userName.text = [TWAppTool mg_securePhoneMailText:userName.text];
        userName.font = H20;
        userName.textAlignment = NSTextAlignmentCenter;
        
        
        self.errorNumber = 5;
    }else{
        [lockView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, CircleViewCenterY*1.22)];
    }
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    self.title = kLocalizedString(@"设置手势密码");
 
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
    
    // 管理手势密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:forgetBtn];
    [forgetBtn setTitle:kLocalizedString(@"忘记手势密码") forState:UIControlStateNormal];
    [forgetBtn setTitleColor:kAssistColor forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = H14;
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(30));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(Adapted(-29));
        make.right.mas_equalTo(Adapted(-30));
        make.height.mas_equalTo(Adapted(40));
    }];

    [forgetBtn mg_addTapBlock:^(UIButton *button) {
  
        [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KillLogin];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endAppTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [TWAppTool gotoIndexVCLoginRootVc];
        
    }];
}

#pragma mark - button点击事件
- (void)didClickRightItem {
    NSLog(@"点击了重设按钮");
    // 1.隐藏按钮
    self.navigationItem.rightBarButtonItem.title = nil;

    // 2.infoView取消选中
    [self infoViewDeselectedSubviews];

    // 3.msgLabel提示文字复位
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];

    // 4.清除之前存储的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}


- (void)didClickBtn:(UIButton *)sender
{
 
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
//连线个数少于6个时，通知代理
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalizedString(@"重设") style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem)];
        [self.navigationItem.rightBarButtonItem setTintColor:white_color];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}
//第一次设置成功绘制
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

//获取到第二个手势密码时通知代理
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
   
    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalizedString(@"重设") style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem)];
        [self.navigationItem.rightBarButtonItem setTintColor:white_color];
    
    }
}

#pragma mark - circleView - delegate - login or verify gesture
//登陆或者验证手势密码输入完成时的代理方法
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功！");
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KillLogin];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endAppTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (self.navigationController.presentingViewController) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            NSLog(@"密码错误！");
            self.errorNumber = self.errorNumber-1;
            if(self.errorNumber == 0){
                [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KillLogin];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLogin];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TokenDisabled];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endAppTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (self.navigationController.presentingViewController) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [TWAppTool gotoIndexVCLoginRootVc];

            }else{
                NSString * str1 = kLocalizedString(@"密码输入错误,您还有");
                NSString * str2 = kLocalizedString(@"次机会");
                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"%@%ld%@",str1,self.errorNumber,str2]];
                [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
           
            }
            
            
            
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.status == CircleStateSelected || circle.status == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setStatus:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中

- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setStatus:CircleStateNormal];
    }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.type == GestureViewControllerTypeLogin) {
//        [self.navigationController setNavigationBarHidden:isLoginType animated:YES];
        self.navigationController.navigationBar.barTintColor = kBackGroundColor;
    }
}




@end
