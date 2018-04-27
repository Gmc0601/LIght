//
//  ShopBaseViewController.m
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "ShopBaseViewController.h"
#import "GoodsModel.h"
#import "GoodsListView.h"
#import "GoodDetialViewController.h"
#import "PurchaseCarViewController.h"
#import "LoginViewController.h"

@interface ShopBaseViewController ()<GoodsListViewDelegate>
@property(retain,atomic) UIView *rightView;
@property(retain,atomic) UIView *rightBackgroundView;
@property(retain,atomic) UILabel *lblCount;
@property(retain,atomic) UIImageView *imgCount;
@end

@implementation ShopBaseViewController
@synthesize bottomView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addFavoriteButton{
    [self.rightBar setImage:[UIImage imageNamed:@"icon_nav_xa"] forState:UIControlStateNormal];
    [self.rightBar setTitle:@"" forState:UIControlStateNormal];
    [self.rightBar addTarget:self action:@selector(showFavoriarView) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL) hasBottomView{
    return  self.bottomView != nil;
}

-(void) injected{
    [self viewDidLoad];
}

-(void) addSearchButton{
    _searchBar = [SearchBarView new];
    [self.navigationView addSubview:_searchBar];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBar.mas_centerY);
        make.left.equalTo(self.leftBar.mas_right).offset(SizeWidth(24));
        make.height.equalTo(self.navigationView.mas_height);
        make.right.equalTo(self.rightBar.mas_left);
    }];
}

-(void) showFavoriarView{
    if ([ConfigModel getBoolObjectforKey:IsLogin] == NO) {
        [self presentViewController:[LoginViewController new] animated:YES completion:nil];
        return;
    }
    
    CGFloat width = SizeWidth(639/2);
    CGFloat x = self.view.bounds.size.width - width;
    
    if (_rightView == nil) {
        _rightBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _rightBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        _rightBackgroundView.alpha = 0.41;
        [self.view insertSubview:_rightBackgroundView atIndex:self.view.subviews.count];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRightView)];
        [_rightBackgroundView addGestureRecognizer:tapGesture];
        
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, width, self.view.bounds.size.height)];
        _rightView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_rightView];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, SizeHeigh(116/2))];
        lblTitle.font = SourceHanSansCNMedium(SizeWidth(14));
        lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor whiteColor];
        lblTitle.text = @"喜爱";
        lblTitle.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        [_rightView addSubview:lblTitle];
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_rightView.mas_centerX);
            make.top.equalTo(_rightView.mas_top).offset(SizeHeigh(30));
            make.height.equalTo(@(SizeHeigh(16)));
            make.width.equalTo(@(SizeHeigh(50)));
        }];
        
        GoodsListView *listView = [[GoodsListView alloc] init:self];
        listView.delegate = self;
        [_rightView insertSubview:listView atIndex:_rightView.subviews.count];
        listView.isFavorite = true;
        listView.tag = 8001;
        
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rightView);
            make.right.equalTo(_rightView);
            make.top.equalTo(lblTitle.mas_bottom);
            make.bottom.equalTo(_rightView);
        }];
    }else{
        GoodsListView *list = (GoodsListView *)[_rightView viewWithTag:8001];
        [list reloadData];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _rightBackgroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _rightView.frame = CGRectMake(x, _rightView.frame.origin.y, _rightView.bounds.size.width, _rightView.bounds.size.height);
    }];
    
    //    _rightView.c = [self mockData1];
}



-(void) dismissRightView{
    [UIView animateWithDuration:0.5 animations:^{
        _rightBackgroundView.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _rightView.frame = CGRectMake(self.view.bounds.size.width, _rightView.frame.origin.y, _rightView.bounds.size.width, _rightView.bounds.size.height);
    }];
}

-(void) didSelectGoods:(NSString *)goodsId{
    [self dismissRightView];
    GoodDetialViewController *newVC = [GoodDetialViewController new];
    NSString *shopId = [[TMCache sharedCache] objectForKey:kShopInfo];

    [newVC setGoodsId:goodsId withShopId:shopId];
    [self.navigationController pushViewController:newVC animated:YES];
}

-(void) addBottomView{
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#fecd2f"];
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(SizeHeigh(58)));
    }];
    
    _imgCount = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tab_qdsl"]];
    [self.bottomView addSubview:_imgCount];
    
    [_imgCount mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sg_ic_down_h"]];
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshCountOfGoodsInCar];
}

-(void) refreshCountOfGoodsInCar{
    [NetHelper getCountOfGoodsInCar:^(NSString *error, NSString *info) {
        if (error == nil && _imgCount != nil) {
            if (info.intValue > 0) {
                [_imgCount setImage:[UIImage imageNamed:@"icon_tab_qdsl"]];
                [self addLableCountToImage:_imgCount withText:info];
                [_imgCount mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(SizeWidth(57/2)));
                    make.height.equalTo(@(SizeHeigh(57/2)));
                }];
            }else{
                [_imgCount removeAllSubviews];
                [_imgCount setImage:[UIImage imageNamed:@"icon_tab_qd"]];
                [_imgCount mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(SizeWidth(22)));
                    make.height.equalTo(@(SizeHeigh(22)));
                }];
            }
        }
    }];
}

-(void) showPurchaseCarViewController{
    if ([ConfigModel getBoolObjectforKey:IsLogin] == NO) {
        [self presentViewController:[LoginViewController new] animated:YES completion:nil];
        return;
    }
    PurchaseCarViewController *newVC = [PurchaseCarViewController new];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:newVC animated:YES];
}

-(void) removeCountLableFromImage{
    [_lblCount removeFromSuperview];
    _lblCount = nil;
}

-(void) addLableCountToImage:(UIView *) img withText:(NSString *)  text{
    if (text == nil || text.floatValue == 0) {
        [_lblCount removeFromSuperview];
        return;
    }
    
    float bottom = -SizeHeigh(2.5);
    float right = SizeWidth(3);
    if ([img isKindOfClass:[UIButton class]]) {
        bottom = -SizeHeigh(4);
        right = SizeWidth(2);
    }
    
    if (_lblCount == nil) {
        _lblCount = [UILabel new];
        _lblCount.font = Verdana(SizeWidth(8));
        _lblCount.textColor = [UIColor colorWithHexString:@"#fecd2f"];
        _lblCount.textAlignment = NSTextAlignmentCenter;
        [img addSubview:_lblCount];
        
        [_lblCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(img).offset(right);
            make.bottom.equalTo(img).offset(bottom);
            make.width.equalTo(@(SizeWidth(20)));
            make.height.equalTo(@(SizeHeigh(10)));
        }];
    }
    
    _lblCount.text = [NSString stringWithFormat:@"%@",text];
}
@end
