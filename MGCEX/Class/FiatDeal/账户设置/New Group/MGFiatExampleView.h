//
//  MGFiatExampleView.h
//  MGCEX
//
//  Created by Joblee on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseView.h"

@interface MGFiatExampleView : BaseView


//取消按钮点击事件
typedef void(^cancelBlock)(void);

-(instancetype)initWithSupView:(UIView *)toView;

- (void)show;

-(void)hidden;

@end
