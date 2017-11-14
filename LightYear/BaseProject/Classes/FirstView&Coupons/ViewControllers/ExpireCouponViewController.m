//
//  ExpireCouponViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ExpireCouponViewController.h"
#import "CouponDefaultCell.h"
#import "couponDetailsCell.h"
#import "WMTableView.h"
#import "CouponListModel.h"

@interface ExpireCouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;
@property (nonatomic, strong) UIImageView *defImageV;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger lastSelectRow;

@end

@implementation ExpireCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"过期券";
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
    _pageNo = 1;
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

#pragma mark - Service
- (void)syncWithRequest {
    [ConfigModel showHud:self];
    NSDictionary *dic = @{
                          @"type":@"3",
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
        [cell fillWithModel:info WithExpire:YES];
        return cell;
    } else {
        static NSString *identifier = @"CouponDefaultCell";
        CouponDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CouponDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell fillWithModel:info WithExpire:YES];
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
        _tableV = [[WMTableView alloc] initWithFrame:CGRectMake( 0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
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
