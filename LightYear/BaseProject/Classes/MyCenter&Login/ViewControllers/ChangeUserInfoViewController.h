//
//  ChangeUserInfoViewController.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef enum : NSUInteger {
    UserInfoTypeName,
    UserInfoTypePayPassword,
} UserInfoType;

typedef void(^ChangeUserNameBlock)(NSString * name);

@interface ChangeUserInfoViewController : CCBaseViewController

@property (nonatomic , assign) UserInfoType type;

@property (nonatomic, copy) ChangeUserNameBlock finishBlock;

@end
