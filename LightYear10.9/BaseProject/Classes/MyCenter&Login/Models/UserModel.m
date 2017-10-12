//
//  UserModel.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/19.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UserModel.h"

@implementation UserInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

//+ (JSONKeyMapper*)keyMapper {
//    
//    return [[JSONKeyMapper alloc]
//            initWithDictionary:@{
//                                 @"id": @"pid",
//                                 @"description": @"sectionDescription",
//                                 }];
//}

@end

@implementation UserModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
