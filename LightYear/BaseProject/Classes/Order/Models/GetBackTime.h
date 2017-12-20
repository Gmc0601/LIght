//
//  GetBackTime.h
//  BaseProject
//
//  Created by cc on 2017/11/16.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
@interface GetBackTime : NSObject

@property (nonatomic, copy) NSString *timeStr, *str0, *str1;

@property (nonatomic, retain) NSMutableArray *dataArr, *arr0, *arr1, *arr2;

- (NSString *)update:(OrderDetailModel *)model ;
@end
