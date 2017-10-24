//
//  EditDeliveryAddressViewController.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "DeliveryAddressModel.h"

typedef void(^EditDeliveryAddressBlock)(DeliveryAddressInfo * model);

@interface EditDeliveryAddressViewController : CCBaseViewController

@property (nonatomic , strong) DeliveryAddressInfo * addressModel;

@property (nonatomic , copy) EditDeliveryAddressBlock finishBlock;

@end
