//
//  RechargeListModel.h
//  BaseProject
//
//  Created by wmk on 2017/9/29.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol CouponInfo <NSObject>

@end

@protocol RechargeListInfo <NSObject>

@end

@interface CouponInfo : JSONModel

@property (nonatomic, copy)NSString *full_type;
@property (nonatomic, copy)NSString *denomination;
@property (nonatomic, copy)NSString *condition;

@end

@interface RechargeListInfo : JSONModel

@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *free_money;

@end

@interface RechargeListModel : BaseModel

@property (nonatomic, strong) NSArray<RechargeListInfo> *info;

@end
