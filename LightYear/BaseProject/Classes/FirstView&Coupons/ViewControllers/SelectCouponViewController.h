//
//  SelectCouponViewController.h
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "CouponListModel.h"

@protocol SelectCouponDelegate <NSObject>

- (void)callbackWithSelectCoupon:(CouponInfo *)info;

@end

@interface SelectCouponViewController : CCBaseViewController

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, assign) id<SelectCouponDelegate> delegate;

@end
