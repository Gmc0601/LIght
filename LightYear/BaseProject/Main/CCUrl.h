//
//  CCUrl.h
//  CarSticker
//
//  Created by cc on 2017/3/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#ifndef CCUrl_h
#define CCUrl_h
/*
 接口文档
 */
#define TokenKey @"32a0357b12de425b9b957b25f66cf002"
/*
 地图key
 */
#define AMapKey @"9a93d147b3dc5956b850d713d1b25a26"

#define UDID     0

/*****************************测试开关*******************************/

#define HHTest   1      // 1 测试  0 上传

/*****************************测试开关*******************************/

#if HHTest

#define    BaseApi       @"http://139.224.70.219:83/index.php"

#else

#define    BaseApi      @"正式地址"

#endif

#pragma mark - 接口地址 -

//模块A
#define LoginURL @"_login_001"
#define CodeLoginURL @"_login_002"
#define GetCodeURL @"_sms_002"
#define ChangeUserInfo @"_update_userinfo_001"
#define ReceiptListURL @"_receipt_001"
#define ChangePayCodeURL @"_change_pay_pwd_001"

#define BrandList @"_brandlist_001"

/*
 *   User Info
 */

#define IsLogin @"islogin"
#define UserInfoModel @"UserInfoModel"
#define UserToken @"userTOken"
// 经纬度  地理位置信息
#define Longitude @"longitude"

#define Latitude @"latitude"

#define NowAddress @"nowAddress"



#endif /* CCUrl_h */
