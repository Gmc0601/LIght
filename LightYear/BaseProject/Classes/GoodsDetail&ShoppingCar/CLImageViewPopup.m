//
//  CLImageViewPopup.m
//  BaseProject
//
//  Created by LeoGeng on 17/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "CLImageViewPopup.h"

@interface CLImageViewPopup(){
    CGRect tempRect;
    UIView *bgView;
    BOOL animated;
    CGFloat intDuration;
}

@end

@implementation CLImageViewPopup

- (instancetype)init
{
    self = [super init];
    if (self) {
        animated = YES;
        intDuration = 0.25;
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popUpImageToFullScreen)];
        [self addGestureRecognizer:tapGuesture];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void) exitFullScreen{
    UIImageView *imageV = (UIImageView *) bgView.subviews[0];
    [UIView animateWithDuration:intDuration animations:^{
        imageV.frame = tempRect;
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

-(void) popUpImageToFullScreen{
    UIWindow *windown = [UIApplication sharedApplication].keyWindow;
    bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitFullScreen)];
    [bgView addGestureRecognizer:tapGuesture];

    bgView.alpha = 0;
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:self.image];
    CGRect point = [self convertRect:self.bounds toView:self.superview];
    imageV.frame = point;
    tempRect = point;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageV];
    
    [windown addSubview:bgView];
    
    if (animated) {
        [UIView animateWithDuration:intDuration animations:^{
            bgView.alpha = 1;
            
            imageV.frame = CGRectMake(0,0, self.superview.bounds.size.width, self.superview.bounds.size.height);
            imageV.center = self.superview.center;

        }];
    }
}

-(UIViewController *) findParentViewController:(UIView *) view{
    UIResponder *parentResponder = self;
    while (parentResponder != nil) {
        parentResponder = [parentResponder nextResponder];
        if ([parentResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)parentResponder;
        }
    }
    
    return NULL;
}
@end
