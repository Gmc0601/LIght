//
//  RechargeListModel.h
//  BaseProject
//
//  Created by wmk on 2017/9/29.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"
#import "CouponListModel.h"

@protocol RechargeListInfo <NSObject>

@end

@interface RechargeListInfo : JSONModel

@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *free_money;
@property (nonatomic, strong) CouponInfo *couponInfo;

@end

@interface RechargeListModel : BaseModel

@property (nonatomic, strong) NSArray<RechargeListInfo> *info;

@end
