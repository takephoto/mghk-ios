// MGC
//
// TTWActionSheetView.m
// MGCPay
//
// Created by MGC on 2018/2/5.
// Copyright © 2018年 Joblee. All rights reserved.
//
// @ description <#描述#> 

#import "TTWActionSheetView.h"
#import "UIImage+scale.h"

#define kRowHeight 50.0f
#define kRowLineHeight 0.0f
#define kSeparatorHeight 10.0f
#define kBtnTextColor kTextColor
#define kTitleFontSize 13.0f
#define kButtonTitleFontSize 17.0f


@interface TTWActionSheetView ()
{
    UIView      *_backView;
    UIView *_actionSheetView;
    CGFloat _actionSheetHeight;
    BOOL        _isShow;
}

@property (nonatomic, copy)  NSString *title;
@property (nonatomic, copy)  NSString *cancelButtonTitle;
@property (nonatomic, copy)  NSString *destructiveButtonTitle;
@property (nonatomic, copy) NSArray *otherButtonTitles;
@property (nonatomic, copy) TTWActionSheetViewDidSelectButtonBlock selectRowBlock;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) NSInteger index;
@end

@implementation TTWActionSheetView

- (void)dealloc
{
    self.title= nil;
    self.cancelButtonTitle = nil;
    self.destructiveButtonTitle = nil;
    self.otherButtonTitles = nil;
    self.selectRowBlock = nil;
    
    _actionSheetView = nil;
    _backView = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title selectIndex:(NSInteger )index cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(TTWActionSheetViewDidSelectButtonBlock)block;
{
    self = [self init];
    
    if (self)
    {
        _index = index;
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        _otherButtonTitles = otherButtonTitles;
        _selectRowBlock = block;
        
        _backView = [[UIView alloc] initWithFrame:self.frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _backView.alpha = 0.0f;
        [self addSubview:_backView];
        
        _actionSheetView = [[UIView alloc] init];
        _actionSheetView.backgroundColor = white_color;
        [self addSubview:_actionSheetView];
        
        CGFloat offy = 0;
        CGFloat width = self.frame.size.width;
        
        UIImage *normalImage = [UIImage imageWithColor:[UIColor whiteColor]];
        UIImage *highlightedImage = [UIImage imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        if (_title && _title.length>0)
        {
            CGFloat spacing = 15.0f;
            
            CGFloat titleHeight = ceil([_title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + spacing*2;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, titleHeight)];
            self.titleLabel = titleLabel;
            titleLabel.backgroundColor = [UIColor whiteColor];
            titleLabel.textColor = kTextColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = H15;
            titleLabel.numberOfLines = 0;
            titleLabel.text = _title;
            [_actionSheetView addSubview:titleLabel];
            
            offy += titleHeight+kRowLineHeight;
        }
        
        if ([_otherButtonTitles count] > 0)
        {
            for (int i = 0; i < _otherButtonTitles.count; i++)
            {
                _btn = [[UIButton alloc] init];
                _btn.frame = CGRectMake(0, offy, width, kRowHeight);
                _btn.tag = 10+i;
                _btn.backgroundColor = [UIColor whiteColor];
                _btn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
                [_btn setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
                [_btn setBackgroundImage:normalImage forState:UIControlStateNormal];
                [_btn setTitleColor:kTextColor forState:UIControlStateNormal];
                _btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_btn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
                _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                _btn.titleEdgeInsets = UIEdgeInsetsMake(0, Adapted(15), 0, 0);
                [_btn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                [_actionSheetView addSubview:_btn];
                
                UIImageView * gouImageV = [[UIImageView alloc]init];
                [_actionSheetView addSubview:gouImageV];
                gouImageV.image = IMAGE(@"gou");
                [gouImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(Adapted(-15));
                    make.centerY.mas_equalTo(self.btn);
                    make.width.mas_equalTo(Adapted(15));
                    make.height.mas_equalTo(Adapted(13));
                }];
                gouImageV.tag = 50+i;
                gouImageV.hidden = YES;
                
                if(_index == i){
                    [_btn setTitleColor:kMainColor forState:UIControlStateNormal];
                    gouImageV.hidden = NO;
                }
                offy += kRowHeight+kRowLineHeight;
            }
            
            offy -= kRowLineHeight;
        }
        
        if (_destructiveButtonTitle && _destructiveButtonTitle.length>0)
        {
            offy += kRowLineHeight;
            
            UIButton *destructiveButton = [[UIButton alloc] init];
            destructiveButton.frame = CGRectMake(0, offy, width, kRowHeight);
            destructiveButton.tag = [_otherButtonTitles count] ?: 0;
            destructiveButton.backgroundColor = [UIColor whiteColor];
            destructiveButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [destructiveButton setTitleColor:kTextColor forState:UIControlStateNormal];
            [destructiveButton setTitle:_destructiveButtonTitle forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [destructiveButton addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_actionSheetView addSubview:destructiveButton];
            
            offy += kRowHeight;
        }
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offy, width, kSeparatorHeight)];
        separatorView.backgroundColor = UIColorFromRGB(0x000000);
        separatorView.alpha = 0.1;
        [_actionSheetView addSubview:separatorView];
        
        offy += kSeparatorHeight;
        
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        cancelBtn.frame = CGRectMake(0, offy, width, kRowHeight);
        cancelBtn.tag = -1;
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.titleLabel.font = H15;
        [cancelBtn setTitle:_cancelButtonTitle ?: kLocalizedString(@"取消") forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionSheetView addSubview:cancelBtn];
        
        offy += kRowHeight;
        
        _actionSheetHeight = offy;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
        
        //添加分割线
        for(int i=1;i<_otherButtonTitles.count;i++){
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.titleLabel.frame.size.height+i*kRowHeight, self.frame.size.width-30,1)];
            lineView.backgroundColor = kLineColor;
            [_actionSheetView addSubview:lineView];
        }
        
    }
    
    return self;
}

+ (TTWActionSheetView *)showActionSheetWithTitle:(NSString *)title selectIndex:(NSInteger )index cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(TTWActionSheetViewDidSelectButtonBlock)block;
{
    TTWActionSheetView *actionSheetView = [[TTWActionSheetView alloc] initWithTitle:title selectIndex:index cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:block];
    
    return actionSheetView;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_backView];
    if (!CGRectContainsPoint([_actionSheetView frame], point))
    {
        [self dismiss];
    }
}

- (void)didSelectAction:(UIButton *)button
{
    
    if (_selectRowBlock)
    {
        if(button.tag == -1){
            _selectRowBlock(self, button.tag);
            [self dismiss];
            return;
        }
        NSInteger nowIndex = button.tag;
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        
        //原按钮状态改变
        UIButton * oldBtn = [self viewWithTag:_index+10];
        [oldBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        UIImageView * oldImageV = [self viewWithTag:50+_index];
        oldImageV.hidden = YES;
        
        //选择按钮状态改变
        UIImageView * imageV = [self viewWithTag:40+button.tag];
        imageV.hidden = NO;
        
        _selectRowBlock(self, nowIndex-10);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
    
    
}




#pragma mark - public

- (void)show
{
    if(_isShow) return;
    
    _isShow = YES;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        _backView.alpha = 1.0;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-_actionSheetHeight, CGRectGetWidth(self.frame), _actionSheetHeight);
    } completion:NULL];
}

- (void)dismiss
{
    _isShow = NO;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        _backView.alpha = 0.0;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
