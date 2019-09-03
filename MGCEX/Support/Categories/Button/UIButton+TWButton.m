//
//  UIButton+TWButton.m
//  sdaasda
//
//  Created by MGCion on 2017/10/18.
//  Copyright © 2017年 MGCion. All rights reserved.
//

#import "UIButton+TWButton.h"
#import <objc/runtime.h>

@implementation UIButton (TWButton)

static char timeKey;

-(void)setTimeFinishBlock:(TimeFinishBlock)timeFinishBlock
{
    objc_setAssociatedObject(self, @selector(timeFinishBlock), timeFinishBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

-(TimeFinishBlock)timeFinishBlock
{
    return objc_getAssociatedObject(self, @selector(timeFinishBlock));
}


-(void)setTimeOutNumber:(NSInteger)timeOutNumber
{
    NSNumber * number = [NSNumber numberWithInteger:timeOutNumber];
    objc_setAssociatedObject(self, @selector(timeOutNumber), number, OBJC_ASSOCIATION_ASSIGN);
    
}

-(NSInteger)timeOutNumber
{
    NSNumber * number = objc_getAssociatedObject(self, @selector(timeOutNumber));
    return number.integerValue;
}


-(void)setTimer:(dispatch_source_t)timer
{
    objc_setAssociatedObject(self, &timeKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(dispatch_source_t)timer
{
    return  objc_getAssociatedObject(self, &timeKey);
}

-(void)setCallBackBlock:(CallBackBlock)callBackBlock
{
    objc_setAssociatedObject(self, @selector(callBackBlock), callBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

-(CallBackBlock)callBackBlock
{
    return objc_getAssociatedObject(self, @selector(callBackBlock));
}

///--------------------   点击事件回掉    ----------------///
-(void)mg_addTapBlock:( CallBackBlock )block;
{
    self.callBackBlock = block;
    [self addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didClickAction:(UIButton *)button {
    
    if(self.callBackBlock)
    {
        self.callBackBlock(button);
        
    }
}

///--------------------      图文排列     ----------------///

- (void)mg_setbuttonType:(TWImagePositionStyle)type spacing:(CGFloat )spacing; {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
 
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat labelWidth = textSize.width;;
    CGFloat labelHeight = textSize.height;

    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (type) {
        case TWImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case TWImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case TWImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case TWImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
}


///--------------------    扩大button响应范围    ----------------///

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)mg_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
  
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}


///-------------------     倒计时      ---------------////
- (void)mg_startCountDownTime:(NSInteger )timeout finishTitle:(NSString *)tittle waitTittle:(NSString *)waitTittle finishColor:(UIColor *)FColor waitColor:(UIColor *)WColor Finish:(TimeFinishBlock)timeBlock {
    
    
    __weak typeof(self) weakSelf = self;
    __block NSInteger timeOut=timeout; //倒计时时间
    weakSelf.timeFinishBlock = timeBlock;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    weakSelf.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(self.timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
 
            dispatch_source_cancel(weakSelf.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(weakSelf.timeFinishBlock)
                {
                    weakSelf.timeFinishBlock(weakSelf);
                }
                
               if(FColor) weakSelf.backgroundColor = FColor;
                
               if(tittle) [weakSelf setTitle:tittle forState:UIControlStateNormal];
                
                self.userInteractionEnabled = YES;
            });
        }else{
            //  int minutes = timeout / 60;
            int seconds = timeOut % 60;
            weakSelf.timeOutNumber = seconds;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(WColor) weakSelf.backgroundColor = WColor;
                
                if(waitTittle.length==0)
                {
                 [weakSelf setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                }else
                {
                  [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTittle] forState:UIControlStateNormal];
                    
                }
                
                weakSelf.userInteractionEnabled = NO;
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(weakSelf.timer);
}



///-------------------     按钮菊花      ---------------////

static NSString *const mg_IndicatorViewKey = @"indicatorView";


- (void)mg_showIndicator{
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    objc_setAssociatedObject(self, &mg_IndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.enabled = NO;
    [self addSubview:indicator];
    
    
}

- (void)mg_hideIndicator {
    
 
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &mg_IndicatorViewKey);

    [indicator removeFromSuperview];
   
    self.enabled = YES;
    
}

///-------------------     截取颜色设置背景     ---------------////

- (void)mg_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton mg_b_imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)mg_b_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

///-------------------     切半角     ---------------////

-(void)mg_RoundedRectWithType:(UIRectCorner)type Radius:(CGFloat)radius;
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:type cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

/**
 * 使能失能按钮
 *@param enableColor 使能颜色
 *@param disableColor 失能颜色
 */
-(void)setStatusWithEnableColor:(UIColor *)enableColor disableColor:(UIColor *)disableColor{
    @weakify(self)
    [RACObserve(self, enabled) subscribeNext:^(id x) {
        @strongify(self);
        self.alpha = 1.0;
        if(self.enabled == NO){
//            self.alpha = 0.9;
//            [self setBackgroundImage:[UIImage imageWithColor:disableColor] forState:UIControlStateNormal];
            [self setBackgroundColor:disableColor forState:UIControlStateNormal];
        }else{
//            self.alpha = 1.0;
//            [self setBackgroundImage:[UIImage imageWithColor:enableColor] forState:UIControlStateNormal];
            [self setBackgroundColor:enableColor forState:UIControlStateNormal];
        }
        
    }];

    
}

- (void)setButtonCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    if (cornerRadius > 0){
        self.layer.cornerRadius = cornerRadius;
    }
    if (borderColor){
        self.layer.borderColor = borderColor.CGColor;
    } else{
        self.layer.borderColor = kRedColor.CGColor;
    }
    if (borderWidth > 0){
        self.layer.borderWidth = borderWidth;
    }
    self.clipsToBounds = YES;
    [self.layer masksToBounds];
}


@end
