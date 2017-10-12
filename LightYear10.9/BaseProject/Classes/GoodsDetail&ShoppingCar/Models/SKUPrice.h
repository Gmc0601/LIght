//
//  SKUPrice.h
//  BaseProject
//
//  Created by LeoGeng on 23/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKUPrice : NSObject
@property(retain,atomic) NSString *_id;
@property(retain,atomic) NSString *price;
@property(retain,atomic) NSString *specilPrice;
@property(retain,atomic) NSString *memberPrice;
@property(assign,nonatomic) BOOL canDelivery;
@property(assign,nonatomic) BOOL canTakeBySelf;
@property(assign,nonatomic) BOOL hasDiscounts;
@property(assign,atomic) BOOL isUser;
@property(assign,atomic) BOOL outOfStack;
@property(assign,atomic) int count;
@property(retain,atomic) NSString *shopId;
@property(assign,atomic) int stock;
@property(assign,atomic) int shopStock;
@property(assign,atomic) int centerStock;
@property(retain,atomic) NSArray *skuIdList;
@end
