//
//  integralListModel.h
//  BaseProject
//
//  Created by wmk on 2017/10/19.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol integralListInfo <NSObject>

@end

@interface integralListInfo : JSONModel

@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *create_time;

@end

@interface integralListModel : BaseModel

@property (nonatomic, strong) NSArray<integralListInfo> * info;

@end
