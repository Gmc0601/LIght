//
//  WMBannerView.h
//  jajaying
//
//  Created by Forlan on 16/8/2.
//  Copyright © 2016年 WinsMoney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeBannerViewDelegate <NSObject>

- (void)didSelectBanner:(NSArray *)list;

@end

@interface WMBannerView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<HomeBannerViewDelegate> delegate;
@property (nonatomic, assign) BOOL isNoneedAutoScroll;

- (void)fillWithList:(NSMutableArray *)dataArray;

@end
