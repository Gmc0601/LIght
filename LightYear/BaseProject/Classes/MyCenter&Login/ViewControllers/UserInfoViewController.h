//
//  UserInfoViewController.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef void(^ChangeUserHeadImgBlock)(NSString * headImg);

@interface UserInfoViewController : CCBaseViewController

@property (nonatomic, copy) ChangeUserHeadImgBlock finishBlock;

@end
