//
//  ChoiceDeliveryAddressViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChoiceDeliveryAddressViewController.h"

#import "ChoiceDeliveryAddressTableViewCell.h"
#import "BaseTextField.h"

#define CELL_HEIGHT                     55.f

@interface ChoiceDeliveryAddressViewController ()<BaseTextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
{
    BaseTextField * searchField;
    UIButton * searchButton;
    UITableView * myTableView;
    NSMutableArray * dataArray;
    // 选中的IndexPath
    NSIndexPath *_selectedIndexPath;
    // 搜索API
    AMapSearchAPI *_searchAPI;
    //定位
    AMapLocationManager * _locationManager;
    //当前地理位置
    CLLocation *_currentLocation;
    //当前地址详情
    AMapLocationReGeocode * _currentRegeocode;
    // 搜索页数
    NSInteger searchPage;
    // 搜索页数
    NSInteger textSearchPage;
    // 搜索结果数组
    NSMutableArray * searchResultArray;
    //开始搜索
    BOOL isSearchData;
}
@end

@implementation ChoiceDeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"选择收货地址";
    
    searchPage = 1;
    textSearchPage = 1;
    
    dataArray = [NSMutableArray array];
    searchResultArray = [NSMutableArray array];
    
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    [self getLocationData];
    [self createBaseView];
}
- (void)getLocationData{
    _locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    _locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    _locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        _currentLocation = location;
        _currentRegeocode = regeocode;
        
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [self searchReGeocodeWithAMapGeoPoint:point];
        [self searchPoiByAMapGeoPoint:point];

    }];
}
- (void)createBaseView{
    UIView * searchView = [UIView new];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(50);
    }];
    
    UIImageView * searchImage = [UIImageView new];
    searchImage.image = [UIImage imageNamed:@"icon_nav_ss"];
    [searchView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.centerY.mas_offset(0);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    searchButton = [UIButton new];
    searchButton.layer.cornerRadius = 3.0f;
    searchButton.layer.masksToBounds = YES;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton setBackgroundColor:UIColorFromHex(0x3e7bb1)];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.centerY.mas_offset(0);
        make.size.mas_offset(CGSizeMake(60, 40));
    }];
    
    searchField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@"搜索收货地址" isBorder:NO];
    searchField.keyboardType = UIKeyboardTypeDefault;
    searchField.textDelegate = self;
    searchField.font = [UIFont systemFontOfSize:16];
    [searchView addSubview:searchField];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchImage.mas_right).offset(0);
        make.right.mas_equalTo(searchButton.mas_left).offset(-10);
        make.centerY.mas_offset(0);
        make.height.mas_offset(40);
    }];
    
    UILabel * lineLabel = [UILabel new];
    lineLabel.backgroundColor = UIColorFromHex(0xcccccc);
    [searchView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-0.5);
        make.left.right.mas_offset(0);
        make.height.mas_offset(0.5);
    }];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.estimatedRowHeight = 50.0f;
    myTableView.rowHeight = UITableViewAutomaticDimension;
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView registerClass:[ChoiceDeliveryAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(0);
        make.left.right.bottom.mas_offset(0);
    }];
}
#pragma mark BaseTextFieldDelegate
- (void)textFieldTextChange:(UITextField *)textField{
    if (textField.text.length == 0) {
        isSearchData = NO;
        [myTableView reloadData];
    }
}
//搜索按钮点击事件
- (void)searchButtonAction:(UIButton *)button{
    [ConfigModel showHud:self];
    isSearchData = YES;
    [searchResultArray removeAllObjects];
    //POI关键字搜索
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = searchField.text;
    request.city = _currentRegeocode.city;
    request.cityLimit = YES;
    request.page = textSearchPage;
    [_searchAPI AMapPOIKeywordsSearch:request];
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
    UIView * lineView = [UIView new];
    lineView.backgroundColor = UIColorFromHex(0xcccccc);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.bottom.mas_offset(1);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isSearchData) {
        return searchResultArray.count;
    }
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoiceDeliveryAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[ChoiceDeliveryAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    AMapPOI * point;
    if (isSearchData){
        point = searchResultArray[indexPath.section];
    }else{
        point = dataArray[indexPath.section];
    }
    cell.pointModel = point;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    AMapPOI * point;
    if (isSearchData){
        point = searchResultArray[indexPath.section];
    }else{
        point = dataArray[indexPath.section];
    }
    if (self.finishBlock) {
        self.finishBlock(point);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)loadMorePOI
{
    searchPage++;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    [self searchPoiByAMapGeoPoint:point];
}
// 搜索中心点坐标周围的POI-AMapGeoPoint
- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location
{
    [ConfigModel showHud:self];
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = location;
    // 搜索半径
    request.radius = 1000;
    // 搜索结果排序
    request.sortrule = 0;
    // 当前页数
    request.page = searchPage;
    [_searchAPI AMapPOIAroundSearch:request];
}

// 搜索逆向地理编码-AMapGeoPoint
- (void)searchReGeocodeWithAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = location;
    // 返回扩展信息
    regeo.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:regeo];
}
#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    // 刷新POI后默认第一行为打勾状态
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

//    // 判断搜索结果是否来自于下拉刷新
//    if (isFromMoreLoadRequest) {
//        isFromMoreLoadRequest = NO;
//    }
//    else{
//        //保留数组第一行数据
//        if (_searchPoiArray.count > 1) {
//            [_searchPoiArray removeObjectsInRange:NSMakeRange(1, _searchPoiArray.count-1)];
//        }
//    }
//    
//    // 刷新完成,没有数据时不显示footer
//    if (response.pois.count == 0) {
//        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
//    }
//    else {
//        _tableView.mj_footer.state = MJRefreshStateIdle;
//    }
    
    // 添加数据并刷新TableView
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        if (isSearchData) {
            [searchResultArray addObject:obj];
        }else{
            [dataArray addObject:obj];
        }
    }];
    [myTableView reloadData];
    [ConfigModel hideHud:self];
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
