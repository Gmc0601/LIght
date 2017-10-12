//
//  FavoriteView.m
//  BaseProject
//
//  Created by LeoGeng on 14/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "FavoriteView.h"
#import "GoodsListView.h"
#import "UIColor+BGHexColor.h"

@interface FavoriteView()
@property(retain,atomic) GoodsListView *rightView;
@end

@implementation FavoriteView
@synthesize datasource = _dataSource;
-(void) setDatasource:(NSMutableArray *)datasource{
    _rightView.datasource = datasource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    return self;
}

-(void) addViews{
    CGFloat width = SizeWidth(639/2);
    CGFloat x = self.bounds.size.width - width;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, SizeHeigh(20), width, SizeHeigh(116/2 -20))];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(14));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor whiteColor];
    lblTitle.text = @"喜爱";
    lblTitle.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    [self addSubview:lblTitle];
    
    _rightView = [[GoodsListView alloc] initWithFrame:CGRectMake(x, SizeHeigh(116/2), width, self.bounds.size.height - SizeHeigh(116/2))];
    _rightView.isFavorite = true;
    _rightView.delegate = self.delegate;
    [self addSubview:_rightView];
}

-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return _rightView;
}

@end
