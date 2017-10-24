//
//  CouponListModel.m
//  BaseProject
//
//  Created by wmk on 2017/10/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CouponListModel.h"

@implementation CouponInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper*)keyMapper {
    
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"aid",
                                 }];
}

@end

@implementation CouponListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
