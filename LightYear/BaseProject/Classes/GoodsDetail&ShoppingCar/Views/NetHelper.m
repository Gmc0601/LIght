//
//  NetHelper.m
//  BaseProject
//
//  Created by LeoGeng on 21/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "NetHelper.h"
#import "ConfigModel.h"
#import "GoodsCategory.h"
#import "GoodsModel.h"

@implementation NetHelper
+(void) getCategoryListWithId:(NSString *) _id withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (![_id  isEqual: @"0"]) {
        [params setObject:_id forKey:@"id"];
    }
    
    [params setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    
    [HttpRequest postPath:@"_goodstype_by_pid_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSDictionary *infoDic = datadic[@"info"];
            for (NSDictionary *dict in infoDic) {
                GoodsCategory *model = [GoodsCategory new];
                model._id = dict[@"id"];
                model.text = dict[@"name"];
                
                [arr addObject:model];
            }
            
            callback(nil,arr);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

//64
+(void) getGoodsListWithId:(NSString *) _id withShopId:(NSString *)shopId withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (![_id  isEqual: @"0"]) {
        [params setObject:_id forKey:@"goodstype"];
    }
    
    //[params setObject:shopId forKey:@"shopid"];
    [params setObject:@"64" forKey:@"shopid"];
    [params setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    [params setObject:@"10" forKey:@"size"];

    [HttpRequest postPath:@"_goods_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSDictionary *infoDic = datadic[@"info"];
            for (NSDictionary *dict in infoDic) {
                GoodsModel *model = [GoodsModel new];
                model._id = dict[@"id"];
                model.name = dict[@"good_name"];
                model.couponid = dict[@"couponid"] == [NSNull null] ? nil:dict[@"couponid"];
                model.isNew = [dict[@"isnew"]  isEqual: @"1"];
                model.memberPrice = dict[@"user_price"] == [NSNull null] ? nil:dict[@"user_price"];
                model.specilPrice = dict[@"special_price"]  == [NSNull null] ? nil:dict[@"special_price"];
                model.isUser = dict[@"is_user"];
                model.shopId = dict[@"shopid"];
                model.stock = ((NSString *)dict[@"stock"]).intValue;
                model.shopStock = ((NSString *)dict[@"stock"]).intValue;
                model.centerStock = ((NSString *)dict[@"stock"]).intValue;
                [arr addObject:model];
            }
            
            callback(nil,arr);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}
@end
