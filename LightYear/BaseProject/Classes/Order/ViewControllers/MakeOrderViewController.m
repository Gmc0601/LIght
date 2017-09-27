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
#import "OrderStoreInfoTableViewCell.h"
#import "CouponViewController.h"

@interface MakeOrderViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL post; //  配送
    NSString *getTime, *storeName;  //  自取时间   商店名称
}

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *goodsArr;
@property (nonatomic, retain) NSArray *titleArr;
@property (nonatomic, retain) OrderFootView *footView;
@property (nonatomic, retain) UIButton *postBtn, *getBtn;   //  配送 自取

@end

@implementation MakeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetFather];
    
    [self createview];
    
}


- (void)resetFather {
    post = YES;
    storeName = @"光年浙工商店";
    self.titleLab.text = @"确认订单";
    self.rightBar.hidden = YES;
}

- (void)createview {
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.footView];
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
                        cell.detailTextLabel.text = @"未选择";
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
                         [cell update:Order_withoutAddress];
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
                str = @"1张可用";
                cell.detailTextLabel.font = SourceHanSansCNMedium(12);
                cell.detailTextLabel.textColor = UIColorFromHex(0xff543a);
            }else if (indexPath.row == 1){
                str = @"￥12.80";
            }else {
                str = @"￥12.80";
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
    if (indexPath.section == 2 && indexPath.row == 0) {
        CouponViewController *view = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }
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
        _footView.topupBlock = ^{
            
        };
        _footView.payBlock = ^{
            
        };
    }
    return _footView;
}

- (NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray new];
    }
    return _goodsArr;
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
        post = YES;
    }else {
        post = NO;
    }
    [self changePostType];
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
