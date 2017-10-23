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
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ShopListModel.h"
#import "homeBannerModel.h"
#import "InspectCouponViewController.h"
#import "MycenterViewController.h"
#import "FirstLevelGoodsViewController.h"

@interface WMHomePageViewController ()<HomeBannerViewDelegate, HomeHeaderDelegate, SelectShopDelegate>{
    //定位
    AMapLocationManager * _locationManager;
    //当前地理位置
    CLLocation *_currentLocation;
}

@property (nonatomic, strong) WMHomeHeaderView *headerView;
@property (nonatomic, strong) WMBannerView *bannerView;
@property (nonatomic, strong) ShopListInfo *info;
@property (nonatomic, strong) NSMutableArray *bannerArray;
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
    [self getLocationData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leftBar removeFromSuperview];
    [self.rightBar removeFromSuperview];
    _bannerArray = [NSMutableArray array];
}

- (void)getLocationData{
    _locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    _locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    _locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        _currentLocation = location;
        [self syncWithShopListRequest];
    }];
}

- (void)addSubview {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bannerView];
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

    [self.navigationController pushViewController:[MycenterViewController new] animated:YES];
}

- (void)rightBtnClick {
    InspectCouponViewController *expireVC = [[InspectCouponViewController alloc] init];
    [self.navigationController pushViewController:expireVC animated:YES];
}

#pragma mark - Service
#pragma mark - Service
- (void)syncWithShopListRequest {
    [ConfigModel showHud:self];
    NSDictionary *dic = @{
//                          @"lng": [NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude],
//                          @"lat": [NSString stringWithFormat:@"%f",_currentLocation.coordinate.latitude],
                          @"lng": @"112.587329",
                          @"lat": @"26.885513",
                          };
    [HttpRequest postPath:homeShopURL params:dic resultBlock:^(id responseObject, NSError *error) {
        
        ShopListModel *model = [[ShopListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            _info = [[ShopListInfo alloc] initWithDictionary:responseObject[@"info"] error:nil];
            [[TMCache sharedCache] setObject:_info.aid forKey:kShopInfo];
            [self.headerView changeLabelTitle:_info.shopname];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
        [self syncWithBannerListRequest:_info.aid];
    }];
}

- (void)syncWithBannerListRequest:(NSString *)shopCode {
    [ConfigModel showHud:self];
    if (_bannerArray.count>0) {
        [_bannerArray removeAllObjects];
    }
    NSDictionary *dic = @{
                          @"shopid":shopCode,
                          };
    [HttpRequest postPath:homeBannerURL params:dic resultBlock:^(id responseObject, NSError *error) {
        
        homeBannerModel *model = [[homeBannerModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            [_bannerArray addObjectsFromArray:model.info];
            [self.bannerView fillWithList:_bannerArray];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
    }];
}

#pragma mark - SelectShopDelegate
- (void)callbackWithSelectShop:(NSString *)shopName code:(NSString *)shopCode {
    [self.headerView changeLabelTitle:shopName];
}

#pragma mark - HomeBannerViewDelegate
- (void)didSelectBanner:(NSArray *)list {
    
}

#pragma mark - HomeHeaderDelegate
- (void)callbackOtherClick {
    SelectShopViewController *selectVC = [[SelectShopViewController alloc] init];
    selectVC.delegate = self;
    selectVC.currentLocation = _currentLocation;
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)callbackGoodsClick {
    FirstLevelGoodsViewController *cardVC = [[FirstLevelGoodsViewController alloc] init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:cardVC animated:YES];
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
