//
//  WMSegmentView.m
//  jajaying
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "WMSegmentView.h"

@interface WMSegmentView () {
    BOOL  setupFinished;
}

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *lines;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation WMSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    if (setupFinished) {
        return;
    }
    
    self.backgroundColor =[UIColor clearColor];
    setupFinished = YES;
}

- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        _items = items;
        [self setButtons];
        [self setBottomLine:self.bottomLine];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex != _currentIndex) {
        _currentIndex = currentIndex;
        for (int i =0; i<[self.buttons count]; i ++) {
            UIButton *btn =(UIButton *)[self.buttons objectAtIndex:i];
            [btn setTitleColor:[self getBtnColorAtIndex:i] forState:UIControlStateNormal];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
//            NSInteger count = [_items count];
//            CGFloat width = self.width / count;
            CGFloat height = self.height;
            
            CGFloat left =0;
            if (currentIndex > 0) {
                UIImageView *l = [self.lines objectAtIndex:currentIndex-1];
                left = l.origin.x;
            }
            self.bottomLine.frame = CGRectMake( left+SizeWidth(8), height-SizeHeigh(4), SizeWidth(75), SizeHeigh(4));
        }];
    }
    
    if ([_delegate respondsToSelector:@selector(segment:didSelectAtIndex:)]) {
        [_delegate segment:self didSelectAtIndex:_currentIndex];
    }
}

- (void)setButtons
{
    NSInteger count = [_items count];
    CGFloat width = self.width / count - 1;
    CGFloat height = self.height;
    NSMutableArray *btnArr = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *lineArr = [NSMutableArray arrayWithCapacity:count-1];
    for (int i = 0; i < [_items count]; i++) {
        NSString *title = [_items objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 0, width, height);
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[self getBtnColorAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = SourceHanSansCNMedium(SizeWidth(14));
        [btnArr addObject:btn];
        [self addSubview:btn];
        
        if (i > 0) {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame = CGRectMake(btn.origin.x, 12, 0.5, 15);
            line.backgroundColor = [UIColor clearColor]; // 竖线无色
            [self addSubview:line];
            [lineArr addObject:line];
        }
    }
    self.buttons = btnArr;
    self.lines = lineArr;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine =[[UIView alloc]init];
        _bottomLine.backgroundColor = UIColorFromHex(0x3e7bb1);
        _bottomLine.userInteractionEnabled =YES;
        
//        NSInteger count = [_items count];
//        CGFloat width = self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height;
        self.bottomLine.frame = CGRectMake( SizeWidth(8), height-SizeHeigh(4), SizeWidth(75), SizeHeigh(4));
        [self bringSubviewToFront:(UIButton *)[self.buttons objectAtIndex:self.currentIndex]];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UIColor *)getBtnColorAtIndex:(NSInteger)index
{
    if (self.currentIndex == index) {
        return UIColorFromHex(0x333333);
    } else {
        return UIColorFromHex(0x333333);
    }
}


#pragma mark - actions

- (void)buttonTapped:(id)sender
{
    NSInteger index = [(UIButton *)sender tag];
    self.currentIndex = index;
}

- (void)setSelectedBtn:(NSInteger)selectedIndex
{
    UIButton *btn = (UIButton *)[self viewWithTag:(selectedIndex)];
    [self buttonTapped:btn];
}

@end
