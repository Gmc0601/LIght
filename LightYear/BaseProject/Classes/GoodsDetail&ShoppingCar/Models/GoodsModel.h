//
//  GoodsModel.h
//  BaseProject
//
//  Created by LeoGeng on 09/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
@property(retain,atomic) NSString *_id;
@property(retain,atomic) NSString *name;
@property(retain,atomic) NSString *img;
@property(retain,atomic) NSString *price;
@property(retain,atomic) NSString *memberPrice;
@property(assign,atomic) BOOL canDelivery;
@property(assign,atomic) BOOL canTakeBySelf;
@property(assign,atomic) BOOL hasDiscounts;
@property(assign,atomic) BOOL isNew;
@property(assign,atomic) BOOL outOfStack;
@property(assign,atomic) int count;
@property(retain,atomic) NSString *discountMessage;
@end
