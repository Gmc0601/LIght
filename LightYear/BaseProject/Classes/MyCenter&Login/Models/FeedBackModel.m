//
//  FeedBackModel.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FeedBackModel.h"

@implementation FeedBackInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper*)keyMapper {

    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"fid"
                                 }];
}

@end

@implementation FeedBackModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
