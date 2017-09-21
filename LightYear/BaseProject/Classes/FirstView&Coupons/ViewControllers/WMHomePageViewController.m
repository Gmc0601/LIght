//
//  WMHomePageViewController.m
//  BaseProject
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "WMHomePageViewController.h"
#import "WMBannerView.h"
#import "WMHomeHeaderView.h"

@interface WMHomePageViewController ()<HomeBannerViewDelegate, HomeHeaderDelegate>

@property (nonatomic, strong) WMHomeHeaderView *headerView;
@property (nonatomic, strong) WMBannerView *bannerView;

@end

@implementation WMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getCurrentTime];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initLeftNavBar];
    [self initRightBar];
    [self addSubview];
}

- (void)addSubview {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bannerView];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    [_bannerView fillWithList:array];
}

- (void)initLeftNavBar {
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(16, 28, 28, 28);
    [btnLeft setImage:[UIImage imageNamed:@"input-field"] forState:UIControlStateNormal];
    [btnLeft setAdjustsImageWhenHighlighted:NO];
    [btnLeft addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBar;
}

- (void)initRightBar {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(16, 28, 28, 28);
    [rightBtn setImage:[UIImage imageNamed:@"icon_yhqlb"] forState:UIControlStateNormal];
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {
    
}

#pragma mark - Service


#pragma mark - HomeBannerViewDelegate
- (void)didSelectBanner:(NSArray *)list {
    
}

#pragma mark - HomeHeaderDelegate
- (void)callbackOtherClick {
    
}

- (void)callbackGoodsClick {
    
}

- (void)callbackMemberClick {
    
}

#pragma mark - lazyLoad
- (WMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[WMBannerView alloc] initWithFrame:CGRectMake(0, SizeHeigh(210), kScreenW, SizeHeigh(365))];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (WMHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WMHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeigh(210))];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - Time
-(NSString * )getCurrentTime{
    //获取当前的时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [comps hour];
    NSString * timeStr;
    if (hour > 5 &&hour < 12) {
        timeStr = @"早上好";
    }else if (hour > 11 &&hour < 18){
        timeStr = @"下午好";
    }else{
        timeStr = @"晚上好";
    }
    return timeStr;
}

@end
