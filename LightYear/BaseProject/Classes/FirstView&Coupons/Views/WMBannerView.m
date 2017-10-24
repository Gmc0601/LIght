//
//  WMBannerView.m
//  jajaying
//
//  Created by Forlan on 16/8/2.
//  Copyright © 2016年 WinsMoney. All rights reserved.
//

#import "WMBannerView.h"
#import "UIImageView+WebCache.h"
#import "homeBannerModel.h"

@interface WMBannerView ()

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) NSTimer *imageScrollTimer;
@property (nonatomic, assign) NSInteger selectedImageIndex;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *scrollDataArray;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation WMBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bannerArray = [NSMutableArray array];
        _scrollDataArray = [NSMutableArray array];
        _selectedImageIndex = -1;
        
        [self addSubview:self.imageScrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (UIScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( (self.width-SizeWidth(345))/2, 0, SizeWidth(345), SizeWidth(310))];
        _imageScrollView.backgroundColor = [UIColor clearColor];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.directionalLockEnabled = YES;
        _imageScrollView.alwaysBounceVertical = NO;
        _imageScrollView.alwaysBounceHorizontal = YES;
        _imageScrollView.delegate = self;
    }
    return _imageScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _imageScrollView.height+SizeHeigh(10), _imageScrollView.width, SizeWidth(12))];
        _pageControl.centerX = self.centerX;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = UIColorFromHex(0x333333);
        _pageControl.currentPageIndicatorTintColor = UIColorFromHex(0x4d333333);
        _pageControl.numberOfPages = 1;
    }
    return _pageControl;
}

- (void)fillWithList:(NSMutableArray *)dataArray{
    if (dataArray.count != 0) {
        [self invalidTimer];
        _selectedImageIndex = 0;
        _imageScrollView.scrollEnabled = YES;
        [_bannerArray removeAllObjects];
        for (bannerInfo *info in dataArray) {
            [_bannerArray addObject:info];
        }
        [self refreshScrollView];
        
        _pageControl.numberOfPages = [_bannerArray count];
        if (_bannerArray.count == 0) {
            _pageControl.hidden = YES;
        } else {
            _pageControl.hidden = NO;
        }
        _pageControl.currentPage = _selectedImageIndex;
        [self startTimer];
    }
    else {
//        [self invalidTimer];
        _selectedImageIndex = 0;
        _pageControl.hidden = YES;
        _pageControl.currentPage = _selectedImageIndex;
//        [self startTimer];

        _imageScrollView.frame = CGRectMake( (kScreenW-SizeWidth(345))/2.0, 0, SizeWidth(345), SizeHeigh(310));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(345), 0, _imageScrollView.width, _imageScrollView.height)];
        imageView.contentMode = UIViewContentModeCenter;
        [imageView setImage:[UIImage imageNamed:@"icon_sy_hdqx"]];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.userInteractionEnabled = NO;
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, SizeWidth(200), SizeHeigh(20))];
        _promptLabel.center = CGPointMake( imageView.width/2, imageView.height/2+SizeHeigh(56));
        _promptLabel.text = @"暂无活动";
        _promptLabel.font = SourceHanSansCNRegular(SizeWidth(13));
        _promptLabel.textColor = UIColorFromHex(0xcccccc);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:_promptLabel];
        [_imageScrollView addSubview:imageView];
        [_imageScrollView setContentOffset:CGPointMake(SizeWidth(345), 0)];
        _imageScrollView.scrollEnabled = NO;
    }
}

- (void)refreshScrollView {
    
    NSArray *temp = [_imageScrollView subviews];
    [temp makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    if (_bannerArray.count != 0) {
        //scroll只加载3个图片
        [_scrollDataArray removeAllObjects];
        [_scrollDataArray addObject:[_bannerArray objectAtIndex:[self getPrePage]]];
        [_scrollDataArray addObject:[_bannerArray objectAtIndex:_selectedImageIndex]];
        [_scrollDataArray addObject:[_bannerArray objectAtIndex:[self getNextPage]]];
        
        _imageScrollView.contentSize = CGSizeMake(SizeWidth(345) * _scrollDataArray.count, self.height);
        for (int i = 0; i < _scrollDataArray.count; i++) {
            bannerInfo *info = _scrollDataArray[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(345) * i, 0, _imageScrollView.width, _imageScrollView.height)];
            //        imageView.contentMode = UIViewContentModeCenter;
            [imageView sd_setImageWithURL:[NSURL URLWithString:info.img_url]];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            
            [_imageScrollView addSubview:imageView];
        }
        [_imageScrollView setContentOffset:CGPointMake(SizeWidth(345), 0)];
    }
}

- (NSInteger)getPrePage {
    int result = 0;
    if (_selectedImageIndex == 0) {
        result = (int)[_bannerArray count] - 1;
    }
    else {
        result = (int)_selectedImageIndex - 1;
    }
    return result;
}

- (NSInteger)getNextPage {
    int result = 0;
    if ((_selectedImageIndex + 1) >= [_bannerArray count]) {
        result = 0;
    }
    else {
        result = (int)_selectedImageIndex + 1;
    }
    return result;
}

- (void)changeImage {
    _selectedImageIndex++;
    if (_bannerArray.count != 0) {
        _selectedImageIndex = _selectedImageIndex % [_bannerArray count];
    }
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    
    [_imageScrollView.layer addAnimation:animation forKey:nil];
    
    [self refreshScrollView];
    
    self.pageControl.currentPage = _selectedImageIndex;
}

- (void)startTimer {
    if (_isNoneedAutoScroll) {
        return;
    }
    _imageScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_imageScrollTimer forMode:NSRunLoopCommonModes];
}

- (void)invalidTimer {
    [_imageScrollTimer invalidate];
    _imageScrollTimer = nil;
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(didSelectBanner:)]) {
        [_delegate didSelectBanner:[_bannerArray objectAtIndex:_selectedImageIndex]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int xOffset = scrollView.contentOffset.x;
    if ((xOffset % (int)SizeWidth(345) == 0)) {
        self.pageControl.currentPage = _selectedImageIndex;
    }
    
    // 水平滚动
    // 往下翻一张
    if(xOffset >= (2 * SizeWidth(345))) {
        //向右
        _selectedImageIndex++;
        _selectedImageIndex = _selectedImageIndex % _bannerArray.count;
        [self refreshScrollView];
    }
    if(xOffset <= 0) {
        //向左
        if (_selectedImageIndex == 0) {
            _selectedImageIndex = _bannerArray.count - 1;
        }
        else {
            _selectedImageIndex--;
        }
        [self refreshScrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [_imageScrollView setContentOffset:CGPointMake(SizeWidth(345), 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

@end
