//
//  sku.h
//  BaseProject
//
//  Created by LeoGeng on 23/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKU : NSObject
@property(retain,atomic) NSString *_id;
@property(retain,atomic) NSString *name;
@property(retain,atomic) NSString *value;

@end
