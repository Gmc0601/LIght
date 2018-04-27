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
#import "HHPayPasswordView.h"
#import "OrderViewController.h"
#import "ChangePayPasswordViewController.h"
#import "MakeOrderViewController.h"
#import "UIButton+YX.h"
#import "NSTimer+EOCBlocksSupport.h"
#import "UserModel.h"

@interface OrderDetialViewController ()<UITableViewDelegate, UITableViewDataSource, HHPayPasswordViewDelegate>{
    BOOL post;   //  配送
    float couponcut, amont, postmoney, topaymoney;//  优惠券减少金额
    NSString *footInfo, *btnStr , *payStr, *storeName;
    NSTimer *_timer;
    UserInfo * userModel;
    int bottomHeight;
}

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) UILabel *timeLab;
@property (nonatomic, retain) NSMutableArray *goodsArr, *couponArr;
@property (nonatomic, retain) OrderDetailModel *model;
@property (nonatomic, retain) OrderFootView *footView;
@property (nonatomic, retain) OrderInfoFootView *footInfoView;
@property (nonatomic, retain) NSArray *titleArr;



@end

@implementation OrderDetialViewController

- (void)viewDidLoad {
    post = YES;
    bottomHeight = SizeHeigh(54);
    if (kDevice_Is_iPhoneX) {
        bottomHeight = SizeHeigh(64);
    }
    payStr = @"已支付";
    [super viewDidLoad];
    [self createView];
    [self resetFather];
    [self createData];
}

