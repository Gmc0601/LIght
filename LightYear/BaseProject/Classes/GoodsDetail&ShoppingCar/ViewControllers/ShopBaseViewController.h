//
//  ShopBaseViewController.h
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "SearchBarView.h"
#import "ConfigModel.h"

@interface ShopBaseViewController : CCBaseViewController
@property(retain,atomic) UIView *bottomView;
@property(retain,atomic) SearchBarView *searchBar;

-(void) addFavoriteButton;
-(BOOL) hasBottomView;
-(void) addSearchButton;
@end
