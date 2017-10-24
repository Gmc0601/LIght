//
//  tradeListModel.h
//  BaseProject
//
//  Created by wmk on 2017/10/19.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol tradeListInfo <NSObject>

@end

@interface tradeListInfo : JSONModel

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *otype;
@property (nonatomic, copy) NSString *create_date;

@end

@interface tradeListModel : BaseModel

@property (nonatomic, strong) NSArray<tradeListInfo> * info;

@end
