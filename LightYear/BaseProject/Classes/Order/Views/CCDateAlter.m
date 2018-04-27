//
//  CCDateAlter.m
//  BaseProject
//
//  Created by cc on 2017/11/10.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCDateAlter.h"


@implementation CCDateAlter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView{
    [self addSubview:self.backView];
    [self.backView addSubview:self.whitView];
    [self.whitView addSubview:self.titleLab];
    [self.whitView addSubview:self.closeBtn];
    [self.whitView addSubview:self.pickerView];
    [self.whitView addSubview:self.finishBtn];
}

- (void)update:(OrderDetailModel *)model {
    self.dataArr = [NSMutableArray new];
    NSInteger dis = [model.shopInfo.orderdays integerValue]; //前后的天数
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    self.arr0 = [NSMutableArray new];
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        for (int i = 0; i < dis; i++) {
            theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
            NSString *str = [NSString stringWithFormat:@"%@", theDate];
            NSString *str2 = [str substringToIndex:10];
            NSString *str3 = [str2 substringFromIndex:5];
            [self.arr0 addObject:str3];
        }
    }
    else
    {
        theDate = nowDate;
    }
    [self gettimeArr:model];
    
}

- (void)gettimeArr:(OrderDetailModel *)model{
    self.arr1 = [NSMutableArray new];
    self.arr2 = [NSMutableArray new];
    int time = [model.shopInfo.ordertimes intValue];
    NSString *startTime = model.shopInfo.startdate;
    NSString *endTime = model.shopInfo.enddate;
    NSString *str1 =  [startTime substringToIndex:2];
    NSString *str2 =  [endTime substringToIndex:2];
    NSRange range ;
    range.length = 2;
    range.location = 3;
    NSString *endmin = [endTime substringWithRange:range];
    NSLog(@">>>>%@", str1);
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"mm"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    NSString *min = [dateFormatter1 stringFromDate:date];
    NSString *now_hour = strHour, *now_min = min;
    NSString *star_hour = str1;
    NSString *end_hour = str2;
    NSMutableArray *hourArr = [NSMutableArray new];
    NSMutableArray *minteArr = [NSMutableArray new];
    
    for (int i = [star_hour intValue]; i <= [end_hour intValue]; i++) {
        NSString *str = [NSString stringWithFormat:@"%.2d", i];
        [hourArr addObject:str];
    }
    
    for (int i = 0; i < 60 ; i+=time ) {
        NSString *str = [NSString stringWithFormat:@"%.2d", i];
        [minteArr addObject:str];
    }
    
    for (int i = 0 ; i < hourArr.count; i++) {
        NSString * str1 = hourArr[i];
        for ( int j = 0; j < minteArr.count; j++) {
            NSString * str2 = minteArr[j];
            if (i == hourArr.count - 1) {
                if ([str2 intValue] > [endmin intValue]) {
                    break;
                }
            }
            NSString *timeStr = [NSString stringWithFormat:@"%@:%@", str1, str2];
            NSLog(@"ARR2 %@", timeStr);
            [self.arr2 addObject:timeStr];
        }
    }
    
    
    
    for (int i = 0 ; i < hourArr.count; i++) {
        NSString * str1 = hourArr[i];
        for ( int j = 0; j < minteArr.count; j++) {
            if ([str1 intValue] < [now_hour intValue]) {
                break;
            }
            NSString * str2 =minteArr[j];
            if (([str1 intValue] == [now_hour intValue]) && ([str2 intValue] <= [now_min intValue])) {
                break;
            }
            if (i == hourArr.count - 1) {
                if ([str2 intValue] > [endmin intValue]) {
                    break;
                }
            }
            NSString *timeStr = [NSString stringWithFormat:@"%@:%@", str1, str2];
            NSLog(@"ARR1 %@", timeStr);
            [self.arr1 addObject:timeStr];
        }
    }
    
    if (self.str0.length == 0) {
        self.str0 = self.arr0[0];
    }
    if (self.str1.length == 0) {
        if (self.arr1.count > 0) {
          self.str1 = self.arr1[0];
        }else {
            self.str1 = nil;
        }
        
    }
    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    theDate = [nowDate initWithTimeIntervalSinceNow: 10 ];
    NSString *str = [NSString stringWithFormat:@"%@", theDate];
    NSString *first =  [str substringToIndex:4];
    NSString *backStr = [NSString stringWithFormat:@"%@-%@ %@%@", first,self.str0, self.str1,@":00"];
    self.timeStr = backStr;
    NSLog(@"%@", self.timeStr);
    if (self.finishBlock) {
        self.finishBlock(self.timeStr);
    }
}


