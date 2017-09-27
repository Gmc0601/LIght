//
//  NetHelper.h
//  BaseProject
//
//  Created by LeoGeng on 21/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

@interface NetHelper : NSObject
+(void) getCategoryListWithId:(NSString *) _id withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback;
+(void) getGoodsListWithId:(NSString *) _id withShopId:(NSString *)shopId withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback;
+(void) getGoodsDetailWithId:(NSString *) _id withShopId:(NSString *)shopId   callBack:(void(^)(NSString *error,NSArray *, NSArray *,GoodsModel *)) callback;
+(void) searchBy:(NSString *) keyWords withShopId:(NSString *)shopId withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback;
+(void) addToFavoriteWithGoodsId:(NSString *) _id withShopId:(NSString *) shopId  callBack:(void(^)(NSString *error,NSString *message)) callback;
+(void) cancelFavoriteWithGoodsId:(NSString *) _id withShopId:(NSString *) shopId  callBack:(void(^)(NSString *error,NSString *message)) callback;
+(void) getFavoriteListWithShopId:(NSString *) shopId withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback;
+(void) getGoodsListFromCard:(void(^)(NSString *error,NSArray *)) callback;
+(void) addGoodsToCardWithGoodsId:(NSString *) goodsId withShopId:(NSString *) shopId withCount:(int) count withId:(NSString *) _id withSKUId:(NSString *) skuId withPrice:(NSString *) price  callBack:(void(^)(NSString *error,NSString *)) callback;
+(void) deleteGoodsFromCardWithId:(NSString *) _id callBack:(void(^)(NSString *error,NSString *info)) callback;
@end
