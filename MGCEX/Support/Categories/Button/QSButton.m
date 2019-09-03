//
//  QSButton.m
//  ZengLongSeSha
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 Song. All rights reserved.
//

#import "QSButton.h"
#import "UIView+Extension.h"

@implementation QSButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置button内容居中
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 得到imageView和TitleLabel的宽高
    CGFloat imageWidth = self.imageView.width;
    CGFloat imageHeight = self.imageView.height;
    
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat labelWidth = textSize.width;
    CGFloat labelHeight = textSize.height;
    
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (self.style) {
        case QSButtonImageStyleTop:{ // image在上面 label在下
            self.imageView.frame = CGRectMake((self.width - imageWidth) / 2.0, (self.height - imageHeight - labelHeight - self.space) / 2.0, imageWidth, imageHeight);
            labelEdgeInsets = UIEdgeInsetsMake(self.space + imageHeight + ((self.height - imageHeight - labelHeight - self.space) / 2.0), -imageWidth, 0, 0);
        }
            break;
            
        case QSButtonImageStyleRight:{ // image在右边 label在左边
            self.imageView.frame = CGRectMake((self.width - imageWidth - labelWidth - self.space) / 2.0 + labelWidth + self.space, (self.height - imageHeight) / 2.0, imageWidth, imageHeight);
            labelEdgeInsets = UIEdgeInsetsMake(0, (-imageWidth - self.space) * 2, 0, 0);
        }
            break;
            
        case QSButtonImageStyleBottom :{ // image在下面 label在上
            self.imageView.frame = CGRectMake((self.width - imageWidth) / 2.0, (self.height - imageHeight - labelHeight - self.space) / 2.0 + labelHeight + self.space, imageWidth, imageHeight);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - self.space - ((self.height - imageHeight - labelHeight - self.space) / 2.0), -imageWidth, 0, 0);
            
        }
            break;
        case QSButtonImageStyleLeft:{
            self.imageView.frame = CGRectMake(0, (self.height - imageHeight) / 2.0, imageWidth, imageHeight);
            labelEdgeInsets = UIEdgeInsetsMake(0, (- imageWidth - self.space), 0, 0);
        }
            break;
        default:
            break;
    }
    
    // 赋值
    self.titleEdgeInsets = labelEdgeInsets;
}
@end
