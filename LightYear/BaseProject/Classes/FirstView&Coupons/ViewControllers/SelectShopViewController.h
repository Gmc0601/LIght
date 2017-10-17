//
//  SelectShopViewController.h
//  BaseProject
//
//  Created by wmk on 2017/9/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@protocol SelectShopDelegate <NSObject>

- (void)callbackWithSelectShop:(NSString *)shopName code:(NSString *)shopCode;

@end

@interface SelectShopViewController : CCBaseViewController

@property (nonatomic, assign) id<SelectShopDelegate> delegate;
@property (nonatomic, strong) CLLocation *currentLocation;

@end
