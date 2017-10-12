//
//  OrderDataHelper.h
//  BaseProject
//
//  Created by cc on 2017/10/9.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "OrderModel.h"


@interface OrderDataHelper : NSObject

//   订单列表
+ (void)orderListWithparameter:(NSDictionary *)dic callBack:(void(^)(BOOL success, NSArray *modelArr))callback;

//   订单详情
+ (void)orderDetailWithParameter:(NSDictionary *)dic callBack:(void(^)(BOOL success, OrderDetailModel *model))callback;

//   用户下单
+ (void)makeOrderWithParameter:(NSDictionary *)dic callBack:(void(^)(BOOL success, NSArray *modelArr))callback;



@end
