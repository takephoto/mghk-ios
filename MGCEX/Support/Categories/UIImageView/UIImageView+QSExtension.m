//
//  UIImageView+QSExtension.m
//  TestTouchEvent
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 MGCoin. All rights reserved.
//

#import "UIImageView+QSExtension.h"


#import <objc/runtime.h>

#define kUIImageView_ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kUIImageView_ScreenHeight ([UIScreen mainScreen].bounds.size.height)

/**
 *  UIImageView原来的frame
 */
static CGRect oldframe;

static NSString *imageVKey = @"qs_imageVKey";

@interface UIImageView()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageV;
@end

@implementation UIImageView (QSExtension)


/**
 *  根据屏幕宽度放大图片（图片宽度等于屏幕宽度，图片高度根据原图片的宽高比放大）
 */
- (void)qs_enlargeImageBasedOnScreenWidth
{
    UIImage *image = self.image;
    if (!image) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIImageView_ScreenWidth, kUIImageView_ScreenHeight)];
    oldframe = [self convertRect:self.bounds toView:window];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 111;
    
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qs_reduceImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0,(kUIImageView_ScreenHeight - image.size.height * kUIImageView_ScreenWidth / image.size.width) / 2, kUIImageView_ScreenWidth, image.size.height * kUIImageView_ScreenWidth / image.size.width);
        backgroundView.alpha=1;
        
    } completion:^(BOOL finished) {
    }];
}

/**
 *  缩小图片
 */
- (void)qs_reduceImage:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:111];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
    } completion:^(BOOL finished) {
        backgroundView.alpha = 0;
        [backgroundView removeFromSuperview];
    }];
}

/**
 *  捏合手势缩放图片
 */
- (void)qs_enlargeImageWithGesture
{
    UIImage *image = self.image;
    if (!image) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIImageView_ScreenWidth, kUIImageView_ScreenHeight)];
    oldframe = [self convertRect:self.bounds toView:window];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:oldframe];
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.minimumZoomScale = 0.5;
    scrollV.maximumZoomScale = 10;
    scrollV.delegate = self;
    scrollV.tag = 222;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIImageView_ScreenWidth, image.size.height * kUIImageView_ScreenWidth / image.size.width)];
    self.imageV = imageView;
    imageView.image = image;
    
    [scrollV addSubview:imageView];
    [backgroundView addSubview:scrollV];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qs_pinchGestureReduceImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        scrollV.frame = CGRectMake(0,(kUIImageView_ScreenHeight - image.size.height * kUIImageView_ScreenWidth / image.size.width) / 2, kUIImageView_ScreenWidth, image.size.height * kUIImageView_ScreenWidth / image.size.width);
        
        backgroundView.alpha=1;
        
    } completion:^(BOOL finished) {
    }];
}

/**
 *  手势放大的缩小图片方法
 */
- (void)qs_pinchGestureReduceImage:(UITapGestureRecognizer*)tap
{
    UIView *backgroundView = tap.view;
    
    UIScrollView *scrollView = (UIScrollView*)[tap.view viewWithTag:222];
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.frame = oldframe;
    } completion:^(BOOL finished) {
        backgroundView.alpha = 0;
        [backgroundView removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate
/**
 *  scrollView中用于放大缩小的视图
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageV;
}

/**
 *  scrollView放大缩小
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGRect frame = self.imageV.frame;
    frame.origin.y = (scrollView.frame.size.height - self.imageV.frame.size.height) > 0 ? (scrollView.frame.size.height - self.imageV.frame.size.height) * 0.5 : 0;
    frame.origin.x = (scrollView.frame.size.width - self.imageV.frame.size.width) > 0 ? (scrollView.frame.size.width - self.imageV.frame.size.width) * 0.5 : 0;
    self.imageV.frame = frame;
    
    if (self.imageV.frame.size.height <= kUIImageView_ScreenHeight) {
        CGRect scrframe = scrollView.frame;
        scrframe.size.height = self.imageV.frame.size.height;
        scrframe.origin.y = (kUIImageView_ScreenHeight - self.imageV.frame.size.height) / 2;
        
        scrollView.frame = scrframe;
    } else {
        CGRect scrframe = scrollView.frame;
        scrframe.size.height = kUIImageView_ScreenHeight;
        scrframe.origin.y = 0;
        
        scrollView.frame = scrframe;
    }
    
    scrollView.contentSize = CGSizeMake(self.imageV.frame.size.width, self.imageV.frame.size.height);
}

#pragma mark - setter
- (void)setImageV:(UIImageView *)imageV
{
    objc_setAssociatedObject(self, &imageVKey, imageV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter
- (UIImageView *)imageV
{
    return objc_getAssociatedObject(self, &imageVKey);
}
@end
