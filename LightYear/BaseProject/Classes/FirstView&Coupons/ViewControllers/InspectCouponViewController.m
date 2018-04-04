//
//  InspectCouponViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "InspectCouponViewController.h"
#import "CouponDefaultCell.h"
#import "couponDetailsCell.h"
#import "WMTableView.h"
#import "ExpireCouponViewController.h"

@interface InspectCouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;
@property (nonatomic, strong) UIImageView *defImageV;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, assign) NSInteger lastSelectRow;

@end

@implementation InspectCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"优惠券";
    [self initRightBar];
    @weakify(self)
    [self.tableV addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self insertRowAtBottom];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rightBar removeFromSuperview];
    _dataArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    _lastSelectRow = -1;
    [self syncWithRequest];
}

- (void)insertRowAtBottom {
    @weakify(self)
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        @strongify(self)
//        [self syncWithRequest];
        self.tableV.showsInfiniteScrolling = NO;
        [self.tableV.infiniteScrollingView stopAnimating];
    });
}

- (void)more:(UIButton *)sender {
    ExpireCouponViewController *expireVC = [[ExpireCouponViewController alloc] init];
    [self.navigationController pushViewController:expireVC animated:YES];
}

- (void)initRightBar {
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake( kScreenW - 10 - 40, self.top, 40, 30)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitle:@"过期券" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftBtn addTarget:self action:@selector(expireCoupon) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:leftBtn];
}

- (void)expireCoupon {
    ExpireCouponViewController *expireVC = [[ExpireCouponViewController alloc] init];
    [self.navigationController pushViewController:expireVC animated:YES];
}

#pragma mark - Service
- (void)syncWithRequest {
    [ConfigModel showHud:self];
    NSDictionary *dic = @{
                          @"type":@"1",
                          };
    [HttpRequest postPath:couponListURL params:dic resultBlock:^(id responseObject, NSError *error) {
        
        CouponListModel * model = [[CouponListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            [_dataArray addObjectsFromArray:model.info];
            if (_dataArray.count ==0 && ![self.tableV.subviews containsObject:self.defImageV]) {
                [self.tableV addSubview:self.defImageV];
            }
            for (int i = 0; i<_dataArray.count; i++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
                [_selectArray addObject:dic];
            }
            [self.tableV reloadData];
        }else{
            if (![self.tableV.subviews containsObject:self.defImageV]) {
                [self.tableV addSubview:self.defImageV];
            }
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = _selectArray[indexPath.row];
    NSString *str = [dic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    if ([str isEqualToString:@"YES"]) {
        return SizeHeigh(213);
    } else {
        return SizeHeigh(84);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = _selectArray[indexPath.row];
    NSString *str = [dic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    CouponInfo *info = _dataArray[indexPath.row];
    if ([str isEqualToString:@"YES"]) {
        static NSString *identifier = @"couponDetailsCell";
        couponDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[couponDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell fillWithModel:info WithExpire:NO];
        return cell;
    } else {
        static NSString *identifier = @"CouponDefaultCell";
        CouponDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CouponDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell fillWithModel:info WithExpire:NO];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_lastSelectRow == indexPath.row) {
        NSMutableDictionary *lastDic = _selectArray[_lastSelectRow];
        [lastDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",_lastSelectRow]];
        [_selectArray replaceObjectAtIndex:_lastSelectRow withObject:lastDic];
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_lastSelectRow inSection:0];
        [self.tableV reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationNone];
        _lastSelectRow = -1;
        return;
    }
    if (_lastSelectRow != -1) {
        NSMutableDictionary *lastDic = _selectArray[_lastSelectRow];
        [lastDic setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",_lastSelectRow]];
        [_selectArray replaceObjectAtIndex:_lastSelectRow withObject:lastDic];
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_lastSelectRow inSection:0];
        [self.tableV reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    NSMutableDictionary *dic = _selectArray[indexPath.row];
    NSString *str = [dic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    if ([str isEqualToString:@"NO"]) {
        [dic setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        [_selectArray replaceObjectAtIndex:indexPath.row withObject:dic];
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [self.tableV reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
        _lastSelectRow = indexPath.row;
    }
}

#pragma mark - lazyLoad
- (WMTableView *)tableV
{
    if (!_tableV) {
        _tableV = [[WMTableView alloc] initWithFrame:CGRectMake( 0, self.height, kScreenW, kScreenH-self.height) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableV];
    }
    return _tableV;
}

- (UIImageView *)defImageV {
    if (!_defImageV) {
        _defImageV = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, SizeWidth(76), SizeHeigh(45))];
        _defImageV.center = CGPointMake(self.tableV.width/2, self.tableV.height/2);
        _defImageV.image = [UIImage imageNamed:@"icon_couponqx"];
    }
    return _defImageV;
}

@end
