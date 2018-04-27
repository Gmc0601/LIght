//
//  OrderViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderAlterView.h"
#import "MakeOrderViewController.h"
#import "OrderDetialViewController.h"
#import "OrderDataHelper.h"
#import "OrderModel.h"
#import "TBRefresh.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int page;
}

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *dataArr;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self resetFather];
    
    [self createView];
    
    [self createData];
}

#pragma mark - Action  ---> NeedReset in son
- (void)back:(UIButton *)sender {
    if (self.backHome) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)resetFather {
    page = 1;
    self.rightBar.hidden = YES;
    self.titleLab.text = @"订单";
    self.titleLab.font = SourceHanSansCNMedium(17);
    self.titleLab.textColor = UIColorFromHex(0x333333);
}

- (void)createView {
    
    [self.view addSubview:self.noUseTableView];
    
}
- (void)createData {
    [ConfigModel showHud:self];
   ////999全部订单2待支付4配送中3待配送5待自取6退款退货
    NSDictionary *dic;
    switch (self.listType) {
        case OrderList_All:{//  全部订单
            dic = @{
                    @"status" : @"999",
                    @"page" : @(page),
                    @"size" : @"15",
                    };
        }
            break;
        case OrderList_Distribution:{//  待配送
            dic = @{
                    @"status" : @"3",
                    @"page" : @(page),
                    @"size" : @"15",
                    };
        }
            break;
        case OrderList_Invite:{//  待自取
            dic = @{
                    @"status" : @"5",
                    @"page" : @(page),
                    @"size" : @"15",
                    };
        }
            break;
        case OrderList_Distributioning:{//  配送中
            dic = @{
                    @"status" : @"4",
                    @"page" : @(page),
                    @"size" : @"15",
                    };
        }
            break;
        case OrderList_Topay:{ //  待支付
            dic = @{
                    @"status" : @"2",
                    @"page" : @(page),
                    @"size" : @"15",
                    };
        }
            break;
            
        default:
            break;
    }
    
    WeakSelf(weakself);
    [OrderDataHelper orderListWithparameter:dic callBack:^(BOOL success, NSArray *modelArr) {
        [ConfigModel hideHud:self];
        [weakself.noUseTableView.header endHeadRefresh];
        [weakself.noUseTableView.footer endFooterRefreshing];
        if (success) {
            if (modelArr.count == 15) {
                page ++;
            }
            [weakself.dataArr addObjectsFromArray:modelArr];
            [weakself.noUseTableView reloadData];
        }else {
            [ConfigModel mbProgressHUD:@"数据加载失败请稍后重试~" andView:nil];
        }
    }];
}

#pragma mark - UITableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellId = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    OrderTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    OrderModel *model = [[OrderModel alloc] init];
    if (self.dataArr.count > 0) {
        model = self.dataArr[indexPath.row];
    }
    
    [cell changeCellType:[self changStatus:model]];
    [cell updatcell:model];
    
    FoodViewType type;
    if (model.goodlist.count == 1) {
        type = Foods_One;
    }else {
        type = Foods_More;
    }
    
    [cell changeFoodviewType:type];
    __block  OrderCellType clicktype = [self changStatus:model];
    WeakSelf(weakself);
    cell.BtnClickBlock = ^{
        if (clicktype == Order_Invite) {
            OrderAlterView *view = [[OrderAlterView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
            [view update:model];
            view.callBtnBlock = ^{
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.shopInfo.customphone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            };
            [view pop];
        }
        if (clicktype == Order_Topay ) {
            MakeOrderViewController *view = [[MakeOrderViewController alloc] init];
            view.OrderID = model.id;
            [weakself.navigationController pushViewController:view animated:YES];
        }
        if (clicktype == Order_Cancle  || clicktype == Order_Finished) {
            NSDictionary *dic = @{
                                  @"id" : model.id
                                  };
            [HttpRequest postPath:@"_order_002" params:dic resultBlock:^(id responseObject, NSError *error) {
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
                    [weakself.navigationController pushViewController:view animated:YES];
                    
                }else {
                    NSString *str = datadic[@"info"];
                    [ConfigModel mbProgressHUD:str andView:nil];
                }
            }];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//  转换状态
- (OrderCellType)changStatus:(OrderModel *)model {
    OrderCellType type;
    int state = [model.status intValue];
    //2待支付3待配送/待自取4配送中1已完成10订单取消6申请退款
    switch (state) {
        case 2:
            type = Ordercell_Topay;
            break;
        case 3:
            if ([model.status_name isEqualToString:@"待配送"]) {
                type =  Ordercell_Distribution;
            }else {
                type = Ordercell_Invite;
            }
            break;
        case 4:
            type = Ordercell_Distributioning;
            break;
        case 1:
            type = Ordercell_Finished;
            break;
        case 10:
            type = Ordercell_Cancle;
            break;
        case 6:
            if ([model.isrefund intValue] == 1) {
                type = Ordercell_Refunding;
            }else if ([model.isrefund intValue] == 2){
                type = Ordercell_Refundsuccess;
            }else {
                type = Cellwrong;
            }
            break;
            
        default:
            type = Cellwrong;
            break;
    }
    return type;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SizeHeigh(230);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetialViewController *vc = [[OrderDetialViewController alloc] init];
    OrderModel *model = [[OrderModel alloc] init];
    model = self.dataArr[indexPath.row];
    vc.OrderID = model.id;
    vc.orderType = (OrderDetailType)[self changStatus:model];
    [self .navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.height, kScreenW, kScreenH - self.height) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        [_noUseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        WeakSelf(weak);
        [_noUseTableView addRefreshFootWithBlock:^{
            [weak createData];
        }];
        
        [_noUseTableView addRefreshHeaderWithBlock:^{
            page = 1;
            [weak.dataArr removeAllObjects];
            [weak createData];
        }];
        
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            view;
        });
    }
    return _noUseTableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}


@end
