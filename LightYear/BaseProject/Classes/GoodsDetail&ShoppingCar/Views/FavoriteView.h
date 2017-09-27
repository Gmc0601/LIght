//
//  FavoriteView.h
//  BaseProject
//
//  Created by LeoGeng on 14/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListView.h"

@interface FavoriteView : UIView
@property(weak,nullable) id<GoodsListViewDelegate> delegate;
@property(strong,nonatomic) NSMutableArray *datasource;

@end
