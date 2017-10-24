//
//  ShopListModel.h
//  BaseProject
//
//  Created by wmk on 2017/9/29.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol ShopListInfo <NSObject>

@end

@interface ShopListInfo: JSONModel

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *shopname;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, assign) double distance;
/* 用户余额；积分 */
@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *barurl;

@end

@interface ShopListModel : BaseModel

@property (nonatomic, strong) NSArray<ShopListInfo> * info;

@end
