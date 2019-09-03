//
//  GuidView.m
//  引导图
//

#import "GuidView.h"

@interface GuidView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GuidView

- (NSArray *)imageArray {
    if (!_imageArray) {
        
        
//        NSString *currentLanguage = [NSBundle getPreferredLanguage];
        
            //简体中文
            if(IS_IPHONE5){
                _imageArray = [[NSArray alloc]initWithObjects:kLocalizedString(@"welcome5_1"),kLocalizedString(@"welcome5_2"),kLocalizedString(@"welcome5_3"), nil];
            }else if (IS_IPHONE6){
                _imageArray = [[NSArray alloc]initWithObjects:kLocalizedString(@"welcome6_1"),kLocalizedString(@"welcome6_2"),kLocalizedString(@"welcome6_3"), nil];
            }else if (IS_IPHONE6p){
                _imageArray = [[NSArray alloc]initWithObjects:kLocalizedString(@"welcome6p_1"),kLocalizedString(@"welcome6p_2"),kLocalizedString(@"welcome6p_3"), nil];
            }else if (IS_IPHONEX){
                _imageArray = [[NSArray alloc]initWithObjects:kLocalizedString(@"welcomex_1"),kLocalizedString(@"welcomex_2"),kLocalizedString(@"welcomex_3"), nil];
            }else{
                //ipad适配
                _imageArray = [[NSArray alloc]initWithObjects:kLocalizedString(@"welcome6_1"),kLocalizedString(@"welcome6_2"),kLocalizedString(@"welcome6_3"), nil];
            }
        }
    return _imageArray;
}

- (UIPageControl *)pageControl {
    if (!_pageControl ) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 80, self.bounds.size.width, 20)];
        _pageControl.numberOfPages = self.imageArray.count;
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = self.pageColor;
        _pageControl.currentPageIndicatorTintColor = self.currenPageColor ? self.currenPageColor :[UIColor purpleColor];
        _pageControl.userInteractionEnabled = NO;
        
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        //此处设置可以滑过去
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * (self.imageArray.count + 1), 0);
    }
    return _scrollView;
}
- (void)show {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 当前顶层窗口
    [[self lastWindow] addSubview:self];
}

- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    [self addSubview:self.scrollView];
    //[self addSubview:self.pageControl];
    for (int i = 0; i < self.imageArray.count; i ++) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:self.imageArray[i] ofType:@"png"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.bounds.size.width, 0 , self.bounds.size.width, self.bounds.size.height)];
        imageView.tag =20+i;
        imageView.image = IMAGE(self.imageArray[i]);
        //[UIImage imageWithContentsOfFile:path];
        [self.scrollView addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        if(i == self.imageArray.count-1){
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageView addSubview:btn];
//            [btn setImage:IMAGE(@"button_667h") forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imageView);
                make.bottom.mas_equalTo(self.mas_bottom).offset(0);
                make.width.mas_equalTo(Adapted(kScreenW));
                make.height.mas_equalTo(Adapted(kScreenH / 2.0));
            }];
            @weakify(self);
            [btn mg_addTapBlock:^(UIButton *button) {
                @strongify(self);
                [self disapperOperation];
            }];
        }
        
        
        
//        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isTap:)];
//        [imageView addGestureRecognizer:tap];
    }
    
    //跳过按钮
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:skipBtn];
    skipBtn.layer.cornerRadius = Adapted(13);
    skipBtn.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(Adapted(50));
        make.right.mas_offset(Adapted(-10));
        make.width.mas_offset(Adapted(59));
        make.height.mas_offset(Adapted(26));
    }];
    
    [skipBtn setTitle:kLocalizedString(@"跳过") forState:UIControlStateNormal];
    skipBtn.titleLabel.font = H12;
    [skipBtn addTarget:self action:@selector(disapperOperation) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}


-(void)isTap:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == self.imageArray.count+20-1)
    {
        [self disapperOperation];
    }
}

//消失处理
-(void)disapperOperation{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"isyingdao" forKey:@"isyingdao"];
    [user synchronize];
    
    [self removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
    
    if (self.disappear) self.disappear();
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / self.bounds.size.width;
    
    if (scrollView.contentOffset.x == (self.imageArray.count) * self.bounds.size.width) {
        
        [self disapperOperation];
    }
}
@end
