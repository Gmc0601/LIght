//
//  CouponViewController.h
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CouponViewController : CCBaseViewController

@property (nonatomic, copy) void(^couponBlock)(NSString *id, NSString *cutmoney);

@property (nonatomic, copy) NSString *amout;

@end
