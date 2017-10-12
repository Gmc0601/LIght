//
//  OrderDataHelper.m
//  BaseProject
//
//  Created by cc on 2017/10/9.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderDataHelper.h"

@implementation OrderDataHelper
//   订单列表
+ (void)orderListWithparameter:(NSDictionary *)dic callBack:(void(^)(BOOL success, NSArray *modelArr))callback {
    [HttpRequest postPath:@"_invest_list_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }else {
            callback(NO, nil);
            return ;
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSArray *infoArr = datadic[@"info"];
            NSArray *modelarr = [OrderModel mj_objectArrayWithKeyValuesArray:infoArr];
            callback(YES, modelarr);
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}
//   订单详情
+ (void)orderDetailWithParameter:(NSDictionary *)dic callBack:(void(^)(BOOL success, OrderDetailModel *model))callback {
    
    [HttpRequest postPath:@"_invest_info_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        NSLog(@"????%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *infoArr = datadic[@"info"];
            OrderDetailModel *model = [OrderDetailModel mj_objectWithKeyValues:infoArr];
            callback(YES, model);
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}
//   用户下单 
+ (void)makeOrderWithParameter:(NSDictionary *)dic callBack:(void (^)(BOOL, NSArray *))callback {
    
}

@end
