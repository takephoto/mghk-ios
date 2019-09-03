//
//  PPNumberButton.m
//  PPNumberButton
//
//  Created by AndyPang on 16/8/31.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

/*
 *********************************************************************************
 *
 *⭐️⭐️⭐️ 新建 PP-iOS学习交流群: 323408051 欢迎加入!!! ⭐️⭐️⭐️
 *
 * 如果您在使用 PPNumberButton 的过程中出现bug或有更好的建议,还请及时以下列方式联系我,我会及
 * 时修复bug,解决问题.
 *
 * Weibo : CoderPang
 * Email : jkpang@outlook.com
 * QQ 群 : 323408051
 * GitHub: https://github.com/jkpang
 *
 * PS:我的另外两个很好用的封装,欢迎使用!
 * 1.对AFNetworking 3.x 与YYCache的二次封装,一句代码搞定数据请求与缓存,告别FMDB:
 *   GitHub:https://github.com/jkpang/PPNetworkHelper
 * 2.一行代码获取通讯录联系人,并进行A~Z精准排序(已处理姓名所有字符的排序问题):
 *   GitHub:https://github.com/jkpang/PPGetAddressBook
 *
 * 如果 PPNumberButton 好用,希望您能Star支持,你的 ⭐️ 是我持续更新的动力!
 *********************************************************************************
 */


#import "PPNumberButton.h"

#ifdef DEBUG
#define PPLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define PPLog(...)
#endif




@interface PPNumberButton ()
/** 减按钮*/
@property (nonatomic, strong) UIButton *decreaseBtn;
/** 加按钮*/
@property (nonatomic, strong) UIButton *increaseBtn;

/** 快速加减定时器*/
@property (nonatomic, strong) NSTimer *timer;
/** 控件自身的宽*/
@property (nonatomic, assign) CGFloat width;
/** 控件自身的高*/
@property (nonatomic, assign) CGFloat height;
/** 按钮的宽*/
@property (nonatomic, assign) CGFloat btnWidth;
/** 输入框类型*/
@property (nonatomic, assign) NSInteger inputType;

@end


@implementation PPNumberButton

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)type
{
    if (self = [super initWithFrame:frame]) {
        self.inputType = type;
        [self setupUI];
        //整个控件的默认尺寸(和某宝上面的按钮同样大小)
        if(CGRectIsEmpty(frame)) {self.frame = CGRectMake(0, 0, 110, 30);};
    }
    return self;
}



+ (instancetype)numberButtonWithFrame:(CGRect)frame
{
    return [[PPNumberButton alloc] initWithFrame:frame];
}
#pragma mark - 设置UI子控件
- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 0.f;
    self.clipsToBounds = YES;
    
    _minValue = 1;
    _maxValue = NSIntegerMax;
    _inputFieldFont = 15;
    _buttonTitleFont = 17;
    
    //加,减按钮
    _increaseBtn = [self creatButton];
    _decreaseBtn = [self creatButton];
    [self addSubview:_decreaseBtn];
    [self addSubview:_increaseBtn];
    
    //数量展示/输入框
    _textField = [[UITextField alloc] init];
   // _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
//    _textField.font = H15;
    _textField.adjustsFontSizeToFitWidth = YES;

    //默认
    _textField.limitDecimalDigitLength = s_Integer(8);
    self.PriceminUnit = 0.00000001;
    self.NumberminUnit = 0.00000001;
    
 
    _textField.text = [[NSString stringWithFormat:@"%.20f",_minValue] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
    
    _textField.textColor = _textColor;
    
    @weakify(self);
    _textField.endEditBlock = ^(NSString *text) {
        @strongify(self);

        if(kStringIsEmpty(text))  text = @"0";
        if(text.length>0){

            NSString *last = [text substringFromIndex:text.length-1];
            if([last isEqualToString:@"."]){
                self.textField.text = [text substringToIndex:([text length]-1)];

            }
            
            
        }

        [self checkTextFieldNumberWithUpdate];
        [self buttonClickCallBackWithIncreaseStatus:NO];
        if([self.textField.text floatValue] == 0){
            if(self.inputType == 1){
               self.textField.text = @"0";
            }else{
              self.textField.text = @"";
            }
            
        }else{
          self.textField.text = [[self.textField.text keepDecimal:[self.textField.limitDecimalDigitLength integerValue]] removeFloatAllZero];
        }
        
    };

    self.textField.didChangeBlock = ^(NSString *text) {

        if(kStringIsEmpty(text))  text = @"0";

    };
    
   
    
    [self addSubview:_textField];
}

