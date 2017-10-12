//
//  ChoiceDeliveryAddressViewController.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef void(^ChoiceDeliveryAddressBlock)(AMapPOI * point);

@interface ChoiceDeliveryAddressViewController : CCBaseViewController

@property (nonatomic, copy) ChoiceDeliveryAddressBlock finishBlock;

@end
