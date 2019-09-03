//
//  MGTransferAccountCell.h
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MGTransferAccountCell : BaseTableViewCell
///区分法币和币币:法币转逼逼：uff 币币转法币：ucc
@property (nonatomic, strong) NSString *type;
@end
