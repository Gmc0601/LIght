//
//  PurchaseCarViewController.m
//  BaseProject
//
//  Created by LeoGeng on 16/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "PurchaseCarViewController.h"
#import "FirstLevelGoodsViewController.h"
#import "MakeOrderViewController.h"

#import "PurchaseModel.h"
#import "PurcharseCell.h"
#import "TBRefresh.h"

@interface PurchaseCarViewController ()<UITableViewDelegate,UITableViewDataSource,PurcharseCellDelegate>{
    NSString *_cellIdentifier;
}
@property(retain,atomic)     UITableView *tb;
@property(retain,atomic)     NSArray *dataSource;
@property(retain,atomic)     UILabel *lblPrice;
@property(retain,atomic)     UILabel *lblDiscount;
@end

@implementation PurchaseCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self addViewsForEmpty];
    self.navigationView.backgroundColor = [UIColor colorWithHexString:@"#fecd2f"];
    self.titleLab.text = @"购物清单";
    
    [self.rightBar setImage:[UIImage imageNamed:@"sg_ic_down_up_h"] forState:UIControlStateNormal];
    
    [self.rightBar addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self renderUI];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self renderUI];
}

-(void) renderUI{
    [ConfigModel showHud:self];
    [NetHelper getCountOfGoodsInCar:^(NSString *error, NSString *info) {
        if (error == nil && info.intValue > 0) {
            if (_tb == nil) {
                [self.leftBar setImage:[UIImage imageNamed:@"icon_tab_qdsl"] forState:UIControlStateNormal];
                self.leftBar.imageEdgeInsets = UIEdgeInsetsMake(SizeHeigh(8), 0, 0, 0);
                [self addBottomView];
                [self addTableView];
            }
            
            [self addLableCountToImage:self.leftBar withText:info];
            [_tb.header beginRefreshing];
        }else{
            [ConfigModel hideHud:self];
            if (_tb !=nil) {
                [_tb removeFromSuperview];
                [self.bottomView removeFromSuperview];
                _tb = nil;
                self.bottomView = nil;
            }
            [self.leftBar setImage:[UIImage imageNamed:@"icon_tab_qd"] forState:UIControlStateNormal];
            [self addViewsForEmpty];
        }
    }];
}

-(void) addViewsForEmpty{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_qs"]];
    
    [self.view addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(SizeHeigh(-86));
        make.width.equalTo(@(SizeWidth(164/2)));
        make.height.equalTo(@(SizeHeigh(86/2)));
    }];
    
    UILabel *lblMsg = [UILabel new];
    lblMsg.font = SourceHanSansCNRegular(SizeWidth(13));
    lblMsg.textColor = [UIColor colorWithHexString:@"#999999"];
    lblMsg.textAlignment = NSTextAlignmentCenter;
    lblMsg.text = @"暂时没有相关商品信息";
    [self.view addSubview:lblMsg];
    
    [lblMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(SizeHeigh(106/2));
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@(SizeHeigh(15)));
    }];
    
    UIButton *btnGoto = [UIButton new];
    [btnGoto setTitle:@"浏览商品" forState:UIControlStateNormal];
    btnGoto.backgroundColor = [UIColor colorWithHexString:@"#3e7bb1"];
    btnGoto.layer.cornerRadius = SizeWidth(5/2);
    [btnGoto setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    btnGoto.titleLabel.font = SourceHanSansCNMedium(SizeWidth(15));
    [btnGoto addTarget:self action:@selector(gotoFirstCategory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGoto];
    
    [btnGoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblMsg.mas_bottom).offset(SizeHeigh(40/2));
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SizeWidth(150)));
        make.height.equalTo(@(SizeHeigh(88/2)));
    }];
}

