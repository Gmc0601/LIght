//
//  BasicView.m
//  picker自定义选择器
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "BasicView.h"
#define KHorizontal 40
#define KVERTICAL 50
#define KRADIUS 30
@interface BasicView()

@property (nonatomic,assign) int speed;
@end
@implementation BasicView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.size.width - KHorizontal - KRADIUS/2, KVERTICAL - KRADIUS/2, KRADIUS, KRADIUS)];
        [circlePath moveToPoint:CGPointMake(self.bounds.size.width - KHorizontal + KRADIUS / 2 - 3, KVERTICAL - 8)];
        [circlePath addLineToPoint:CGPointMake(self.bounds.size.width - KHorizontal - KRADIUS / 2 + 3, KVERTICAL + 10)];
        [circlePath moveToPoint:CGPointMake(self.bounds.size.width - KHorizontal - KRADIUS / 2 + 3, KVERTICAL - 8)];
        [circlePath addLineToPoint:CGPointMake(self.bounds.size.width - KHorizontal + KRADIUS / 2 - 3, KVERTICAL + 10)];
        [circlePath moveToPoint:CGPointMake(self.bounds.size.width - KHorizontal, KVERTICAL + KRADIUS/2)];
        [circlePath addLineToPoint:CGPointMake(self.bounds.size.width - KHorizontal,KVERTICAL + KRADIUS/2 + 100)];
        [circlePath addLineToPoint:CGPointMake(KHorizontal,KVERTICAL + KRADIUS/2 + 100)];

        CAShapeLayer *shapeLayerCircle = [CAShapeLayer layer];
        shapeLayerCircle.frame = CGRectZero;
        shapeLayerCircle.lineWidth = 3.f;
        shapeLayerCircle.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayerCircle.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:shapeLayerCircle];
                shapeLayerCircle.path = circlePath.CGPath;
        [self drawLineAnimation:shapeLayerCircle];
        
        UIView *main = [UIView new];
        main.layer.anchorPoint = CGPointMake(0, 0);
        main.center = CGPointMake(KHorizontal + 1, KVERTICAL + KRADIUS/2 + 100);
        main.bounds = CGRectMake(0, 0, self.bounds.size.width - KHorizontal -KHorizontal + 1,0);
        main.backgroundColor = [UIColor whiteColor];
        main.alpha = 0;
        [self addSubview:main];
        
        /**
         弹性动画,延时1.2秒后执行
         - returns: <#return value description#>
         */
        [self showAniamation:main];
       
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
}

-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
    [self setNeedsDisplay];
    
}

-(void)initUI:(UIView *)view
{
    self.picker = [[UIPickerView alloc]init];
    self.picker.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
    self.picker.bounds = CGRectMake(0, 0, view.bounds.size.width - 10, view.bounds.size.height / 2);
    [view addSubview:self.picker];
}

-(void)showAniamation:(UIView *)main
{
    [UIView animateWithDuration:1 delay:1.2 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        main.bounds = CGRectMake(0, 0, self.bounds.size.width - KHorizontal -KHorizontal + 1, self.bounds.size.width - KHorizontal -KHorizontal);
        main.alpha = 1;
        [self initUI:main];
    } completion:nil];
}


@end
