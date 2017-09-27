//
//  BaseModel.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/19.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@interface BaseModel : JSONModel
@property (nonatomic ,assign) NSInteger error;
@property (nonatomic ,copy) NSString<Optional> * message;
@end
