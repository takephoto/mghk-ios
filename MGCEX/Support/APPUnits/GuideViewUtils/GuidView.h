//
//  GuidView.h
//  引导图
//

#import <UIKit/UIKit.h>

@interface GuidView : UIView
//将要消失
@property (nonatomic, copy) void (^disappear)(void);

@property (nonatomic, strong) UIColor *pageColor;

@property (nonatomic, strong) UIColor *currenPageColor;

- (void)show;
@end
