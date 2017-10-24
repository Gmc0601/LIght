//
//  CouponListModel.h
//  BaseProject
//
//  Created by wmk on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol CouponInfo <NSObject>

@end

@interface CouponInfo : JSONModel

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *full_type;
@property (nonatomic, copy) NSString *denomination;
@property (nonatomic, copy) NSString *express_time;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *img;

@end

@interface CouponListModel : BaseModel

@property (nonatomic, strong) NSArray<CouponInfo> * info;

@end
