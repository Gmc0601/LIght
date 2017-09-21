//
//  GoodsListView.h
//  BaseProject
//
//  Created by LeoGeng on 14/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsListView;
@protocol GoodsListViewDelegate <NSObject>

-(void) didSelectGoods:(NSString *) goodsId;
-(void) refreshHeader:(GoodsListView *) sender;
-(void) refreshFooter:(GoodsListView *) sender;
@end

@interface GoodsListView : UIView
@property(weak,nullable) id<GoodsListViewDelegate> delegate;
@property(retain,nonatomic) NSString *goodsType;
@property(assign,nonatomic) BOOL isFavorite;
- (instancetype)init:(UIViewController *) owner;
@end
