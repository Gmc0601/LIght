//
//  PropertyPickView.h
//  BaseProject
//
//  Created by LeoGeng on 18/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PropertyPickViewDelegate <NSObject>

-(void) didSelectValue:(NSArray *) selectvalue;

@end

@interface PropertyPickView : UIView
-(void) setDatasource:(NSArray *)datasource withSelectValues:(NSArray *) selectValue;
@property(weak,nonatomic) id<PropertyPickViewDelegate> delegate;
@end
