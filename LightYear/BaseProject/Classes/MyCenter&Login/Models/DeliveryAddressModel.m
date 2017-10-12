//
//  DeliveryAddressModel.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "DeliveryAddressModel.h"



@implementation DeliveryAddressInfo

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

@implementation DeliveryAddressModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
