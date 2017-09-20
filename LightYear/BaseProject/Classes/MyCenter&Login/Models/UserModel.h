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
@property (nonatomic , copy) NSString * userToken;
@property (nonatomic , copy) NSString * username;
@property (nonatomic , copy) NSString * avatar_url;
//本地数据
@property (nonatomic , strong) UIImage * avatarImg;

@end

@interface UserModel : BaseModel

@property (nonatomic , strong) UserInfo * info;

@end