- (void)pop {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.backView.alpha = 1;
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backView.alpha = 1;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
- (UIView *)whitView{
    if (!_whitView) {
        _whitView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW /2 - SizeWidth(170), kScreenH /2 - SizeHeigh(190), SizeWidth(340), SizeHeigh(380))];
        _whitView.backgroundColor = [UIColor whiteColor];
        [_whitView.layer setMasksToBounds: YES];
        [_whitView.layer setCornerRadius:SizeHeigh(15)];
    }
    return _whitView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backView.backgroundColor = RGBColorAlpha(74, 73, 74, 0.6);
    }
    return _backView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(0, 17, SizeWidth(340), 20)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = NormalFont(15);
        _titleLab.text = @"选择取货时间";
    }
    return _titleLab;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(340 - 15 - 30), 17, SizeWidth(30), SizeHeigh(30))];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setImage:[UIImage imageNamed:@"sg_ic_quxiao"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(380 - 64), SizeWidth(310), SizeHeigh(44))];
        _finishBtn.backgroundColor = UIColorFromHex(0x3e7bb1);
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.titleLabel.font = NormalFont(15);
        _finishBtn.layer.cornerRadius = 5;
    }
    return _finishBtn;
}


- (void)finishClick:(id)sender {
    
    if (self.str0.length == 0) {
        self.str0 = self.arr0[0];
    }
    if (self.str1.length == 0) {
        if (self.row == 0 && self.arr1.count > 0) {
          self.str1 = self.arr1[0];
        }
        if (self.row == 1) {
            self.str1 = self.arr2[0];
        }
        
    }
    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    theDate = [nowDate initWithTimeIntervalSinceNow: 10 ];
    NSString *str = [NSString stringWithFormat:@"%@", theDate];
    NSString *first =  [str substringToIndex:4];
    NSString *backStr = [NSString stringWithFormat:@"%@-%@ %@%@", first,self.str0, self.str1,@":00"];
    self.timeStr = backStr;
    NSLog(@"%@", self.timeStr);
    if (self.finishBlock) {
        self.finishBlock(self.timeStr);
    }
    [self dismiss];
}

-(UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SizeWidth(340), SizeHeigh(250))];
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource 相关代理
#pragma Mark -- 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
#pragma mark - pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.arr0.count;
    }else {
        NSInteger row = [pickerView selectedRowInComponent:0];
        if (row == 0) {
            self.row = 0;
           return self.arr1.count;
        }else {
            self.row = 1;
            return self.arr2.count;
        }
    }
}
#pragma mark - UIPickerViewDelegate 相关代理方法
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}
#pragma mark - 返回当前行cell的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        return self.arr0[row];
    }else {
        NSInteger srow = [pickerView selectedRowInComponent:0];
        if (srow == 0) {
            return self.arr1[row];
        }else {
            return self.arr2[row];
        }
    }
    
}
#pragma mark - 返回选中的行didSelectRow
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        self.str0 = self.arr0[row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];

    }else {
        NSInteger srow = [pickerView selectedRowInComponent:0];
        if (srow == 0) {
            
            if (self.arr1.count > 0) {
                 self.str1 = self.arr1[row];
            }else {
                self.str1 = nil;
            }
            
            
           
        }else {
            
                self.str1 = self.arr2[row];

        }
    }
    
}

@end
