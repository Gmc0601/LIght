//
//  DeliveryAddressViewController.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "DeliveryAddressModel.h"

@interface DeliveryAddressViewController : CCBaseViewController

@property (nonatomic, copy) void(^addressBlock)(DeliveryAddressInfo *model);

@property (nonatomic, assign) BOOL getback;

@end
