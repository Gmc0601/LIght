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
#import "PurchaseModel.h"

@implementation NetHelper
+(void) getCategoryListWithId:(NSString *) _id  withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (![_id  isEqual: @"0"]) {
        [params setObject:_id forKey:@"id"];
    }
    NSString *shopId = [[TMCache sharedCache] objectForKey:kShopInfo];
    if (shopId == nil) {
        callback(@"请选择门店",nil);
        return;
    }
    [params setObject:shopId forKey:@"shopid"];

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
    
    [params setObject:shopId forKey:@"shopid"];
//    [params setObject:@"64" forKey:@"shopid"];
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
    
    [params setObject:shopId forKey:@"shopid"];
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
    
    [params setObject:shopId forKey:@"shopid"];
    
    [HttpRequest postPath:@"_goods_info_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        NSLog(@"goodsinfo%@",responseObject );
        
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
                NSMutableArray *skuList = [NSMutableArray arrayWithCapacity:0];
                for(NSString *value in dict[@"category_id"]){
                    [skuList addObject:value];
                }
                model.skuIdList = skuList;
                
                model._id = dict[@"id"];
                model.memberPrice = dict[@"user_price"] == [NSNull null] ? @"0.0":[self getPrice:dict[@"user_price"]];
                model.specilPrice = dict[@"special_price"]  == [NSNull null]? @"0.0" : [self getPrice:dict[@"special_price"]];
                model.price = dict[@"price"]  == [NSNull null] ? @"0.0":[self getPrice:dict[@"price"]];
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
            model.memberPrice = goodinfo[@"user_price"] == [NSNull null] ?  @"0.0":[self getPrice:goodinfo[@"user_price"]];
            model.specilPrice = goodinfo[@"special_price"]  == [NSNull null] ?  @"0.0":[self getPrice:goodinfo[@"special_price"]];
            model.price = goodinfo[@"price"]  == [NSNull null] ? @"0.0":[self getPrice:goodinfo[@"price"]];
            model.isUser = [goodinfo[@"is_user"]  isEqual: @"1"];
            model.shopId = goodinfo[@"shopid"];
            model.stock = ((NSString *)goodinfo[@"stock"]).intValue;
            model.shopStock = ((NSString *)goodinfo[@"s_stock"]).intValue;
            model.centerStock = ((NSString *)goodinfo[@"w_stock"]).intValue;
            model.img = goodinfo[@"img_path"];
            model.desc = goodinfo[@"img_desc"] == [NSNull null] ? @"":goodinfo[@"img_desc"];
            model.info = goodinfo[@"info_desc"] == [NSNull null] ? @"":goodinfo[@"info_desc"];
            model.isFollow = [goodinfo[@"isfollow"]  isEqual: @"1"];
            model.discountMessage = goodinfo[@"couponinfo"] == [NSNull null] ? @"":goodinfo[@"couponinfo"];
            callback(nil,skuList,skuPriceList,model);
        }else{
            callback(datadic[@"info"],nil,nil,nil);
        }
    }];
}