-(void) back:(UIButton *)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) gotoFirstCategory{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[FirstLevelGoodsViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addTableView{
    _cellIdentifier = @"cell";
    _tb = [[UITableView alloc] init];
    _tb.rowHeight = SizeHeigh(161);
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.allowsSelection = NO;
    [_tb registerClass:[PurcharseCell class] forCellReuseIdentifier:_cellIdentifier];
    _tb.tableFooterView = [UIView new];
    
    [self.view addSubview:_tb];
    
    [_tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    __weak PurchaseCarViewController *weakSelf = self;
    
    [_tb addRefreshHeaderWithBlock:^{
        [weakSelf fetchData];
        [weakSelf.tb.header endHeadRefresh];
    }];
    
    [_tb addRefreshFootWithBlock:^{
        [weakSelf fetchData];
        [weakSelf.tb.footer endFooterRefreshing];
    }];
    
}

-(void) fetchData{
    [NetHelper getGoodsListFromCard:^(NSString *error, NSArray *datasource) {
        [ConfigModel hideHud:self];
        if (error == nil) {
            _dataSource = datasource;
            [_tb reloadData];
            [self setPrice];
        } else {
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PurcharseCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    cell.model = _dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) addBottomView{
    self.bottomView = [UIView new];
    //    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#fecd2f"];
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(SizeHeigh(108/2)));
    }];
    
    UILabel *lblSum = [UILabel new];
    lblSum.font = SourceHanSansCNRegular(SizeWidth(12));
    lblSum.textColor = [UIColor colorWithHexString:@"#333333"];
    lblSum.textAlignment = NSTextAlignmentLeft;
    lblSum.text = @"合计:";
    [self.bottomView addSubview:lblSum];
    
    [lblSum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(SizeWidth(15));
        make.top.equalTo(self.bottomView).offset(SizeHeigh(15));
        make.width.equalTo(@(SizeWidth(40)));
        make.height.equalTo(@(SizeHeigh(14)));
    }];
    
    _lblPrice = [UILabel new];
    _lblPrice.font = VerdanaBold(SizeWidth(18));
    _lblPrice.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblPrice.textAlignment = NSTextAlignmentLeft;
    _lblPrice.text = @"￥1234";
    [self.bottomView addSubview:_lblPrice];
    
    [_lblPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblSum.mas_right).offset(SizeWidth(5));
        make.bottom.equalTo(lblSum.mas_bottom);
        make.width.equalTo(@(SizeWidth(150)));
        make.height.equalTo(@(SizeHeigh(20)));
    }];
    
    UILabel *lblDiscountTitle = [UILabel new];
    lblDiscountTitle.font = SourceHanSansCNRegular(SizeWidth(10));
    lblDiscountTitle.textColor = [UIColor colorWithHexString:@"#999999"];
    lblDiscountTitle.textAlignment = NSTextAlignmentLeft;
    lblDiscountTitle.text = @"优惠";
    [self.bottomView addSubview:lblDiscountTitle];
    
    [lblDiscountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblSum.mas_left);
        make.top.equalTo(lblSum.mas_bottom).offset(SizeHeigh(8));
        make.width.equalTo(@(SizeWidth(35)));
        make.height.equalTo(@(SizeHeigh(12)));
    }];
    
    
    _lblDiscount = [UILabel new];
    _lblDiscount.font = VerdanaBold(SizeWidth(12));
    _lblDiscount.textColor = [UIColor colorWithHexString:@"#ff543a"];
    _lblDiscount.textAlignment = NSTextAlignmentLeft;
    _lblDiscount.text = @"￥1223";
    [self.bottomView addSubview:_lblDiscount];
    
    [_lblDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblPrice);
        make.bottom.equalTo(lblDiscountTitle.mas_bottom);
        make.width.equalTo(@(SizeWidth(100)));
        make.height.equalTo(@(SizeHeigh(12)));
    }];
    
    UIButton *btnCheck = [UIButton new];
    btnCheck.backgroundColor = [UIColor colorWithHexString:@"#fecd2f"];
    btnCheck.titleLabel.font = SourceHanSansCNRegular(13);
    [btnCheck setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btnCheck.layer.cornerRadius = SizeWidth(2.5);
    [btnCheck setTitle:@"结算" forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btnCheck];
    
    [btnCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(SizeWidth(-30/2));
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.width.equalTo(@(SizeWidth(196/2)));
        make.height.equalTo(@(SizeHeigh(88/2)));
    }];
}

-(void) check{
    [ConfigModel showHud:self];
    NSString *shopId = ((PurchaseModel *) _dataSource[0]).shopId;
    float sum = 0;
    for (PurchaseModel *model in _dataSource) {
        sum += model.price.floatValue * model.count;
    }
    
    [NetHelper addOrder:shopId withAmount:[NSString stringWithFormat:@"%.2f",sum] callBack:^(NSString *error, NSString *info) {
        [ConfigModel hideHud:self];
        if (error == nil) {
            MakeOrderViewController *newVC = [MakeOrderViewController new];
            newVC.OrderID = info;
            [self.navigationController pushViewController:newVC animated:YES];
        }else{
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
    }];
}

-(void) didDelete:(NSString *) _id{
    [ConfigModel showHud:self];
    [NetHelper deleteGoodsFromCardWithId:_id callBack:^(NSString *error, NSString *info) {
        [ConfigModel hideHud:self];
        if (error == nil) {
            [self renderUI];
            [ConfigModel mbProgressHUD:info andView:self.view];
        } else {
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
    }];
}

-(void) didChangeNumber:(PurchaseModel *)model withSender:(PurcharseCell *)sender{
    [NetHelper addGoodsToCardWithGoodsId:model.goodsId withShopId:model.shopId withCount:model.count withId:model._id withSKUId:model.categoryId withPrice:model.price callBack:^(NSString *error, NSString *info) {
        [ConfigModel hideHud:self];
        if (error == nil) {
            for (PurchaseModel *m in _dataSource) {
                if (m._id == model._id) {
                    m.count = model.count;
                }
            }
            
            [self renderUI];

        } else {
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
    }];
}

-(void) setPrice{
    float sum = 0;
    float discount = 0;
    for (PurchaseModel *model in _dataSource) {
        sum += model.price.floatValue * model.count;
        discount += (model.oldPrice - model.price.intValue) * model.count;
    }
    
    _lblPrice.text = [NSString stringWithFormat:@"￥%.2f",sum];
    _lblDiscount.text = [NSString stringWithFormat:@"￥%.2f",discount];
}
@end
