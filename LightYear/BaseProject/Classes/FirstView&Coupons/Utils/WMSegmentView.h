//
//  WMSegmentView.h
//  jajaying
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMSegmentView;

@protocol WMSegmentViewDelegate <NSObject>

- (void)segment:(WMSegmentView *)segment didSelectAtIndex:(NSInteger)index;

@end

@interface WMSegmentView : UIView

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) id<WMSegmentViewDelegate> delegate;

- (void)setSelectedBtn:(NSInteger)selectedIndex;

@end
