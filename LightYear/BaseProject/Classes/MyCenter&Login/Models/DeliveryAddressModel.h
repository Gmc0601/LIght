//
//  DeliveryAddressModel.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol DeliveryAddressInfo <NSObject>

@end

@interface DeliveryAddressInfo : JSONModel

@property (nonatomic , assign) int isdefault;//是否默认 1 默认 2 非默认
@property (nonatomic , copy) NSString * tablet;//门牌号
@property (nonatomic , copy) NSString * address;//收货的具体地址
@property (nonatomic , copy) NSString * phone;//收货人电话
@property (nonatomic , copy) NSString * username;//收货人姓名
@property (nonatomic , copy) NSString * aid;//有id就是修改 没有就是新增
@property (nonatomic , copy) NSString * lng;
@property (nonatomic , copy) NSString * lat;
@property (nonatomic, copy) NSString *id;
@property (nonatomic , copy) NSString * area;
@property (nonatomic , copy) NSString * city;
@property (nonatomic , copy) NSString * code;
@property (nonatomic , copy) NSString * create_time;
@property (nonatomic , copy) NSString * province;
@property (nonatomic , copy) NSString * user_id;

@end

@interface DeliveryAddressModel : BaseModel

@property (nonatomic , strong) NSArray<DeliveryAddressInfo> * info;

@end
