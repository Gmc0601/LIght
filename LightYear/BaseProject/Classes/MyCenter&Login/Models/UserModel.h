//
//  UserModel.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/19.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol UserInfo <NSObject>

@end

@interface UserInfo : JSONModel

@property (nonatomic , copy) NSString * birthday;
@property (nonatomic , assign) NSInteger expireTime;
@property (nonatomic , assign) NSInteger is_trade;
@property (nonatomic , copy) NSString * nickname;
@property (nonatomic , copy) NSString * realname;
@property (nonatomic , assign) NSInteger sex;
@property (nonatomic , assign) NSInteger userId;
@property (nonatomic , assign) NSInteger userToken;
@property (nonatomic , copy) NSString * username;

@end

@interface UserModel : BaseModel

@property (nonatomic , strong) UserInfo * info;

@end
