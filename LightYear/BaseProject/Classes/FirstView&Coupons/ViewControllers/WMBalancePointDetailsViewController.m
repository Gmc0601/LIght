//
//  WMBalancePointDetailsViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "WMBalancePointDetailsViewController.h"
#import "balancePointDetailsCell.h"
#import "WMSegmentView.h"
#import "WMScrollView.h"
#import "WMTableView.h"
#import "integralListModel.h"
#import "tradeListModel.h"

@interface WMBalancePointDetailsViewController () <WMSegmentViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMSegmentView *segmentView;
@property (nonatomic, strong) WMScrollView *scrollView;
@property (nonatomic, strong) WMTableView *balanceTableV;
@property (nonatomic, strong) WMTableView *pointTableV;
@property (nonatomic, assign) NSInteger balancePageNo;
@property (nonatomic, assign) NSInteger pointPageNo;
@property (nonatomic, strong) NSMutableArray *balanceArray;
@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic, assign) NSInteger segmentCurrentIndex;

@end

@implementation WMBalancePointDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubView];
    
    @weakify(self)
    [self.balanceTableV addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self insertRowBalanceAtBottom];
    }];
    [self.pointTableV addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self insertRowPointAtBottom];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _segmentView.currentIndex = _segmentCurrentIndex;
    [self.rightBar removeFromSuperview];
    _balanceArray = [NSMutableArray array];
    _pointArray = [NSMutableArray array];
    self.pointPageNo = 1;
    self.balancePageNo = 1;
    [self syncWithBalanceRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _segmentCurrentIndex = _segmentView.currentIndex;
}

- (void)insertRowBalanceAtBottom {
    @weakify(self)
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        @strongify(self)
        [self syncWithBalanceRequest];
//        self.balanceTableV.showsInfiniteScrolling = NO;
        [self.balanceTableV.infiniteScrollingView stopAnimating];
    });
}

- (void)insertRowPointAtBottom {
    @weakify(self)
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        @strongify(self)
        [self syncWithPointRequest];
//        self.pointTableV.showsInfiniteScrolling = NO;
        [self.pointTableV.infiniteScrollingView stopAnimating];
    });
}

#pragma mark - Service
- (void)syncWithBalanceRequest {
    [ConfigModel showHud:self];
    if (self.balancePageNo == 1 && _balanceArray.count>0) {
        [_balanceArray removeAllObjects];
    }
    NSDictionary *dic = @{
                          @"page":[NSString stringWithFormat:@"%ld",self.balancePageNo],
                          @"size":@"10",
                          };
    [HttpRequest postPath:tradeListURL params:dic resultBlock:^(id responseObject, NSError *error) {
        
        tradeListModel * model = [[tradeListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            if (self.balancePageNo>1) {
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:model.info];
                if (array.count>0) {
                    [_balanceArray addObjectsFromArray:array];
                    self.balancePageNo ++;
                } else {
                    
                }
            } else {
                [_balanceArray addObjectsFromArray:model.info];
                self.balancePageNo ++;
            }
            [self.balanceTableV reloadData];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
        [self syncWithPointRequest];
    }];
}

- (void)syncWithPointRequest {
    [ConfigModel showHud:self];
    if (self.pointPageNo == 1 && _pointArray.count>0) {
        [_pointArray removeAllObjects];
    }
    NSDictionary *dic = @{
                          @"page":[NSString stringWithFormat:@"%ld",self.pointPageNo],
                          @"size":@"10",
                          };
    [HttpRequest postPath:integralListURL params:dic resultBlock:^(id responseObject, NSError *error) {
        integralListModel * model = [[integralListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            if (self.pointPageNo>1) {
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:model.info];
                if (array.count>0) {
                    [_pointArray addObjectsFromArray:array];
                    self.pointPageNo ++;
                } else {
                    
                }
            } else {
                [_pointArray addObjectsFromArray:model.info];
                self.pointPageNo ++;
            }
            [self.pointTableV reloadData];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
    }];
}

#pragma mark - WMTableViewDelegate && UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _balanceTableV) {
        return _balanceArray.count;
    } else {
        return _pointArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SizeHeigh(71);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"balancePointDetailsCell";
    balancePointDetailsCell *detailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!detailCell) {
        detailCell = [[balancePointDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == _balanceTableV) {
        tradeListInfo *info = _balanceArray[indexPath.row];
        [detailCell fillWithBalance:info];
    } else {
        integralListInfo *info = _pointArray[indexPath.row];
        [detailCell fillWithPoint:info];
    }
    return detailCell;
}

#pragma mark - WMSegmentViewDelegate

- (void)segment:(WMSegmentView *)segment didSelectAtIndex:(NSInteger)index;
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.width*index, 0) animated:YES];
    
    if (index == 0) {
//        [self syncWithBalanceRequest];
    } else {
//        [self syncWithPointRequest];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView) {
        int index = scrollView.contentOffset.x / _scrollView.width;
        [_segmentView setSelectedBtn:index];
    }
}

- (void)setupSubView
{
    [self.navigationView addSubview:self.segmentView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.balanceTableV];
    [self.scrollView addSubview:self.pointTableV];
}

- (WMSegmentView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[WMSegmentView alloc] initWithFrame:CGRectMake( 0, 0, SizeWidth(185), SizeHeigh(35))];
        _segmentView.centerX = self.navigationView.centerX;
        _segmentView.centerY = self.navigationView.centerY;
        _segmentView.items = @[@"余额明细",@"积分明细"];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (WMScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[WMScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64)];
        _scrollView.contentSize = CGSizeMake(kScreenW*2, 0);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (WMTableView *)balanceTableV
{
    if (!_balanceTableV) {
        _balanceTableV = [[WMTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, _scrollView.height) style:UITableViewStylePlain];
        _balanceTableV.delegate = self;
        _balanceTableV.dataSource = self;
        _balanceTableV.backgroundColor = [UIColor clearColor];
        _balanceTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _balanceTableV;
}

- (WMTableView *)pointTableV
{
    if (!_pointTableV) {
        _pointTableV = [[WMTableView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, _scrollView.height) style:UITableViewStylePlain];
        _pointTableV.delegate = self;
        _pointTableV.dataSource = self;
        _pointTableV.backgroundColor = [UIColor clearColor];
        _pointTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _pointTableV;
}



@end
