//
//  MakeOrderViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MakeOrderViewController.h"
#import "OrderGoodsTableViewCell.h"
#import "OrderAddressTableViewCell.h"
#import "OrderFootView.h"
#import "OrderModel.h"
#import "OrderStoreInfoTableViewCell.h"
#import "CouponViewController.h"
#import "OrderDataHelper.h"
#import "MemberRechargeViewController.h"
#import "DeliveryAddressViewController.h"
#import "PickerViewCustom.h"
#import "HHPayPasswordView.h"
#import "ChangePayPasswordViewController.h"
#import "OrderDetialViewController.h"
#import "OrderViewController.h"
#import "ChangeUserInfoViewController.h"
#import "SelectShopViewController.h"

@interface MakeOrderViewController ()<UITableViewDelegate, UITableViewDataSource, PickerViewCustomDelegate, HHPayPasswordViewDelegate> {
    BOOL post; //  配送
    int canUseCouponNum , couponId;   //  可使用优惠券数量
    float couponcut, amont, postmoney, topaymoney;//  优惠券减少金额
    NSString *getTime, *storeName, *couponInfo;  //  自取时间   商店名称   优惠券信息
}

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *goodsArr, *couponArr;
@property (nonatomic, retain) NSArray *titleArr;
@property (nonatomic, retain) OrderFootView *footView;
@property (nonatomic, retain) OrderDetailModel *model;
@property (nonatomic, retain) DeliveryAddressInfo *addressModle;
@property (nonatomic, retain) UIButton *postBtn, *getBtn;   //  配送 自取

@end

@implementation MakeOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self resetFather];
    
    [self createview];
    
    [self createData];
    
}


- (void)resetFather {
    couponcut = 0; couponId = -1;
    post = YES;
    storeName = @"光年浙工商店";
    self.titleLab.text = @"确认订单";
    self.rightBar.hidden = YES;
}

- (void)back:(UIButton *)sender {
    OrderDetialViewController *vc = [[OrderDetialViewController alloc] init];
    vc.OrderID = self.OrderID;
    vc.orderType = Order_Topay;
    vc.backHome = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createview {
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.footView];
}

