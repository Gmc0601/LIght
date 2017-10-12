//
//  OrderDetialViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderDetialViewController.h"
#import "OrderFootView.h"
#import "OrderInfoFootView.h"
#import "OrderGoodsTableViewCell.h"
#import "OrderAddressTableViewCell.h"
#import "OrderStoreInfoTableViewCell.h"
#import "OrderDataHelper.h"

@interface OrderDetialViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL post;   //  配送
    NSString *footInfo, *btnStr;
}

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *goodsArr, *couponArr;
@property (nonatomic, retain) OrderDetailModel *model;
@property (nonatomic, retain) OrderFootView *footView;
@property (nonatomic, retain) OrderInfoFootView *footInfoView;
@property (nonatomic, retain) NSArray *titleArr;


@end

@implementation OrderDetialViewController

- (void)viewDidLoad {
    post = YES;
    [super viewDidLoad];
    [self createView];
    [self resetFather];
    [self createData];
}

- (void)resetFather {
    NSString *titleStr;
    NSString *rightBarStr;
    self.rightBar.frame = FRAME(kScreenW - SizeWidth(75), 25, SizeWidth(65), 30);
    [self.footView choiseType:FootOneLab];
    switch (self.orderType) {
        case Order_Topay:
            rightBarStr = @"取消订单";
            titleStr = @"待支付";
            [self.footView choiseType:FootNoraml];
            break;
        case Order_Distribution:
            rightBarStr = @"取消订单";
            titleStr = @"待配送";
            break;
        case Order_Distributioning:
            rightBarStr = @"取消订单";
            titleStr = @"配送中";
            break;
        case Order_Invite:
            titleStr = @"待自取";
            break;
        case Order_Finished:
            titleStr = @"已完成";
            break;
        case Order_Cancle:
            titleStr = @"已取消";
            break;
        case Order_Refunding:
            titleStr = @"退款审核中";
            break;
        case Order_Refundsuccess:
            titleStr = @"退款成功";
            break;
        default:
            titleStr = @"没设置状态";
            break;
    }
    if (rightBarStr.length > 0) {
        [self.rightBar setTitle:rightBarStr forState:UIControlStateNormal];
        self.rightBar.titleLabel.font = NormalFont(13);
    }else {
        self.rightBar.hidden = YES;
    }
    self.titleLab.text = titleStr;
}

- (void)more:(UIButton *)sender {
    [ConfigModel mbProgressHUD:@"取消订单" andView:nil];
}

- (void)createView {
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
        if ([self.model.type intValue] == 1) {
            post = YES;
        }else {
            post = NO;
        }
        self.goodsArr = (NSMutableArray *)self.model.goodlist;
        self.couponArr = (NSMutableArray *)self.model.couponList;
        [self.footInfoView updateinfo:self.model];
//        amont = [self.model.all_amount floatValue];
//        postmoney = [self.model.postage floatValue];
//        storeName = self.model.shopInfo.shopname;
//        if ([self.model.type intValue] == 1) {
//            post = YES;
//        }else {
//            post = NO;
//        }
        [self.noUseTableView reloadData];
        
    }];
    
    //   修改订单状态
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
            return 2;
        }
            break;
        case 2:{
            return self.titleArr.count;
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
                    cell.detailTextLabel.font = SourceHanSansCNMedium(13);
                    if (post) {
                        cell.detailTextLabel.text = @"配送";
                    }else {
                        cell.detailTextLabel.text = @"自取";
                    }
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
                        cell.detailTextLabel.text = self.model.drawtime;
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
                        [cell updateinfo:self.model.receiptinfo];
                        [cell update:Order_haveAddress];
                    }else {
                        [cell update:Order_Nothing];
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
            cell.textLabel.font = SourceHanSansCNRegular(15);
            cell.textLabel.text = self.titleArr[indexPath.row];
            NSString *str;
            cell.detailTextLabel.font = VerdanaBold(15);
            cell.detailTextLabel.textColor = UIColorFromHex(0x333333);
            if (indexPath.row == 0) {
                str = [NSString stringWithFormat:@"￥%.2f", [self.model.all_amount floatValue]];
                cell.detailTextLabel.font = SourceHanSansCNMedium(12);
                cell.detailTextLabel.textColor = UIColorFromHex(0xff543a);
            }else if (indexPath.row == 1){
                str = [NSString stringWithFormat:@"￥%.2f", [self.model.coupon_money floatValue]];
            }else if(indexPath.row == 2){
                str = [NSString stringWithFormat:@"￥%.2f", [self.model.postage floatValue]];
            }else {
                str = [NSString stringWithFormat:@"￥%.2f", [self.model.amount floatValue]];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(220))];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:self.footInfoView];
            view;
        });
    }
    return _noUseTableView;
}
- (OrderFootView *)footView {
    if (!_footView) {
        _footView = [[OrderFootView alloc] initWithFrame:FRAME(0, kScreenH - SizeHeigh(54), kScreenW, SizeHeigh(54))];
        _footView.topupBlock = ^{
            
        };
        _footView.payBlock = ^{
            
        };
    }
    return _footView;
}

- (OrderInfoFootView *)footInfoView {
    WeakSelf(weakself);
    if (!_footInfoView) {
        _footInfoView = [[OrderInfoFootView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeigh(220))];
        _footInfoView.copyBtnBlock = ^{
            UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = weakself.model.order_no;
            [ConfigModel mbProgressHUD:@"复制成功" andView:nil];
        };
    }
    return _footInfoView;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"商品金额",@"优惠券抵扣",@"配送费",@"待支付"];
    }
    return _titleArr;
}


@end
