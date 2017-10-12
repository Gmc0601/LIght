//
//  DateView.m
//  FangCao
//
//  Created by Liang on 15/8/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "DateView.h"

@implementation DateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineImageView1.height = 0.5;
    self.lineImageView2.height = 0.5;
    self.lineImageView2.backgroundColor = RGBColor(220, 220, 220);
    self.lineImageView1.backgroundColor = RGBColor(220, 220, 220);
//    if(self.isBirth == 1){
////        如果是出生日期，显示年月日
//        self.datePicker.datePickerMode = UIDatePickerModeDate;
//    }
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    [self.delegate cancelAction];
}

- (IBAction)sureAction:(UIButton *)sender {
    
    [self.delegate sureAction];
}


@end