- (void)createData {
    //   查询订单详情
    if (self.OrderID.length == 0) {
        [ConfigModel mbProgressHUD:@"请传入Order_NO" andView:nil];
        return;
    }
    NSDictionary *dic =@{
                         @"id" : self.OrderID
                         };
    [OrderDataHelper orderDetailWithParameter:dic callBack:^(BOOL success, OrderDetailModel *model) {
        self.model = model;
        self.goodsArr = (NSMutableArray *)self.model.goodlist;
        self.couponArr = (NSMutableArray *)self.model.couponList;
        amont = [self.model.all_amount floatValue];
        postmoney = [self.model.warehouseInfo.deliverfee floatValue];
        storeName = self.model.shopInfo.shopname;
        if ([self.model.can_ship intValue] == 1) {
            post = YES;
        }else {
            post = NO;
        }
        
        [self changefootviewInfo];
        
        NSDictionary *couDic = @{
                                 @"type" : @"1",
                                 @"amount" : @"",
                                 };
        [HttpRequest postPath:@"_coupon_list_001" params:couDic resultBlock:^(id responseObject, NSError *error) {
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                NSArray *arr = datadic[@"info"];
                canUseCouponNum = (int)arr.count;
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
        [self.noUseTableView reloadData];
    }];
    
    //   修改订单状态
}

- (void)changefootviewInfo {
    
    if (([self.model.warehouseInfo isEqual:[NSNull null]] || self.model.warehouseInfo == nil) && post) {
        
        [self.footView choiseType:FootOneLab];
        self.footView.moreLab.text = @"收货地址超出配送范围,无法配送";
        [self.footView changeBtnStyle:Gray];
        [self.footView.payBtn setTitle:@"查看其它店铺" forState:UIControlStateNormal];
        return;
    }
    [self.footView choiseType:FootNoraml];
    float price;
    if (post && (amont > [self.model.warehouseInfo.freeprice floatValue])) {
        price = amont - couponcut;
    }else {
        price = amont + postmoney - couponcut;
    }
    self.footView.priceLab.text = [NSString stringWithFormat:@"%.2f", price];
    self.footView.balanceLab.text = [NSString stringWithFormat:@"账户余额：￥%.2f", [self.model.userAmount floatValue]];
    if ([self.model.userAmount floatValue]  < price) {
        [self.footView.payBtn setTitle:@"账户余额不足" forState:UIControlStateNormal];
        [self.footView changeBtnStyle:Gray];
        return;
    }
    if (post) {
        if (amont >= [self.model.warehouseInfo.minprice floatValue]) {
            [self.footView.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            self.footView.payBtn.titleLabel.font = SourceHanSansCNRegular(13);
            [self.footView changeBtnStyle:Red];
        }else {
            float cut = [self.model.warehouseInfo.minprice floatValue] - amont;
            NSString * str = [NSString stringWithFormat:@"还差%.2f元起送", cut];
            [self.footView.payBtn setTitle:str forState:UIControlStateNormal];
            self.footView.payBtn.titleLabel.font = SourceHanSansCNRegular(7);
            [self.footView changeBtnStyle:Gray];
        }
    }else {
        [self.footView.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        self.footView.payBtn.titleLabel.font = SourceHanSansCNRegular(13);
        [self.footView changeBtnStyle:Red];
    }
    topaymoney = price;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return post ? 3 : 4;
        }
            break;
        case 1:{
            return self.goodsArr.count;
        }
            break;
        case 2:{
            return post ? 3 : 2;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)defaleCellWithTitle:(NSString *)title andCellId:(NSString *)cellId {
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = SourceHanSansCNRegular(15);
    cell.textLabel.text = title;
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0 :{
                    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                    }
                    cell.textLabel.font = SourceHanSansCNRegular(15);
                    cell.textLabel.text = @"配送方式";
                    [cell.contentView addSubview:self.postBtn];
                    [cell.contentView addSubview:self.getBtn];
                    [self changePostType];
                    return cell;
                }
                    break;
                case 1 :{
                    
                    if (post) {
                        return [self defaleCellWithTitle:@"收货地址" andCellId:cellId];
                    }else {
                        UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
                        for (UIView* subView in cell.contentView.subviews) {
                            [subView removeFromSuperview];
                        }
                        if (!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                        }
                        cell.textLabel.font = SourceHanSansCNRegular(15);
                        cell.textLabel.text = @"取货时间";
                        NSString *str ;
                        if (getTime.length == 0) {
                            str = @"未选择";
                        }else {
                            str = getTime;
                        }
                        cell.detailTextLabel.text = str;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.detailTextLabel.font = VerdanaBold(15);
                        return cell;
                    }
                }
                    break;
                case 2:{
                        OrderAddressTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
                        if (!cell) {
                            cell = [[OrderAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                        }
                    if (post) {
                        cell.textLabel.text = @"";
                        cell.backgroundColor = RGBColor(239, 240, 241);
                        cell.contentView.backgroundColor = RGBColor(239, 240, 241);
                        [cell updateinfo:self.model.receiptinfo];
                        [cell update:Order_haveAddress];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }else {
                        [cell update:Order_Nothing];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.textLabel.text = @"门店地址";
                    }
                        return cell;
            
                }
                    break;

                case 3:{
                    OrderStoreInfoTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
                    if (!cell) {
                        cell = [[OrderStoreInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                    }
                    [cell updateinfo:self.model.shopInfo];
                    return cell;
                }
                    break;

                default:
                    return nil;
                    break;
            }
            
        }
            break;
        case 1:{
            OrderGoodsTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            if (self.goodsArr.count > 0) {
                NSDictionary *dic = self.goodsArr[indexPath.row];
                [cell updateinfo:dic];
            }
            
            return cell;
        }
            break;
        case 2:{
            UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            }
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.font = SourceHanSansCNRegular(15);
            cell.textLabel.text = self.titleArr[indexPath.row];
            NSString *str;
            cell.detailTextLabel.font = VerdanaBold(15);
            cell.detailTextLabel.textColor = UIColorFromHex(0x333333);
            if (indexPath.row ==0) {
                if (couponInfo.length == 0) {
                    if (self.couponArr.count ==0) {
                        str = @"";
                    }else {
                     str = [NSString stringWithFormat:@"%d张可用", canUseCouponNum];
                    }
                }else {
                    str = couponInfo;
                }
                
                cell.detailTextLabel.font = SourceHanSansCNMedium(12);
                cell.detailTextLabel.textColor = UIColorFromHex(0xff543a);
            }else if (indexPath.row == 1){
                str = [NSString stringWithFormat:@"￥%.2f", amont];
            }else {
                if ([self.model.all_amount floatValue] > [self.model.warehouseInfo.freeprice floatValue]) {
                    str = @"￥0.00";
                    postmoney = 0;
                }else {
                    str = [NSString stringWithFormat:@"￥%.2f",[self.model.warehouseInfo.deliverfee floatValue] ];
                    postmoney  = [self.model.warehouseInfo.deliverfee floatValue];
                }
            }
            cell.detailTextLabel.text = str;
            return cell;
        }
            break;
            
        default:{
            UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            return cell;
        }
            break;
    }
}


#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 3) {
                return SizeHeigh(150);
            }else if (indexPath.row == 2){
                return post ? SizeHeigh(90) : SizeHeigh(50);
            }else {
                return SizeHeigh(50);
            }
        }
            break;
        case 1:{
            return SizeHeigh(160);
        }
            break;
        case 2:{
            return SizeHeigh(50);
        }
            break;
        default:
            return 0;
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1 && !post) {
        PickerViewCustom *customView = [[PickerViewCustom alloc]init];
        customView.delegate = self;
        
        [customView show];
    }
    
    if (indexPath.section == 0 && indexPath.row == 2 && post) {
        DeliveryAddressViewController *vc = [[DeliveryAddressViewController alloc] init];
        vc.getback = YES;
        WeakSelf(weakself);
        vc.addressBlock = ^(DeliveryAddressInfo *model) {
            NSDictionary *dic = @{
                                  @"receipt_id": model.id,
                                  @"invest_id": self.OrderID
                                  };
            [HttpRequest postPath:@"_setinvest_receipt_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                NSLog(@"%@", responseObject);
                if([error isEqual:[NSNull null]] || error == nil){
                    NSLog(@"success");
                }
                NSDictionary *datadic = responseObject;
                if ([datadic[@"error"] intValue] == 0) {
                    weakself.model.receiptinfo.phone = model.phone;
                    weakself.model.receiptinfo.username = model.username;
                    weakself.model.receiptinfo.address = model.address;
                    weakself.model.receiptinfo.id = model.id;
                    [weakself createData];
                    [weakself.noUseTableView reloadData];
                }else {
                    NSString *str = datadic[@"info"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0 && self.couponArr.count > 0) {
        CouponViewController *view = [[CouponViewController alloc] init];
        view.amout = self.model.all_amount;
        view.couponBlock = ^(NSString *idStr, NSString *cutmoney) {
            couponId = [idStr intValue];
            couponcut = [cutmoney floatValue];
        };
        [self.navigationController pushViewController:view animated:YES];
    }
}
//  获取返回时间
-(void)title:(NSString *)title
{
    NSLog(@"...%@", title);
    getTime = title;
    [self.noUseTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeigh(45))];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(10), SizeHeigh(15), kScreenW, SizeHeigh(20))];
        lab.text = storeName;
        lab.font = NormalFont(15);
        
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeigh(44), kScreenW, SizeHeigh(1))];
        line.backgroundColor = RGBColor(239, 240, 241);
        
        [view addSubview:lab];
        [view addSubview:line];
        
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return SizeHeigh(45);
    }else {
        return 0.01;
    }
}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeigh(50)) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        [_noUseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            view.backgroundColor = [UIColor blueColor];
            view;
        });
    }
    return _noUseTableView;
}