- (void)back:(UIButton *)sender {
    if (self.backHome) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)resetFather {
    NSString *titleStr;
    NSString *rightBarStr;
    
    self.rightBar.frame = FRAME(kScreenW - SizeWidth(75), self.top, SizeWidth(65), 30);
    [self.footView choiseType:FootOneLab];
    switch (self.orderType) {
        case Order_Topay:
            rightBarStr = @"取消订单";
            titleStr = @"待支付";
            self.titleArr = @[@"商品金额",@"优惠券抵扣",@"配送费",payStr];
            payStr = @"待支付";
            [self.footView choiseType:FootNoraml];
            break;
        case Order_Distribution:
            titleStr = @"待配送";
            break;
        case Order_Distributioning:
            titleStr = @"配送中";
            [self.footView choiseType:FootOneLab];
             self.footView.moreLab.text = @"配送员正在狂奔送货中...请耐心等待";
            self.footView.logoImage.hidden = YES;
            [self.footView changeBtnStyle:Gray];
            [self.footView.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
            break;
        case Order_Invite:
            titleStr = @"待自取";
            
            break;
        case Order_Finished:
            titleStr = @"已完成";
            [self.footView choiseType:FootOneLab];
            self.footView.moreLab.hidden = YES;
            self.footView.logoImage.hidden = YES;
            [self.footView changeBtnStyle:Yellow];
            [self.footView.payBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            break;
        case Order_Cancle:
            titleStr = @"已取消";
            payStr = @"待支付";
            self.titleArr = @[@"商品金额",@"优惠券抵扣",@"配送费",payStr];
            [self.footView choiseType:FootOneLab];
            self.footView.logoImage.hidden = YES;
            self.footView.moreLab.hidden =YES;
            [self.footView.payBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [self.footView changeBtnStyle:Yellow];
            break;
        case Order_Refunding:
            titleStr = @"退款审核中";
            [self.footView choiseType:FootOneLab];
            self.footView.moreLab.text = @"退款审核中...请您耐心等待";
            self.footView.payBtn.hidden = YES;
            break;
        case Order_Refundsuccess:
            titleStr = @"退款成功";
            [self.footView choiseType:FootOneLab];
            self.footView.payBtn.hidden = YES;
            self.footView.moreLab.frame = FRAME(self.footView.logoImage.right, SizeHeigh(20), kScreenW, SizeHeigh(15));
            self.footView.moreLab.text = @"退款将原路返回您的支付账户，请注意查收";
            break;
        default:
            titleStr = @"没设置状态";
            break;
    }
    if (rightBarStr.length > 0) {
        [self.rightBar setTitle:rightBarStr forState:UIControlStateNormal];
        self.rightBar.titleLabel.font = NormalFont(13);
        [self.rightBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        self.rightBar.hidden = YES;
    }
    self.titleLab.text = titleStr;
}

- (void)more:(UIButton *)sender {
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag = 101;
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            NSDictionary *dict = @{
                                   @"id" : self.model.id
                                   };
        
            [HttpRequest postPath:@"_order_refund_001" params:dict resultBlock:^(id responseObject, NSError *error) {
                if([error isEqual:[NSNull null]] || error == nil){
                    NSLog(@"success");
                }
                NSDictionary *datadic = responseObject;
                if ([datadic[@"error"] intValue] == 0) {
                    //   
                    [ConfigModel mbProgressHUD:@"申请退款成功" andView:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        OrderDetialViewController *vc = [[OrderDetialViewController alloc] init];
                        vc.OrderID = self.model.id;
                        vc.orderType = Order_Refunding;
                        vc.backHome = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                   
                }else {
                    NSString *str = datadic[@"message"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
        }
        
    }else if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            if (self.orderType == Order_Topay || self.orderType == Order_Distribution || self.orderType == Order_Distributioning) {
                [dic setValue:self.OrderID forKey:@"id"];
                [dic setValue:@"10" forKey:@"status"];
                [HttpRequest postPath:@"_change_order_status_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                    if([error isEqual:[NSNull null]] || error == nil){
                        NSLog(@"success");
                    }
                    NSDictionary *datadic = responseObject;
                    if ([datadic[@"error"] intValue] == 0) {
                        [ConfigModel mbProgressHUD:@"取消成功" andView:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
                        NSString *str = datadic[@"info"];
                        [ConfigModel mbProgressHUD:str andView:nil];
                    }
                }];
                
            }
        }
    }
    
}

- (void)createView {
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.footView];
}

- (void)createData {
    //   查询订单详情
    [ConfigModel showHud:self];
    if (self.OrderID.length == 0) {
        [ConfigModel mbProgressHUD:@"请传入Order_NO" andView:nil];
        return;
    }
    NSDictionary *dic =@{
                         @"id" : self.OrderID
                         };
    [OrderDataHelper orderDetailWithParameter:dic callBack:^(BOOL success, OrderDetailModel *model) {
        [ConfigModel hideHud: self];
        self.model = model;
        amont = [self.model.all_amount floatValue];
        postmoney = [self.model.postage floatValue];
        storeName = self.model.shopInfo.shopname;
        if ([self.model.type intValue] == 1) {
            post = YES;
        }else {
            post = NO;
        }
        if (self.orderType == Order_Distribution || self.orderType == Order_Invite) {
            
            [self.footView choiseType:FootOneLab];
    
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *DateTime = [formatter stringFromDate:date];
            
            __block int subTime = [self dateTimeDifferenceWithStartTime:self.model.create_time endTime:DateTime];
            int minute = (int)subTime /60%60;
    
            if (minute > 5) {
                //   超时
                self.footView.logoImage.hidden = YES;
                self.footView.moreLab.hidden = YES;
                self.footView.payBtn.hidden = YES;
            } else {
                //  未超时
                self.footView.moreLab.text = @"下单5分钟内支持申请退款";
                [self.footView changeBtnStyle:Gray];
                self.footView.logoImage.hidden = YES;
                [self.footView.payBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                
            }
        }
        
        self.goodsArr = (NSMutableArray *)self.model.goodlist;
        self.couponArr = (NSMutableArray *)self.model.couponList;
        [self.footInfoView updateinfo:self.model];
        if (self.orderType == Order_Topay) {
           [self changefootviewInfo];
        }
        [self.noUseTableView reloadData];
        
    }];
    
    //   修改订单状态
}

- (void)changefootviewInfo {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    __block int subTime = [self dateTimeDifferenceWithStartTime:self.model.create_time endTime:DateTime];
    int minute = (int)subTime /60%60;
    
        if (minute >= 15) {
            //   超时
            [self.footView choiseType:FootOneLab];
            self.footView.logoImage.hidden = YES;
            self.footView.moreLab.hidden =YES;
            [self.footView.payBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [self.footView changeBtnStyle:Yellow];
            return;
        }
    
    [self.view addSubview:self.timeLab];
   __block int time = 15*60 - subTime;
    _timer=[NSTimer eoc_scheduledTimerWithTimeInterval:1 block:
            ^{
                time --;
                if (subTime <= 0) {
                    [self.timeLab removeFromSuperview];
                    [self.footView choiseType:FootOneLab];
                    self.footView.logoImage.hidden = YES;
                    self.footView.moreLab.hidden =YES;
                    [self.footView.payBtn setTitle:@"再来一单" forState:UIControlStateNormal];
                    [self.footView changeBtnStyle:Yellow];
                    return;

                }else {
                    int second = (int)time %60;//秒
                    int minute = (int)time /60%60;
                 self.timeLab.text = [NSString stringWithFormat:@"   %.2d分%.2d秒内未支付，订单自动取消",  minute, second];

                }
            }
                                               repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: _timer  forMode: NSRunLoopCommonModes];
    
    
    float price;
    if (post && (amont > [self.model.warehouseInfo.freeprice floatValue])) {
        price = amont - couponcut;
    }else {
        price = amont + postmoney - couponcut;
    }
    self.footView.priceLab.text = [NSString stringWithFormat:@"￥%.2f", price];
    self.footView.balanceLab.text = [NSString stringWithFormat:@"账户余额：￥%.2f", [self.model.userAmount floatValue]];
    if ([self.model.userAmount floatValue]  < price) {
        [self.footView.payBtn setTitle:@"账户余额不足" forState:UIControlStateNormal];
        [self.footView changeBtnStyle:Gray];
        return;
    }
        [self.footView.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [self.footView changeBtnStyle:Red];
    topaymoney = price;
}

- (void)click{
    
    userModel = [[TMCache sharedCache] objectForKey:UserInfoModel];
    if (userModel.is_trade == 0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置支付密码，是否去设置？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        return;
    }
    
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
    ChangePayPasswordViewController *vc = [[ChangePayPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            if (self.orderType == Order_Invite ) {
                return 5;
            }
            return post ? 3 : 4;
        }
            break;
        case 1:{
            return self.goodsArr.count;
        }
            break;
        case 2:{
            if (!post) {
                _titleArr = @[@"商品金额",@"优惠券抵扣",payStr];
            }
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
                        if (self.orderType == Order_Invite) {
                            UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
                            for (UIView* subView in cell.contentView.subviews) {
                                [subView removeFromSuperview];
                            }
                            if (!cell) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                            }
                            cell.textLabel.font = SourceHanSansCNRegular(15);
                            cell.textLabel.text = @"取货码";
                            cell.detailTextLabel.text = self.model.code;
                            cell.accessoryType = UITableViewCellAccessoryNone;
                            cell.detailTextLabel.font = VerdanaBold(15);
                            cell.detailTextLabel.textColor = UIColorFromHex(0x3e7bb1);
                            return cell;
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
                            cell.accessoryType = UITableViewCellAccessoryNone;
                            cell.detailTextLabel.font = VerdanaBold(15);
                            return cell;
                        }
                    }
                }
                    break;
                case 2:{
                    
                    if (self.orderType == Order_Invite) {
                        UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
                        for (UIView* subView in cell.contentView.subviews) {
                            [subView removeFromSuperview];
                        }
                        if (!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                        }
                        cell.textLabel.font = SourceHanSansCNRegular(15);
                        cell.textLabel.text = @"取货时间";
                     NSString *str = [self.model.drawtime substringWithRange:NSMakeRange(5, 11)];
                        cell.detailTextLabel.text = str;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.detailTextLabel.font = VerdanaBold(15);
                        return cell;
                    }else {
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
                }
                    break;
                    
                case 3:{
                    if (self.orderType == Order_Invite) {
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
                    }else {
                        OrderStoreInfoTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
                        if (!cell) {
                            cell = [[OrderStoreInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                        }
                        [cell updateinfo:self.model.shopInfo];
                        return cell;
                    }
                }
                    break;
                    
                case 4:{
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
            }else if (indexPath.row == 1){
                cell.detailTextLabel.font = SourceHanSansCNMedium(15);
                cell.detailTextLabel.textColor = UIColorFromHex(0xff543a);
                str = [NSString stringWithFormat:@"￥%.2f", [self.model.coupon_money floatValue]];
            }else if(indexPath.row == 2){
                if (post) {
                    cell.detailTextLabel.font = SourceHanSansCNMedium(15);
                    cell.detailTextLabel.textColor = UIColorFromHex(0xff543a);
                    str = [NSString stringWithFormat:@"￥%.2f", [self.model.postage floatValue]];
                }else {
                   str = [NSString stringWithFormat:@"￥%.2f", [self.model.amount floatValue]];
                }
                
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
            if (self.orderType == Order_Invite) {
                if (indexPath.row == 4) {
                    return SizeHeigh(150);
                }else  {
                    return SizeHeigh(50);
                }
            }else {
                if (indexPath.row == 3) {
                    return SizeHeigh(150);
                }else if (indexPath.row == 2){
                    return post ? SizeHeigh(90) : SizeHeigh(50);
                }else {
                    return SizeHeigh(50);
                }
            }
        }
            break;
        case 1:{
            return SizeHeigh(160);
        }
            break;
        case 2:{
            
//            if (indexPath.row == 2 && !post) {
//                return 0;
//            }
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeigh(45))];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(10), SizeHeigh(15), kScreenW, SizeHeigh(20))];
        lab.text = storeName;
        lab.font = NormalFont(15);
        
        UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - SizeWidth(110), 7, SizeWidth(100), 30)];
        [btn setTitle:@"联系商家" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromHex(0x3e7bb1) forState:UIControlStateNormal];
        btn.titleLabel.font = NormalFont(13);
        [btn setImage:[UIImage imageNamed:@"icon_dh"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:CLButtonEdgeInsetsStyleTitleRight imageTitleSpace:4];
        [view addSubview:btn];
        
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeigh(44), kScreenW, SizeHeigh(1))];
        line.backgroundColor = RGBColor(239, 240, 241);
        
        [view addSubview:lab];
        [view addSubview:line];
        
        return view;
    }else{
        return nil;
    }
}
//   打电话
- (void)call {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.shopInfo.customphone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 ) {
        return SizeHeigh(45);
    }else {
        return 0.01;
    }
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
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.height, kScreenW, kScreenH - self.height- bottomHeight) style:UITableViewStylePlain];
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
    
        
        _footView = [[OrderFootView alloc] initWithFrame:FRAME(0, kScreenH - SizeHeigh(54), kScreenW, bottomHeight)];
        WeakSelf(weak);
