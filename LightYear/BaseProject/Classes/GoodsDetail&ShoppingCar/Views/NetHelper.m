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
#import "SKU.h"
#import "SKUPrice.h"

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
            NSDictionary *infoDic = datadic[@"info"];
            NSArray *arr = [self jsonToGoodsModelList:infoDic];
            
            callback(nil,arr);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

+(void) searchBy:(NSString *) keyWords withShopId:(NSString *)shopId withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (![keyWords  isEqual: @"0"]) {
        [params setObject:keyWords forKey:@"key"];
    }
    
    //[params setObject:shopId forKey:@"shopid"];
    [params setObject:@"64" forKey:@"shopid"];
    [params setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    [params setObject:@"10" forKey:@"size"];
    
    [HttpRequest postPath:@"_search_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *infoDic = datadic[@"info"];
            NSArray *arr = [self jsonToGoodsModelList:infoDic];
            
            callback(nil,arr);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

+(void) getGoodsDetailWithId:(NSString *) _id withShopId:(NSString *)shopId   callBack:(void(^)(NSString *error,NSArray *, NSArray *,GoodsModel *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (![_id  isEqual: @"0"]) {
        [params setObject:_id forKey:@"id"];
    }
    
    //[params setObject:shopId forKey:@"shopid"];
    [params setObject:@"64" forKey:@"shopid"];
    
    [HttpRequest postPath:@"_goods_info_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *infoDic = datadic[@"info"];
            NSDictionary *categorylist = infoDic[@"categorylist"];
            NSDictionary *pricelist = infoDic[@"pricelist"];
            NSDictionary *goodinfo = infoDic[@"goodinfo"];
            NSMutableArray *skuList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *skuPriceList = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dict in categorylist) {
                SKU *sku = [SKU new];
                sku._id = dict[@"id"];
                sku.name = dict[@"name"];
                sku.value = dict[@"value"];
                
                [skuList addObject:sku];
            }
            
            for (NSDictionary *dict in pricelist) {
                SKUPrice *model = [SKUPrice new];
                model._id = dict[@"id"];
                model.memberPrice = dict[@"user_price"] == [NSNull null] ? nil:dict[@"user_price"];
                model.specilPrice = dict[@"special_price"]  == [NSNull null] ? nil:dict[@"special_price"];
                model.price = dict[@"price"]  == [NSNull null] ? nil:dict[@"price"];
                model.isUser = dict[@"is_user"];
                model.shopId = dict[@"shopid"];
                model.stock = ((NSString *)dict[@"stock"]).intValue;
                //                model.shopStock = ((NSString *)dict[@"stock"]).intValue;
                //                model.centerStock = ((NSString *)dict[@"stock"]).intValue;
                [skuPriceList addObject:model];
            }
            
            
            GoodsModel *model = [GoodsModel new];
            model._id = goodinfo[@"id"];
            model.name = goodinfo[@"good_name"];
            model.couponid = goodinfo[@"couponid"] == [NSNull null] ? nil:goodinfo[@"couponid"];
            model.isNew = [goodinfo[@"isnew"]  isEqual: @"1"];
            model.memberPrice = goodinfo[@"user_price"] == [NSNull null] ? nil:goodinfo[@"user_price"];
            model.specilPrice = goodinfo[@"special_price"]  == [NSNull null] ? nil:goodinfo[@"special_price"];
            model.price = goodinfo[@"price"]  == [NSNull null] ? nil:goodinfo[@"price"];
            model.isUser = goodinfo[@"is_user"];
            model.shopId = goodinfo[@"shopid"];
            model.stock = ((NSString *)goodinfo[@"stock"]).intValue;
            model.shopStock = ((NSString *)goodinfo[@"w_stock"]).intValue;
            model.centerStock = ((NSString *)goodinfo[@"s_stock"]).intValue;
            model.img = goodinfo[@"img_path"];
            model.desc = goodinfo[@"img_desc"];
            model.info = goodinfo[@"info_desc"];
            
            callback(nil,skuList,skuPriceList,model);
        }else{
            callback(datadic[@"info"],nil,nil,nil);
        }
    }];
}

+(NSArray *)jsonToGoodsModelList:(NSDictionary *) infoDic{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in infoDic) {
        if (dict[@"special_price"]  == [NSNull null] && dict[@"user_price"]  == [NSNull null] &&
            dict[@"price"]  == [NSNull null]) {
            continue ;
        }
        
        GoodsModel *model = [GoodsModel new];
        model._id = dict[@"id"];
        model.name = dict[@"good_name"];
        model.couponid = dict[@"couponid"] == [NSNull null] ? nil:dict[@"couponid"];
        model.isNew = [dict[@"isnew"]  isEqual: @"1"];
        model.memberPrice = dict[@"user_price"] == [NSNull null] ? nil:dict[@"user_price"];
        model.specilPrice = dict[@"special_price"]  == [NSNull null] ? nil:dict[@"special_price"];
        model.price = dict[@"price"]  == [NSNull null] ? nil:dict[@"price"];
        model.isUser = dict[@"is_user"];
        model.shopId = dict[@"shopid"];
        model.stock = ((NSString *)dict[@"stock"]).intValue;
        model.shopStock = ((NSString *)dict[@"s_stock"]).intValue;
        model.centerStock = ((NSString *)dict[@"w_stock"]).intValue;
        model.img = dict[@"img_path"];
        [arr addObject:model];
    }
    
    return  arr;
}

+(void) addToFavoriteWithGoodsId:(NSString *) _id withShopId:(NSString *) shopId  callBack:(void(^)(NSString *error,NSString *message)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (![_id  isEqual: @"0"]) {
        [params setObject:_id forKey:@"good_id"];
    }
    
    if (![shopId  isEqual: @"0"]) {
        [params setObject:shopId forKey:@"shopid"];
    }
    
    [HttpRequest postPath:@"_follow_add_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            callback(nil,datadic[@"info"]);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

+(void) cancelFavoriteWithGoodsId:(NSString *) _id withShopId:(NSString *) shopId  callBack:(void(^)(NSString *error,NSString *message)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (![_id  isEqual: @"0"]) {
        [params setObject:_id forKey:@"good_id"];
    }
    
    if (![shopId  isEqual: @"0"]) {
        [params setObject:shopId forKey:@"shopid"];
    }
    
    [HttpRequest postPath:@"_follow_cancel_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            callback(nil,datadic[@"info"]);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

@end
