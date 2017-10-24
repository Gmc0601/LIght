//
//  UserInfoViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ChangeUserInfoViewController.h"
#import "DateView.h"
#import "UserInfoPicketView.h"
@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DateViewDelegate,UserInfoPicketViewDelegate>
{
    UITableView * myTableView;
    NSMutableArray * dataArray;
    DateView * dateView;
    UserInfoPicketView * picketView;
    UserInfo * userModel;
}
@property (nonatomic ,copy) void(^ChangeUserInfoBlock) (int status);

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"个人资料";
    dataArray = [NSMutableArray arrayWithObjects:@"头像",@"姓名",@"性别",@"生日", @"钱包支付密码",nil];
    [self createBaseView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    userModel = [[TMCache sharedCache] objectForKey:UserInfoModel];
    [myTableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[TMCache sharedCache] setObject:userModel forKey:UserInfoModel];
}
- (void)createBaseView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.bottom.mas_offset(0);
    }];
}
- (void)changeUserInfoWithKey:(NSString *)key Value:(NSString *)value{
    [ConfigModel showHud:self];
    NSDictionary * params = @{key:value};
    [HttpRequest postPath:ChangeUserInfo params:params resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        BaseModel * baseModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        [ConfigModel hideHud:self];
        if (baseModel.error == 0) {
            if ([key isEqualToString:@"sex"]) {
                userModel.sex = [value integerValue];
            }else if ([key isEqualToString:@"birthday"]){
                userModel.birthday = value;
            }else if ([key isEqualToString:@"nickname"]){
                NSMutableString * mutableStr = [[NSMutableString alloc] initWithString:value];
                NSRange range = [mutableStr rangeOfString:@","];
                [mutableStr deleteCharactersInRange:range];
                userModel.nickname = mutableStr;
            }else if ([key isEqualToString:@"avatar_id"]){
                userModel.avatar_url = responseObject[@"info"];
                if (self.finishBlock) {
                    self.finishBlock(userModel.avatar_url);
                }
            }
            [myTableView reloadData];
            [ConfigModel mbProgressHUD:@"修改成功" andView:nil];
        }else {
            [ConfigModel mbProgressHUD:@"修改失败" andView:nil];
        }
    }];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
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
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    for(UIView * view in [cell.textLabel subviews]){
        [view removeFromSuperview];
    }
    cell.textLabel.text = dataArray[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        UIImageView * headImage = [UIImageView new];
        headImage.layer.cornerRadius = 20.0f;
        headImage.layer.masksToBounds = YES;
        [headImage sd_setImageWithURL:[NSURL URLWithString:userModel.avatar_url] placeholderImage:[UIImage imageNamed:@"icon_grzl_tx"]];
        [cell.textLabel addSubview:headImage];
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(0);
            make.centerY.mas_offset(0);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
    }else{
        UILabel * detailLabel = [UILabel new];
        detailLabel.text = @"未设置";
        detailLabel.textColor = UIColorFromHex(0x999999);
        detailLabel.font = [UIFont systemFontOfSize:14];
        [cell.textLabel addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(0);
            make.centerY.mas_offset(0);
        }];
        if (indexPath.section == 1 && userModel.username.length > 0) {
            detailLabel.text = userModel.nickname;
        }else if (indexPath.section == 2 && userModel.sex > 0){
            if (userModel.sex == 1) {
                detailLabel.text = @"男";
            }else{
                detailLabel.text = @"女";
            }
        }else if (indexPath.section == 3 && userModel.birthday.length > 0){
            detailLabel.text = userModel.birthday;
        }else if (indexPath.section == 4 && userModel.is_trade == 1){
            detailLabel.text = @"修改支付密码";
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //头像
        NSMutableArray * array = [NSMutableArray arrayWithObjects:@"拍照",@"相册", nil];
        picketView = [[UserInfoPicketView alloc] init];
        picketView.delegate = self;
        picketView.tag = 10;
        picketView.picketTitle = @"选择照片来源";
        picketView.pickViewTextArray = array;
        picketView.picketType = PicketViewTypeDefault;
        [self.view addSubview:picketView];
    }else if (indexPath.section == 1){
        //姓名
        ChangeUserInfoViewController * changeUserInfoVC = [[ChangeUserInfoViewController alloc] init];
        changeUserInfoVC.type = UserInfoTypeName;
        [changeUserInfoVC setFinishBlock:^(NSString * name){
            [self changeUserInfoWithKey:@"nickname" Value:name];
        }];
        [self.navigationController pushViewController:changeUserInfoVC animated:YES];
    }else if (indexPath.section == 2){
        //性别
        NSMutableArray * array = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
        picketView = [[UserInfoPicketView alloc] init];
        picketView.delegate = self;
        picketView.tag = 20;
        picketView.picketTitle = @"选择性别";
        picketView.pickViewTextArray = array;
        picketView.picketType = PicketViewTypeDefault;
        [self.view addSubview:picketView];
    }else if (indexPath.section == 3){
        //生日
        if (!dateView) {
            dateView = [[[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil] lastObject];
            dateView.frame = CGRectMake(0, kScreenH, kScreenW, 260);
            dateView.delegate = self;
            dateView.datePicker.datePickerMode = UIDatePickerModeDate;
            [self.view addSubview:dateView];
            [self showDatePickerView];
        }
    }else if (indexPath.section == 4){
        //支付密码
        ChangeUserInfoViewController * changeUserInfoVC = [[ChangeUserInfoViewController alloc] init];
        changeUserInfoVC.type = UserInfoTypePayPassword;
        [self.navigationController pushViewController:changeUserInfoVC animated:YES];
    }
}
#pragma mark -- UserInfoPicketViewDelegate
-(void)PickerSelectorIndex:(NSInteger)index contentString:(NSString *)str{
    NSLog(@"PickerView:%ld 选中的是:%ld===%@",picketView.tag,index,str);
    if (picketView.tag == 10) {//头像
        if (index == 1) { //系统相册
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeHigh];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        } else if (index == 0){ //照相机
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeHigh];
                imagePicker.allowsEditing = YES;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }else if (picketView.tag == 20){//性别
        [self changeUserInfoWithKey:@"sex" Value:[NSString stringWithFormat:@"%ld",index+1]];
    }
    picketView = nil;
}
// 控制dateView是否显示隐藏
- (void)showDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        dateView.top = kScreenH - 260;
    }];
}
- (void)hideDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        dateView.top = kScreenH;
    } completion:^(BOOL finished) {
        [dateView removeFromSuperview];
        dateView = nil;
    }];
}
#pragma mark DateViewDelegate

- (void)cancelAction {
    [self hideDatePickerView];
}
- (void)sureAction {
    NSDate * date = dateView.datePicker.date;
    int time = [date timeIntervalSince1970];
    NSString * birthday = [NSString stringWithFormat:@"%d", time];
    NSDate *dateStr = [NSDate dateWithTimeIntervalSince1970:[birthday intValue]];
    NSDateFormatter *Formatter=[[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *resultStr=[Formatter stringFromDate:dateStr];
    [self changeUserInfoWithKey:@"birthday" Value:resultStr];
    [self hideDatePickerView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = info[UIImagePickerControllerEditedImage];
    NSData * mydata = UIImageJPEGRepresentation(image , 0.4);
    NSString * pictureDataString = [mydata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [self changeUserInfoWithKey:@"avatar_id" Value:pictureDataString];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
