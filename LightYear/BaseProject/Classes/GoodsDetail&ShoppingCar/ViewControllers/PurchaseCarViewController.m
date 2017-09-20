//
//  PurchaseCarViewController.m
//  BaseProject
//
//  Created by LeoGeng on 16/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "PurchaseCarViewController.h"
#import "FirstLevelGoodsViewController.h"

#import "GoodsModel.h"
#import "PurcharseCell.h"
#import "TBRefresh.h"

@interface PurchaseCarViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_cellIdentifier;
}
@property(retain,atomic)     UITableView *tb;
@property(retain,atomic)     NSMutableArray *dataSource;
@end

@implementation PurchaseCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addViewsForEmpty];
    self.navigationView.backgroundColor = [UIColor colorWithHexString:@"#fecd2f"];
    self.titleLab.text = @"购物清单";
    [self.leftBar setImage:[UIImage imageNamed:@"icon_tab_qd"] forState:UIControlStateNormal];
    
    [self.rightBar setImage:[UIImage imageNamed:@"sg_ic_down_up_h"] forState:UIControlStateNormal];
    
    [self.rightBar addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self addBottomView];
    [self addTableView];
    [self mockData];
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


-(void) mockData{
    _dataSource = [NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        GoodsModel *model = [GoodsModel new];
        model._id = @"1";
        model.name = @"小龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾";
        model.canTakeBySelf = YES;
        model.hasDiscounts = YES;
        model.canDelivery = NO;
        model.isNew = NO;
        model.price = @"111";
        model.memberPrice = @"1";
        [_dataSource addObject:model];
    }
    
    [_tb reloadData];
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
        [weakSelf.tb.header endHeadRefresh];
    }];
    
    [_tb addRefreshFootWithBlock:^{
        [weakSelf.tb.footer endFooterRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PurcharseCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    cell.model = _dataSource[indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GoodsModel *model = (GoodsModel *) _dataSource[indexPath.row];
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
        make.width.equalTo(@(SizeWidth(30)));
        make.height.equalTo(@(SizeHeigh(14)));
    }];
    
    UILabel *lblMoney = [UILabel new];
    lblMoney.font = VerdanaBold(SizeWidth(18));
    lblMoney.textColor = [UIColor colorWithHexString:@"#333333"];
    lblMoney.textAlignment = NSTextAlignmentLeft;
    lblMoney.text = @"1234";
    [self.bottomView addSubview:lblMoney];
    
    [lblMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblSum.mas_right).offset(SizeWidth(5));
        make.bottom.equalTo(lblSum.mas_bottom);
        make.width.equalTo(@(SizeWidth(70)));
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
        make.width.equalTo(@(SizeWidth(20)));
        make.height.equalTo(@(SizeHeigh(12)));
    }];

    
    UILabel *lblDiscount = [UILabel new];
    lblDiscount.font = VerdanaBold(SizeWidth(12));
    lblDiscount.textColor = [UIColor colorWithHexString:@"#ff543a"];
    lblDiscount.textAlignment = NSTextAlignmentLeft;
    lblDiscount.text = @"1223";
    [self.bottomView addSubview:lblDiscount];
    
    [lblDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblMoney);
        make.bottom.equalTo(lblDiscountTitle.mas_bottom);
        make.width.equalTo(@(SizeWidth(70)));
        make.height.equalTo(@(SizeHeigh(14)));
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
    
}
@end
