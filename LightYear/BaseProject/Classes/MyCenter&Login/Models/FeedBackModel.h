//
//  FeedBackModel.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol FeedBackInfo <NSObject>

@end

@interface FeedBackInfo : JSONModel

@property (nonatomic , copy) NSString * fid;//": "3",
@property (nonatomic , copy) NSString * user_id;//": "60",
@property (nonatomic , copy) NSString * mobile;//": "17092558802",
@property (nonatomic , copy) NSString * content;//": "用户返馈信息",
@property (nonatomic , copy) NSString * admin_id;//": "0",
@property (nonatomic , copy) NSString * admin_name;//": "0",
@property (nonatomic , copy) NSString * note;//": null,
@property (nonatomic , copy) NSString * create_time;//": "1448875275",
@property (nonatomic , copy) NSString * update_time;//": "1448875275",
@property (nonatomic , copy) NSString * status_text;//": "未处理"
@property (nonatomic , copy) NSString * contact_info;//官方回复

@property (nonatomic , assign) NSInteger status;//": "2",

@property (nonatomic , assign) BOOL isLookMore;

@end

@interface FeedBackModel : BaseModel

@property (nonatomic , strong) NSArray<FeedBackInfo> * info;

@end