+(NSArray *)jsonToGoodsModelList:(NSDictionary *) infoDic{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in infoDic) {
        if ((dict[@"special_price"]  == [NSNull null] && dict[@"user_price"]  == [NSNull null] &&
            dict[@"price"]  == [NSNull null]) || dict[@"id"]  == [NSNull null]) {
            continue ;
        }
        
        GoodsModel *model = [GoodsModel new];
        model._id = dict[@"id"];
        model.name = dict[@"good_name"];
        model.couponid = dict[@"couponid"] == [NSNull null] ? nil:dict[@"couponid"];
        model.isNew = [dict[@"isnew"]  isEqual: @"1"];
        model.memberPrice = dict[@"user_price"] == [NSNull null] ?  @"0.0":[self getPrice:dict[@"user_price"]];
        model.specilPrice = dict[@"special_price"]  == [NSNull null] ?  @"0.0":[self getPrice:dict[@"special_price"]];
        model.price = dict[@"price"]  == [NSNull null] ? @"0.0":[self getPrice:dict[@"price"]];
        model.isUser = ![dict[@"is_user"]  isEqual: @"0"];
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

+(void) getFavoriteListWithShopId:(NSString *) shopId withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    [params setObject:[NSString stringWithFormat:@"%@",shopId] forKey:@"shopid"];
    [params setObject:@"10" forKey:@"size"];
    
    [HttpRequest postPath:@"_follow_list_001" params:params resultBlock:^(id responseObject, NSError *error) {
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

+(void) getGoodsListFromCard:(void(^)(NSString *error,NSArray *)) callback{
    
    [HttpRequest postPath:@"_card_list_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        
        if ([datadic[@"error"] intValue] == 0) {
            
            for (NSDictionary *infoDic in datadic[@"info"]) {
                PurchaseModel *model = [PurchaseModel new];
                model._id = infoDic[@"id"];
                model.name = infoDic[@"title"];
                model.couponid = infoDic[@"couponid"] == [NSNull null] ? nil:infoDic[@"couponid"];
                model.price = infoDic[@"price"]  == [NSNull null] ? @"0.0":[self getPrice:infoDic[@"price"]];
                model.shopId = infoDic[@"shopid"];
                model.stock = ((NSString *)infoDic[@"stock"]).intValue;
                model.shopStock = ((NSString *)infoDic[@"s_stock"]).intValue;
                model.centerStock = ((NSString *)infoDic[@"w_stock"]).intValue;
                model.img = infoDic[@"img_path"];
                model.goodsId = infoDic[@"good_id"];
                model.count = ((NSString *)infoDic[@"count"]).intValue;
                model.createDate = ((NSString *)infoDic[@"create_time"]).floatValue;
                model.sku = infoDic[@"sku"];
                model.userId = infoDic[@"user_id"];
                model.categoryId = infoDic[@"sku_id"];
                if (infoDic[@"old_price"] != [NSNull null]) {
                    model.oldPrice = ((NSString *)infoDic[@"old_price"]).intValue;
                }else{
                    model.oldPrice = model.price.intValue;
                }
                [arr addObject:model];
            }
            callback(nil,arr);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

+(void) addGoodsToCardWithGoodsId:(NSString *) goodsId withShopId:(NSString *) shopId withCount:(int) count withId:(NSString *) _id withSKUId:(NSString *) skuId withPrice:(NSString *) price callBack:(void(^)(NSString *error,NSString *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (_id != nil) {
        [params setObject:_id forKey:@"id"];
    }
    
    [params setObject:goodsId forKey:@"good_id"];
    [params setObject:shopId forKey:@"shopid"];
    if (skuId !=nil) {
        [params setObject:skuId forKey:@"sku_id"];
    }
    
    [params setObject:price forKey:@"price"];
    [params setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    
    
    [HttpRequest postPath:@"_set_crad_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            callback(nil,nil);
        }else{
            callback(datadic[@"message"],nil);
        }
    }];
}

+(void) deleteGoodsFromCardWithId:(NSString *) _id callBack:(void(^)(NSString *error,NSString *info)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (_id != nil) {
        [params setObject:_id forKey:@"id"];
    }
    
    [HttpRequest postPath:@"_delete_crad_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            callback(nil,datadic[@"info"]);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

+(void) getCountOfGoodsInCar:(void(^)(NSString *error,NSString *info)) callback{
    
    [HttpRequest postPath:@"_card_count_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            callback(nil,datadic[@"info"]);
        }else{
            callback(datadic[@"info"],nil);
        }
    }];
}

+(void) addOrder:(NSString *) shopId withAmount:(NSString *) amount callBack:(void(^)(NSString *error,NSString *info)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:shopId forKey:@"shopid"];
    [params setObject:amount forKey:@"amount"];
    
    [HttpRequest postPath:@"_order_001" params:params resultBlock:^(id responseObject, NSError *error) {
        NSLog(@".....%@", responseObject);
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"error"] intValue] == 0) {
            callback(nil,datadic[@"info"][@"id"]);
        }else{
            callback(datadic[@"message"],nil);
        }
    }];
}

+(void) recommendList:(NSString *) shopId withGoodsId:(NSString *) goodsId  callBack:(void(^)(NSString *error,NSArray *)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:goodsId forKey:@"goods_id"];
    [params setObject:shopId forKey:@"shopid"];

    
    [HttpRequest postPath:@"_guess_like_001" params:params resultBlock:^(id responseObject, NSError *error) {
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

+(NSString *) getPrice:(NSString *) price{
    return [NSString stringWithFormat:@"%.1f",price.floatValue];
}
@end
