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

@interface ShopBaseViewController ()<GoodsListViewDelegate>
@property(retain,atomic) GoodsListView *rightView;
@property(retain,atomic) UIView *rightBackgroundView;
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
    CGFloat width = SizeWidth(639/2);
    CGFloat x = self.view.bounds.size.width - width;
    
    if (_rightView == nil) {
        _rightBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [self.view addSubview:_rightBackgroundView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRightView)];
        [_rightBackgroundView addGestureRecognizer:tapGesture];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, SizeHeigh(20), width, SizeHeigh(116/2 -20))];
        lblTitle.font = SourceHanSansCNMedium(SizeWidth(14));
        lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor whiteColor];
        lblTitle.text = @"喜爱";
        lblTitle.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        [_rightBackgroundView addSubview:lblTitle];
        
        _rightView = [[GoodsListView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, SizeHeigh(116/2), width, self.view.bounds.size.height - SizeHeigh(116/2))];
        _rightView.isFavorite = true;
        _rightView.delegate = self;
        [self.view addSubview:_rightView];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _rightBackgroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _rightView.frame = CGRectMake(x, _rightView.frame.origin.y, _rightView.bounds.size.width, _rightView.bounds.size.height);
    }];
    
    _rightView.datasource = [self mockData1];
}

-(NSMutableArray *) mockData1{
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        GoodsModel *model = [GoodsModel new];
        model._id = @"1";
        model.name = @"小龙虾";
        model.canTakeBySelf = YES;
        model.hasDiscounts = YES;
        model.canDelivery = NO;
        model.isNew = NO;
        model.price = @"111";
        model.memberPrice = @"1";
        [data addObject:model];
    }
    
    return data;
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
    
    [self.navigationController pushViewController:newVC animated:YES];
}
@end
