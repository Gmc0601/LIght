//
//  PurchaseModel.h
//  BaseProject
//
//  Created by LeoGeng on 25/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseModel : NSObject
@property(retain,atomic) NSString *_id;
@property(retain,atomic) NSString *goodsId;
@property(retain,atomic) NSString *shopId;
@property(assign,atomic) CGFloat createDate;
@property(retain,atomic) NSString *userId;
@property(retain,atomic) NSString *name;
@property(retain,atomic) NSString *sku;
@property(retain,atomic) NSArray *img;
@property(retain,atomic) NSString *price;
@property(assign,atomic) int oldPrice;
@property(retain,atomic) NSString *couponid;
@property(assign,atomic) int count;
@property(assign,atomic) int stock;
@property(assign,atomic) int shopStock;
@property(assign,atomic) int centerStock;
@property(retain,atomic) NSString *categoryId;

@end
