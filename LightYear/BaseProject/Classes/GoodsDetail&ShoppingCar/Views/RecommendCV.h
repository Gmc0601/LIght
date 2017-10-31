//
//  RecommendCV.h
//  BaseProject
//
//  Created by LeoGeng on 13/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCV : UIView
@property(retain,atomic) UIViewController *owner;
-(void) setDataSource:(NSArray *) dataSource;
@end
