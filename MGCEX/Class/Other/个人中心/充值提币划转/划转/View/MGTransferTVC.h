//
//  MGTransferTVC.h
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewController.h"

@interface MGTransferTVC : BaseTableViewController
///区分法币和币币:法币转逼逼：uff 币币转法币：ucc
@property (nonatomic, strong) NSString *type;
///默认的币种
@property (nonatomic, strong) NSString *defaultCoinTypeStr;
@end
