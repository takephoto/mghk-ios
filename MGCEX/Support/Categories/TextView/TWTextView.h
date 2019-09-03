//
//  XDTextView.h
//  weibo
//
//  Created by dxd on 16/6/13.
//  Copyright © 2016年 dxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTextView : UITextView<UITextViewDelegate>

//注意：必须要设置limitLength才能输入

// 偏移
@property (nonatomic, assign) NSInteger x;
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 限制文字长度 */
@property (nonatomic, assign) NSInteger limitLength;
/**编辑过程回调*/
@property (nonatomic,copy) void(^isChangeBlock)(NSString * text);
/**开始编辑回调*/
@property (nonatomic,copy) void(^isBeginBlock)(NSString * text);
/**编辑结束回调*/
@property (nonatomic,copy) void(^isEndBlock)(NSString * text);
@end