- (OrderFootView *)footView {
    if (!_footView) {
        _footView = [[OrderFootView alloc] initWithFrame:FRAME(0, kScreenH - SizeHeigh(54), kScreenW, SizeHeigh(54))];
        WeakSelf(weakself);
        _footView.topupBlock = ^{
            MemberRechargeViewController *vc = [[MemberRechargeViewController alloc] init];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        _footView.payBlock = ^{
            //  修改订单状态
            if ([_footView.payBtn.titleLabel.text isEqualToString:@"查看其它店铺"]) {
//                查看其它店铺
//                [weakself.navigationController popToRootViewControllerAnimated:YES];
                SelectShopViewController *vc = [[SelectShopViewController alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
                return ;
            }
            
            [weakself updateOrderState];
        };
    }
    return _footView;
}

- (void)updateOrderState {
//    [self click];
//    return;
    /*
     userToken
     invest_id订单id
     coupon_id优惠卷id
     coupon_money:优惠卷金额
     amount订单支付金额
     type配送方式1配送2自取
     postage配送费，type为1时
     drawtime自取时间，日期时间格式，type为2时
     */
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.OrderID forKey:@"invest_id"];
    if (couponId > 0) {
        [dic setValue:@(couponId) forKey:@"coupon_id"];
        [dic setValue:@(couponcut) forKey:@"coupon_money"];
    }
    [dic setValue:@(topaymoney) forKey:@"amount"];
    if (post) {
        [dic setValue:@"1" forKey:@"type"];
        //  邮费 ？？
        if (postmoney > 0) {
         [dic setValue:@(postmoney) forKey:@"postage"];
        }
    }else {
        [dic setValue:@"2" forKey:@"type"];
        if (getTime.length > 0) {
            [dic setValue:getTime forKey:@"drawtime"];
        }else {
            [ConfigModel mbProgressHUD:@"请选择取货时间" andView:nil];
            return;
        }
        
    }
    [HttpRequest postPath:@"_update_order_001" params:dic resultBlock:^(id responseObject, NSError *error) {

        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            [self click];
        }else {
            NSString *str = datadic[@"message"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)click{
    HHPayPasswordView *payPasswordView = [[HHPayPasswordView alloc] init];
    payPasswordView.delegate = self;
    WeakSelf(weak);
    payPasswordView.closeBlock = ^{
        OrderDetialViewController *vc = [[OrderDetialViewController alloc] init];
        vc.OrderID = self.OrderID;
        vc.orderType = Order_Topay;
        vc.backHome = YES;
        [weak.navigationController pushViewController:vc animated:YES];
    };
    [payPasswordView showInView:self.view];
}

#pragma mark - HHPayPasswordViewDelegate
- (void)passwordView:(HHPayPasswordView *)passwordView didFinishInputPayPassword:(NSString *)password{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //   请求网络
        NSDictionary *dic = @{
                              @"invest_id" : self.OrderID,
                              @"tradePwd" : password
                                  };
        WeakSelf(weakself);
        [HttpRequest postPath:@"_pay_001" params:dic resultBlock:^(id responseObject, NSError *error) {
            NSLog(@"%@", responseObject);
            
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
                
            }
            
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                [passwordView paySuccess];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [passwordView hide];
                    OrderViewController  *vc = [[OrderViewController alloc] init];
                    vc.listType = OrderList_All;
                    vc.backHome = YES;
                    [weakself.navigationController pushViewController:vc animated:YES];
                });
            }else {
                [passwordView payFailureWithPasswordError:YES withErrorLimit:3];
                [ConfigModel mbProgressHUD:@"支付密码错误" andView:nil];
            }
            
            
            
        }];
        

    });
}

