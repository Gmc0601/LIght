//
//  MemberCardViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MemberCardViewController.h"
#import "MemberRechargeViewController.h"
#import "WMBalancePointDetailsViewController.h"
#import "ShopListModel.h"

@interface MemberCardViewController ()

@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UIImageView *codeImageV;
@property (nonatomic, strong) UILabel *balancePromptLabel;
@property (nonatomic, strong) UILabel *scroPromptLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *scroLabel;
@property (nonatomic, strong) UIButton *rechargeBtn;

@end

@implementation MemberCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.titleLab.text = @"会员卡";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leftBar removeFromSuperview];
    [self.rightBar removeFromSuperview];
    [self syncWithUserInfoRequest];
}

#pragma mark - Service
- (void)syncWithUserInfoRequest {
    [ConfigModel showHud:self];
    [HttpRequest postPath:memberInfoURL params:nil resultBlock:^(id responseObject, NSError *error) {
        
        ShopListModel * model = [[ShopListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            ShopListInfo *info = [[ShopListInfo alloc] initWithDictionary:responseObject[@"info"] error:nil];
            _balanceLabel.text = info.amount;
            _scroLabel.text = info.integral;
            [_codeImageV sd_setImageWithURL:[NSURL URLWithString:info.barurl]];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
    }];
}

- (void)goToRecharge {
    MemberRechargeViewController *rechargeVC = [[MemberRechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)initLeftBar {
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake( SizeWidth(16), 25, 40, 30)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitle:@"明细" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = SourceHanSansCNRegular(13);
    [leftBtn addTarget:self action:@selector(balanceMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:leftBtn];
}

- (void)initRightBar {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.navigationView.width-SizeWidth(16)-17, 30, 17,17);
    [rightBtn setImage:[UIImage imageNamed:@"sg_ic_quxiao"] forState:UIControlStateNormal];
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:rightBtn];
}

- (void)rightBtnClick {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)balanceMessage {
    WMBalancePointDetailsViewController *balanceVC = [[WMBalancePointDetailsViewController alloc] init];
    [self.navigationController pushViewController:balanceVC animated:YES];
}

- (void)setupView {
    [self initLeftBar];
    [self initRightBar];
    [self.view addSubview:self.bgImageV];
    [self.bgImageV addSubview:self.codeImageV];
    [self.view addSubview:self.balancePromptLabel];
    [self.view addSubview:self.scroPromptLabel];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.scroLabel];
    [self.view addSubview:self.rechargeBtn];
}

#pragma mark - lazyLoad
- (UIImageView *)bgImageV {
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake( 0, SizeHeigh(42)+64, SizeWidth(225), SizeHeigh(408))];
        _bgImageV.centerX = self.view.width/2;
        _bgImageV.image = [UIImage imageNamed:@"bg_hyk_img"];
    }
    return _bgImageV;
}

- (UIImageView *)codeImageV {
    if (!_codeImageV) {
        _codeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(30), SizeHeigh(65), SizeWidth(90), SizeHeigh(315))];
    }
    return _codeImageV;
}

- (UILabel *)balancePromptLabel {
    if (!_balancePromptLabel) {
        _balancePromptLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _bgImageV.height+_bgImageV.origin.y+SizeHeigh(45), SizeWidth(50), SizeHeigh(15))];
        _balancePromptLabel.text = @"余额";
        _balancePromptLabel.centerX = self.view.width/4;
        _balancePromptLabel.textAlignment = NSTextAlignmentCenter;
        _balancePromptLabel.font = SourceHanSansCNMedium(SizeWidth(12));
        _balancePromptLabel.textColor = UIColorFromHex(0x999999);
    }
    return _balancePromptLabel;
}

- (UILabel *)scroPromptLabel {
    if (!_scroPromptLabel) {
        _scroPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0,  _bgImageV.height+_bgImageV.origin.y+SizeHeigh(45), SizeWidth(50), SizeHeigh(15))];
        _scroPromptLabel.text = @"积分";
        _scroPromptLabel.centerX = self.view.width/4*3;
        _scroPromptLabel.textAlignment = NSTextAlignmentCenter;
        _scroPromptLabel.font = SourceHanSansCNMedium(SizeWidth(12));
        _scroPromptLabel.textColor = UIColorFromHex(0x999999);
    }
    return _scroPromptLabel;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _balancePromptLabel.origin.y+_balancePromptLabel.height+SizeHeigh(13), SizeWidth(150), SizeHeigh(20))];
        _balanceLabel.centerX = _balancePromptLabel.centerX;
        _balanceLabel.font = VerdanaBold(SizeWidth(20));
        _balanceLabel.textColor = UIColorFromHex(0x333333);
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _balanceLabel;
}

- (UILabel *)scroLabel {
    if (!_scroLabel) {
        _scroLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _scroPromptLabel.origin.y+_scroPromptLabel.height+SizeHeigh(13), SizeWidth(150), SizeHeigh(20))];
        _scroLabel.centerX = _scroPromptLabel.centerX;
        _scroLabel.font = VerdanaBold(SizeWidth(20));
        _scroLabel.textColor = UIColorFromHex(0x333333);
        _scroLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scroLabel;
}

- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake( 0, _balanceLabel.height+_balanceLabel.origin.y+SizeHeigh(9), SizeWidth(100), SizeHeigh(40))];
        _rechargeBtn.centerX = _balanceLabel.centerX;
        [_rechargeBtn setTitle:@"查看充值优惠" forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = SourceHanSansCNRegular(SizeWidth(11));
        _rechargeBtn.titleLabel.numberOfLines = 0;
        [_rechargeBtn setTitleColor:UIColorFromHex(0x347bb1) forState:UIControlStateNormal];
        [_rechargeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_rechargeBtn addTarget:self action:@selector(goToRecharge) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

@end
