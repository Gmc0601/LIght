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
#import "PurchaseCarViewController.h"
#import "MemberCardViewController.h"
#import "SelectShopViewController.h"

@interface WMHomePageViewController ()<HomeBannerViewDelegate, HomeHeaderDelegate, SelectShopDelegate>

@property (nonatomic, strong) WMHomeHeaderView *headerView;
@property (nonatomic, strong) WMBannerView *bannerView;
@property(retain,atomic) UIView *bottomView;

@end

@implementation WMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = [self getCurrentTime];
    [self initLeftNavBar];
    [self initRightBar];
    [self addSubview];
    [self addBottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leftBar removeFromSuperview];
    [self.rightBar removeFromSuperview];
}

- (void)addSubview {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bannerView];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    [_bannerView fillWithList:array];
}

- (void)initLeftNavBar {
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(SizeWidth(16), 28, 28, 28);
    [btnLeft setImage:[UIImage imageNamed:@"input-field"] forState:UIControlStateNormal];
    [btnLeft setAdjustsImageWhenHighlighted:NO];
    [btnLeft addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:btnLeft];
}

- (void)initRightBar {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.navigationView.width-28-SizeWidth(16), 28, 28, 28);
    [rightBtn setImage:[UIImage imageNamed:@"icon_yhqlb"] forState:UIControlStateNormal];
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:rightBtn];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {
    
}

#pragma mark - Service


#pragma mark - SelectShopDelegate
- (void)callbackWithSelectShop:(NSString *)shopName code:(NSString *)shopCode {
    self.headerView.addressLabel.text = shopName;
}

#pragma mark - HomeBannerViewDelegate
- (void)didSelectBanner:(NSArray *)list {
    
}

#pragma mark - HomeHeaderDelegate
- (void)callbackOtherClick {
    SelectShopViewController *selectVC = [[SelectShopViewController alloc] init];
    selectVC.delegate = self;
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)callbackGoodsClick {
    
}

- (void)callbackMemberClick {
    MemberCardViewController *cardVC = [[MemberCardViewController alloc] init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:cardVC animated:YES];
}

#pragma mark - lazyLoad
- (WMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[WMBannerView alloc] initWithFrame:CGRectMake(0, SizeHeigh(210)+64, kScreenW, SizeHeigh(335))];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (WMHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WMHomeHeaderView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, SizeHeigh(210))];
        _headerView.delegate = self;
    }
    return _headerView;
}

-(void) addBottomView{
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#fecd2f"];
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(SizeHeigh(98/2)));
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tab_qdsl"]];
    [self.bottomView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(SizeHeigh(27/2));
        make.left.equalTo(self.bottomView).offset(SizeWidth(38/2));
        make.width.equalTo(@(SizeWidth(57/2)));
        make.height.equalTo(@(SizeHeigh(57/2)));
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNRegular(SizeWidth(15));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"购物清单";
    [self.bottomView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.width.equalTo(@(SizeWidth(200)));
        make.height.equalTo(@(SizeHeigh(15)));
    }];
    
    UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sg_ic_down"]];
    [self.bottomView addSubview:upView];
    
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView).offset(-SizeWidth(32/2));
        make.width.equalTo(@(SizeWidth(28/2)));
        make.height.equalTo(@(SizeHeigh(14/2)));
    }];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPurchaseCarViewController)];
    [self.bottomView addGestureRecognizer:tapGuesture];
}

-(void) showPurchaseCarViewController{
    PurchaseCarViewController *newVC = [PurchaseCarViewController new];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:newVC animated:YES];
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
