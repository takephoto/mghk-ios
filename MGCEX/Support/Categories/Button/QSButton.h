//
//  QSButton.h
//  ZengLongSeSha
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 Song. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QSButtonImageStyle){
    QSButtonImageStyleTop,    // image在上面 label在下
    QSButtonImageStyleBottom, // image在下面 label在上
    QSButtonImageStyleRight,   // image在右边 label在左边
    QSButtonImageStyleLeft //  image在左边 label在右边
};

@interface QSButton : UIButton
/** image和label之间的间距 */
@property (nonatomic, assign) CGFloat space;
/** image和label排布的样式 */
@property (nonatomic, assign) QSButtonImageStyle style;
@end
