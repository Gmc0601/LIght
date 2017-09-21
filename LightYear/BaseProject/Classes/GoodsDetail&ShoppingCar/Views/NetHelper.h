//
//  NetHelper.h
//  BaseProject
//
//  Created by LeoGeng on 21/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetHelper : NSObject
+(void) getCategoryListWithId:(NSString *) _id withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback;
+(void) getGoodsListWithId:(NSString *) _id withShopId:(NSString *)shopId withPage:(int) pageIndex  callBack:(void(^)(NSString *error,NSArray *)) callback;
@end