//        _footView.topupBlock = ^{
//
//        };
        NSDictionary *dic;
        if (self.model.id.length > 0) {
           dic  = @{
                    @"id" : self.model.id
                   };
        }
        
        _footView.payBlock = ^{
            
            if ([_footView.payBtn.titleLabel.text isEqualToString:@"再来一单"]) {
                
                NSDictionary *dict = @{
                                       @"id" : self.model.id
                                       };
                
                [HttpRequest postPath:@"_order_002" params:dict resultBlock:^(id responseObject, NSError *error) {
                    NSLog(@"%@", responseObject);
                    if([error isEqual:[NSNull null]] || error == nil){
                        NSLog(@"success");
                    }
                    NSDictionary *datadic = responseObject;
                    if ([datadic[@"error"] intValue] == 0) {
                        NSDictionary *infoDic = datadic[@"info"];
                        NSString *idstr = infoDic[@"id"];
                        MakeOrderViewController *view = [[MakeOrderViewController alloc] init];
                        view.OrderID = idstr;
                        [weak.navigationController pushViewController:view animated:YES];
                    }else {
                        NSString *str = datadic[@"message"];
                        [ConfigModel mbProgressHUD:str andView:nil];
                    }
                }];
            }else if ([_footView.payBtn.titleLabel.text isEqualToString:@"账户余额不足"]){
                
            }else if ([_footView.payBtn.titleLabel.text isEqualToString:@"立即支付"]){
                [weak click];
            }else if ([_footView.payBtn.titleLabel.text isEqualToString:@"确认收货"]) {
                NSDictionary *di = @{
                                     @"id" : self.model.id,
                                     @"status" : @"1"
                                     };
                [HttpRequest postPath:@"_change_order_status_001" params:di resultBlock:^(id responseObject, NSError *error) {
                    if([error isEqual:[NSNull null]] || error == nil){
                        NSLog(@"success");
                    }
                    NSDictionary *datadic = responseObject;
                    if ([datadic[@"error"] intValue] == 0) {
                        [ConfigModel mbProgressHUD:@"确认收货成功" andView:nil];
                        [weak.navigationController popViewControllerAnimated:YES];
                    }else {
                        NSString *str = datadic[@"info"];
                        [ConfigModel mbProgressHUD:str andView:nil];
                    }
                }];
            }else if ([_footView.payBtn.titleLabel.text isEqualToString:@"申请退款"]) {
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"申请退款需要商家审核\n确定申请退款吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alter.tag = 100;
                [alter show];
                
            }
                
        };
    }
    return _footView;
}

- (NSTimeInterval )dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 *3600)%3600;
    int day = (int)value / (24 *3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house !=0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day==0 && house==0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    return value;
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
        _titleArr = @[@"商品金额",@"优惠券抵扣",@"配送费",payStr];
    }
    return _titleArr;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:FRAME(0, kScreenH - SizeHeigh(70), kScreenW, SizeHeigh(20))];
        _timeLab.backgroundColor = RGBColorAlpha(239, 240, 241, 0.7);
        _timeLab.textColor = UIColorFromHex(0x999999);
        _timeLab.font = NormalFont(13);
    }
    return _timeLab;
}

@end

