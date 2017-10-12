//
//  WMTableView.m
//  BaseProject
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "WMTableView.h"

@implementation WMTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}
@end