//设置加减按钮的公共方法
- (UIButton *)creatButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:_buttonTitleFont];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
    return button;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _width =  self.frame.size.width;
    _height = self.frame.size.height;
    _btnWidth = self.frame.size.height - Adapted(5);
    _textField.frame = CGRectMake(_btnWidth, 0, _width - 2*_btnWidth, _height);
    _increaseBtn.frame = CGRectMake(_width - _btnWidth, 0, _btnWidth, _height);
    
    if (_decreaseHide && _textField.text.integerValue < _minValue) {
        _decreaseBtn.frame = CGRectMake(_width-_btnWidth, 0, _btnWidth, _height);
    } else {
        _decreaseBtn.frame = CGRectMake(0, 0, _btnWidth, _height);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - 加减按钮点击响应
/**
 点击: 单击逐次加减,长按连续快速加减
 */
- (void)touchDown:(UIButton *)sender
{
    [_textField resignFirstResponder];
    
    if (sender == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

/**
 手指松开
 */
- (void)touchUp:(UIButton *)sender { [self cleanTimer]; }

/**
 加运算
 */
- (void)increase
{
    [self checkTextFieldNumberWithUpdate];
    
    double number = 0.0;
    NSString * numberStr;
    if(self.inputType == 1){
        numberStr = SNAdd(_textField.text, [NSNumber numberWithDouble:self.PriceminUnit]);
    }else if(self.inputType == 2){
        numberStr =SNAdd(_textField.text, [NSNumber numberWithDouble:self.NumberminUnit]);
    }
    
    if ([numberStr doubleValue] <= _maxValue) {

        _textField.text = [[NSString stringWithFormat:@"%@",numberStr] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
        
        
        [self buttonClickCallBackWithIncreaseStatus:YES];
    } else {
        if (_shakeAnimation) { [self shakeAnimationMethod]; } PPLog(@"已超过最大数量%f",_maxValue);
    }
}

/**
 减运算
 */
- (void)decrease
{
    [self checkTextFieldNumberWithUpdate];
    
    double number = 0.0;
    NSString * numberStr;
    if(self.inputType == 1){
        number =_textField.text.doubleValue - self.PriceminUnit;
        numberStr = SNSub(_textField.text, [NSNumber numberWithDouble:self.PriceminUnit]);
    }else if(self.inputType == 2){
        number =_textField.text.doubleValue - self.NumberminUnit;
        numberStr = SNSub(_textField.text, [NSNumber numberWithDouble:self.NumberminUnit]);
    }

    
    if ([numberStr doubleValue] >= _minValue) {
        _textField.text = [[NSString stringWithFormat:@"%.@", numberStr] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
        
        [self buttonClickCallBackWithIncreaseStatus:NO];
    } else {
        // 当按钮为"减号按钮隐藏模式",且输入框值 < 设定最小值,减号按钮隐藏
        if (_decreaseHide && number<_minValue) {
            _textField.hidden = YES;
            _textField.text = [[NSString stringWithFormat:@"%.20f", number] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
            
            
            [self buttonClickCallBackWithIncreaseStatus:NO];
            [self rotationAnimationMethod];
            
            return;
        }
        if (_shakeAnimation) { [self shakeAnimationMethod]; } PPLog(@"数量不能小于%lf",_minValue);
    }
}

/**
 点击响应
 */
- (void)buttonClickCallBackWithIncreaseStatus:(BOOL)increaseStatus
{
    _resultBlock ? _resultBlock(_textField.text.doubleValue, increaseStatus) : nil;
    if ([_delegate respondsToSelector:@selector(pp_numberButton: number: increaseStatus:)]) {
        [_delegate pp_numberButton:self number:_textField.text.doubleValue increaseStatus:increaseStatus];
    }
}

/**
 检查TextField中数字的合法性,并修正
 */
- (void)checkTextFieldNumberWithUpdate
{
    NSString *minValueString;
    NSString *maxValueString;
  
    minValueString = [NSString stringWithFormat:@"%.20f",_minValue];
    maxValueString = [NSString stringWithFormat:@"%.20f",_maxValue];
    
    if ([minValueString doubleValue] == 0) {
        minValueString = @"";
    }
    if ([maxValueString doubleValue] == 0) {
        maxValueString = @"";
    }
    
    if ([_textField.text pp_isNotBlank] == NO || _textField.text.integerValue < _minValue) {
        if(self.inputType == 1){
            _textField.text = _decreaseHide ? [[NSString stringWithFormat:@"%.20f",minValueString.doubleValue-self.PriceminUnit] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]]:minValueString;
        }else if (self.inputType == 2){
            _textField.text = _decreaseHide ? [[NSString stringWithFormat:@"%.20f",minValueString.doubleValue-self.NumberminUnit] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]]:minValueString;
        }
        
    }
    if(_textField.text.doubleValue > _maxValue){
        [TTWHUD showCustomMsg:kLocalizedString(@"可用余额不足")];
    }
    _textField.text.doubleValue > _maxValue ? _textField.text = maxValueString : nil;
    [self checkTextfield];
}
- (void)checkTextfield
{
    
    if (_textField.text.length <= 0) {
        _textField.text = @"0";
    }else{
        if ([_textField.text doubleValue] == 0) {
            _textField.text = @"0";
        }
    }
    
}
/**
 清除定时器
 */
- (void)cleanTimer
{
    if (_timer.isValid) { [_timer invalidate] ; _timer = nil; }
}

#pragma mark - 加减按钮的属性设置

- (void)setDecreaseHide:(BOOL)decreaseHide
{
    // 当按钮为"减号按钮隐藏模式(饿了么/百度外卖/美团外卖按钮样式)"
    if (decreaseHide) {
        if (_textField.text.doubleValue <= _minValue) {
            _textField.hidden = YES;
            _decreaseBtn.alpha = 0;
            if(self.inputType == 1){
               _textField.text = [[NSString stringWithFormat:@"%.20f",_minValue-self.PriceminUnit] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
            }else if (self.inputType == 2){
               _textField.text = [[NSString stringWithFormat:@"%.20f",_minValue-self.NumberminUnit] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
            }
             [self checkTextfield];
            _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
        }
        self.backgroundColor = [UIColor clearColor];
    } else {
        _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
    }
    _decreaseHide = decreaseHide;
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    _textField.enabled = editing;
}

- (void)setMinValue:(float)minValue
{
    _minValue = minValue;

    _textField.text = [[NSString stringWithFormat:@"%.20f",minValue] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
    
     [self checkTextfield];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [borderColor CGColor];
    
    _decreaseBtn.layer.borderWidth = 0.5;
    _decreaseBtn.layer.borderColor = [borderColor CGColor];
    
    _increaseBtn.layer.borderWidth = 0.5;
    _increaseBtn.layer.borderColor = [borderColor CGColor];
}

- (void)setButtonTitleFont:(CGFloat)buttonTitleFont
{
    _buttonTitleFont = buttonTitleFont;
    _increaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:buttonTitleFont];
    _decreaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:buttonTitleFont];
}

- (void)setIncreaseTitle:(NSString *)increaseTitle
{
    _increaseTitle = increaseTitle;
    [_increaseBtn setTitle:increaseTitle forState:UIControlStateNormal];
}

- (void)setDecreaseTitle:(NSString *)decreaseTitle
{
    _decreaseTitle = decreaseTitle;
    [_decreaseBtn setTitle:decreaseTitle forState:UIControlStateNormal];
}

- (void)setIncreaseImage:(UIImage *)increaseImage
{
    _increaseImage = increaseImage;
    [_increaseBtn setBackgroundImage:increaseImage forState:UIControlStateNormal];
}

- (void)setDecreaseImage:(UIImage *)decreaseImage
{
    _decreaseImage = decreaseImage;
    [_decreaseBtn setBackgroundImage:decreaseImage forState:UIControlStateNormal];
}

#pragma mark - 输入框中的内容设置
- (float)currentNumber { return _textField.text.doubleValue; }

- (void)setCurrentNumber:(float)currentNumber
{
    if (_decreaseHide && currentNumber < _minValue) {
        _textField.hidden = YES;
        _decreaseBtn.alpha = 0;
        _decreaseBtn.frame = CGRectMake(_width-_height, 0, _height, _height);
    } else {
        _textField.hidden = NO;
        _decreaseBtn.alpha = 1;
        _decreaseBtn.frame = CGRectMake(0, 0, _height, _height);
    }
  
    _textField.text = [[NSString stringWithFormat:@"%.20f",currentNumber] keepDecimal:[self.textField.limitDecimalDigitLength integerValue]];
   
    [self checkTextFieldNumberWithUpdate];
     [self checkTextfield];
}

- (void)setInputFieldFont:(CGFloat)inputFieldFont
{
    _inputFieldFont = inputFieldFont;
    _textField.font = [UIFont systemFontOfSize:inputFieldFont];
}
-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _textField.textColor = textColor;
}
#pragma mark - 核心动画
/**
 抖动动画
 */
- (void)shakeAnimationMethod
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    CGFloat positionX = self.layer.position.x;
    animation.values = @[@(positionX-10),@(positionX),@(positionX+10)];
    animation.repeatCount = 3;
    animation.duration = 0.07;
    animation.autoreverses = YES;
    [self.layer addAnimation:animation forKey:nil];
}
/**
 旋转动画
 */
- (void)rotationAnimationMethod
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = @(M_PI*2);
    rotationAnimation.duration = 0.3f;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [_decreaseBtn.layer addAnimation:rotationAnimation forKey:nil];

}


#pragma 懒加载

-(void)setPriceminUnit:(double)PriceminUnit{
    _PriceminUnit = PriceminUnit;
 
}

-(void)setNumberminUnit:(double)NumberminUnit{
    _NumberminUnit = NumberminUnit;
    
}



@end

#pragma mark - NSString分类

@implementation NSString (PPNumberButton)
- (BOOL)pp_isNotBlank
{
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}



@end
