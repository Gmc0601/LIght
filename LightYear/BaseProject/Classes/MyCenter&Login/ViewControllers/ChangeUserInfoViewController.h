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

@interface ChangeUserInfoViewController : CCBaseViewController

@property (nonatomic , assign) UserInfoType type;

@end
