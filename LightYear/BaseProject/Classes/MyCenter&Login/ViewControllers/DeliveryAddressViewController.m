//
//  DeliveryAddressViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "DeliveryAddressViewController.h"
#import "DeilveryAddressTableViewCell.h"
#import "EditDeliveryAddressViewController.h"
@interface DeliveryAddressViewController ()<UITableViewDelegate,UITableViewDataSource,DeilveryAddressTableViewCellDelegate>
{
    UITableView * myTableView;
    UIButton * bottomButton;
    UILabel * normalLabel;
    NSMutableArray * dataArray;
}
@end

@implementation DeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"收货地址";
    self.rightBar.hidden = YES;
    dataArray = [NSMutableArray array];
    [self getData];
    [self createBaseView];
}

- (void)getData{
    [ConfigModel showHud:self];
    [HttpRequest postPath:ReceiptListURL params:nil resultBlock:^(id responseObject, NSError *error) {
        DeliveryAddressModel * model = [[DeliveryAddressModel alloc] initWithDictionary:responseObject error:nil];
        [dataArray removeAllObjects];
        if (model.error == 0) {
            [dataArray addObjectsFromArray:model.info];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [self changeEmptyView];
        [ConfigModel hideHud:self];
        [myTableView reloadData];
    }];
}

- (void)createBaseView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.estimatedRowHeight = 50.0f;
    myTableView.rowHeight = UITableViewAutomaticDimension;
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView registerClass:[DeilveryAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(self.height);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    normalLabel = [UILabel new];
    normalLabel.text = @"您还没有收货地址";
    normalLabel.hidden = YES;
    normalLabel.font = [UIFont systemFontOfSize:16];
    normalLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:normalLabel];
    [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
    }];
    
    bottomButton = [UIButton new];
    bottomButton.hidden = YES;
    bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    bottomButton.backgroundColor = UIColorFromHex(0x3e7bb1);
    bottomButton.layer.cornerRadius = 4.0f;
    bottomButton.layer.masksToBounds = YES;
    [bottomButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(addDeliveryAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(normalLabel.mas_bottom).offset(20);
        make.height.mas_offset(40);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
}

- (void)changeEmptyView{
    if (dataArray.count == 0) {
        myTableView.hidden = YES;
        normalLabel.hidden = NO;
        bottomButton.hidden = NO;
    }else{
        myTableView.hidden = NO;
        normalLabel.hidden = YES;
        bottomButton.hidden = YES;
    }
}
//新建收货地址
- (void)addDeliveryAddressAction:(UIButton *)button{
    EditDeliveryAddressViewController * editAddressVC = [[EditDeliveryAddressViewController alloc] init];
    [editAddressVC setFinishBlock:^(DeliveryAddressInfo *model) {
        [self getData];
//        if (model.isdefault == 1) {
//            for (DeliveryAddressInfo * info in dataArray) {
//                info.isdefault = 0;
//            }
//            [dataArray insertObject:model atIndex:0];
//        }else{
//            [dataArray addObject:model];
//        }
//        [myTableView reloadData];
//        [self changeEmptyView];
    }];
    [self.navigationController pushViewController:editAddressVC animated:YES];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = UIColorFromHex(0xcccccc);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [UIView new];
    if (section < dataArray.count-1) {
        UIView * lineView = [UIView new];
        lineView.backgroundColor = UIColorFromHex(0xcccccc);
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.right.mas_offset(-15);
            make.top.bottom.mas_offset(1);
        }];
    }else{
        UIButton * tableBottomButton = [UIButton new];
        tableBottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        tableBottomButton.backgroundColor = UIColorFromHex(0x3e7bb1);
        tableBottomButton.layer.cornerRadius = 4.0f;
        tableBottomButton.layer.masksToBounds = YES;
        [tableBottomButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
        [tableBottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tableBottomButton addTarget:self action:@selector(addDeliveryAddressAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:tableBottomButton];
        [tableBottomButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.height.mas_offset(40);
            make.left.mas_offset(20);
            make.right.mas_offset(-20);
        }];
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < dataArray.count-1) {
        return 1;
    }else{
        return 60;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeilveryAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[DeilveryAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = dataArray[indexPath.section];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//编辑收货地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.getback) {
        if (self.addressBlock) {
            DeliveryAddressInfo * detailModel = [[DeliveryAddressInfo alloc] init];
            detailModel = dataArray[indexPath.section];
            self.addressBlock(detailModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    DeliveryAddressInfo * detailModel = [[DeliveryAddressInfo alloc] init];
    detailModel = dataArray[indexPath.section];
    EditDeliveryAddressViewController * editAddressVC = [[EditDeliveryAddressViewController alloc] init];
    editAddressVC.addressModel = detailModel;
    [editAddressVC setFinishBlock:^(DeliveryAddressInfo * model) {
        if (model == nil) {
            [dataArray removeObject:detailModel];
            [myTableView reloadData];
            [self changeEmptyView];
        }else{
            [self getData];
//            if (model.isdefault == 1) {
//                [dataArray removeObject:detailModel];
//                for (DeliveryAddressInfo * info in dataArray) {
//                    info.isdefault = 0;
//                }
//                [dataArray insertObject:model atIndex:0];
//            }else{
//                [dataArray replaceObjectAtIndex:indexPath.section withObject:model];
//            }
        }
    }];
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

#pragma mark DeilveryAddressTableViewCellDelegate
- (void)didDeilveryAddressTableViewCellEditButton:(UIButton *)button{
//    CGPoint point = button.center;
//    point = [myTableView convertPoint:point fromView:button.superview];
//    NSIndexPath* indexPath = [myTableView indexPathForRowAtPoint:point];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
