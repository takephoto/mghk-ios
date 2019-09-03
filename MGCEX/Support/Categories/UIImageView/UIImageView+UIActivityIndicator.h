//
//  UIImageView+UIActivityIndicator.h
//  31-UIActivityIndicator-for-SDWebImage
//
//  Created by yiliao on 16/9/6.
//  Copyright © 2016年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface UIImageView (UIActivityIndicator)

//只设置菊花
- (void)bch_setImageWithURL:(NSURL *)url
  showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithURL:(NSURL *)url
  showActivityIndicatorView:(BOOL)showActivityIndicator
             indicatorStyle:(UIActivityIndicatorViewStyle)style;

//只菊花+占位图
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
  showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
  showActivityIndicatorView:(BOOL)showActivityIndicator
             indicatorStyle:(UIActivityIndicatorViewStyle)style;

//只菊花+占位图+SDoptions模式选择
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
  showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
  showActivityIndicatorView:(BOOL)showActivityIndicator
             indicatorStyle:(UIActivityIndicatorViewStyle)style;

//只设置菊花+block回掉
- (void)bch_setImageWithURL:(NSURL *)url
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithURL:(NSURL *)url
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator
             indicatorStyle:(UIActivityIndicatorViewStyle)style;


//只菊花+占位图+block
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator
             indicatorStyle:(UIActivityIndicatorViewStyle)style;

//只菊花+占位图+SDoptions模式选择+block
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator
             indicatorStyle:(UIActivityIndicatorViewStyle)style;

//进度
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(SDWebImageCompletionBlock)completedBlock
  showActivityIndicatorView:(BOOL)showActivityIndicator
             indicatorStyle:(UIActivityIndicatorViewStyle)style;

//以上所有集合
- (void)bch_setImageWithPreviousCachedImageWithURL:(NSURL *)url
                                  placeholderImage:(UIImage *)placeholder
                                           options:(SDWebImageOptions)options
                                          progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                         completed:(SDWebImageCompletionBlock)completedBlock
                         showActivityIndicatorView:(BOOL)showActivityIndicator;
- (void)bch_setImageWithPreviousCachedImageWithURL:(NSURL *)url
                                  placeholderImage:(UIImage *)placeholder
                                           options:(SDWebImageOptions)options
                                          progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                         completed:(SDWebImageCompletionBlock)completedBlock
                         showActivityIndicatorView:(BOOL)showActivityIndicator
                                    indicatorStyle:(UIActivityIndicatorViewStyle)style;
@end