- (void)forgetPayPassword {
    //  忘记密码
    ChangeUserInfoViewController * changeUserInfoVC = [[ChangeUserInfoViewController alloc] init];
    changeUserInfoVC.type = UserInfoTypePayPassword;
    [self.navigationController pushViewController:changeUserInfoVC animated:YES];
    
//    ChangePayPasswordViewController *vc = [[ChangePayPasswordViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray new];
    }
    return _goodsArr;
}

- (NSMutableArray *)couponArr {
    if (!_couponArr) {
        _couponArr = [NSMutableArray new];
    }
    return _couponArr;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr =@[@"优惠券", @"商品金额", @"配送费"];
    }
    return _titleArr;
}

-(UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - SizeWidth(15) - SizeWidth(114), SizeHeigh(10), SizeWidth(57), SizeHeigh(30))];
        _postBtn.layer.masksToBounds = YES;
        _postBtn.layer.cornerRadius = SizeHeigh(3);
        [_postBtn setTitle:@"配送" forState:UIControlStateNormal];
        _postBtn.titleLabel.font = SourceHanSansCNRegular(13);
        _postBtn.tag = 100;
        [_postBtn addTarget:self action:@selector(postOrget:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

-(UIButton *)getBtn {
    if (!_getBtn) {
        _getBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - SizeWidth(15) - SizeWidth(57), SizeHeigh(10), SizeWidth(57), SizeHeigh(30))];
        _getBtn.layer.masksToBounds = YES;
        _getBtn.layer.cornerRadius = SizeHeigh(3);
        [_getBtn setTitle:@"自取" forState:UIControlStateNormal];
        _getBtn.titleLabel.font = SourceHanSansCNRegular(13);
        _getBtn.tag = 200;
        [_getBtn addTarget:self action:@selector(postOrget:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getBtn;
}


- (void)postOrget:(UIButton *)sender {
    if (sender.tag == 100) {
        if ([self.model.can_ship intValue] == 2) {
            [ConfigModel mbProgressHUD:@"该商品不能配送" andView:nil];
            return;
        }
        post = YES;
    }else {
        if ([self.model.can_selftake intValue] == 2) {
            [ConfigModel mbProgressHUD:@"该商品不能自取" andView:nil];
            return;
        }
        post = NO;
    }
    [self changePostType];
    [self changefootviewInfo];
    [self.noUseTableView reloadData];
}


- (void)changePostType {
    if (post) {
        
        [self.postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.postBtn.backgroundColor = UIColorFromHex(0x3e7bb1);
        self.getBtn.backgroundColor =UIColorFromHex(0xf1f2f2);
        [self.getBtn setTitleColor:UIColorFromHex(0xcccccc) forState:UIControlStateNormal];
    }else {
        [self.getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.getBtn.backgroundColor = UIColorFromHex(0x3e7bb1);
        self.postBtn.backgroundColor =UIColorFromHex(0xf1f2f2);
        [self.postBtn setTitleColor:UIColorFromHex(0xcccccc) forState:UIControlStateNormal];
    }
}
@end
