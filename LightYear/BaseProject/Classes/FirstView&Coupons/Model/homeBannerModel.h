//
//  homeBannerModel.h
//  BaseProject
//
//  Created by wmk on 2017/10/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseModel.h"

@protocol bannerInfo <NSObject>

@end

@interface bannerInfo : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *shopid;
@property (nonatomic, copy) NSString *goodid;

@end

@interface homeBannerModel : BaseModel

@property (nonatomic, strong) NSArray<bannerInfo> * info;

@end
