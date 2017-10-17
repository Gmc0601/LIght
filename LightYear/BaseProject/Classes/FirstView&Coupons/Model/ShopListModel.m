//
//  ShopListModel.m
//  BaseProject
//
//  Created by wmk on 2017/9/29.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ShopListModel.h"

@implementation ShopListInfo

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

@implementation ShopListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
