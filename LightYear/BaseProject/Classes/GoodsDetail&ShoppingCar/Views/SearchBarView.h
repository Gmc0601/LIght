//
//  SearchBarView.h
//  BaseProject
//
//  Created by LeoGeng on 15/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchBarViewDelegate <NSObject>

-(void) didSearch:(NSString *) keyworkd;

@end

@interface SearchBarView : UIView
@property(assign,nonatomic)  BOOL enable;
@property(weak,nullable)  id<SearchBarViewDelegate> delegate;
@end
