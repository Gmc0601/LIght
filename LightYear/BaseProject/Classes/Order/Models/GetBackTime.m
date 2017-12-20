//
//  GetBackTime.m
//  BaseProject
//
//  Created by cc on 2017/11/16.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "GetBackTime.h"

@implementation GetBackTime

- (NSString *)update:(OrderDetailModel *)model {
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
    self.arr1 = [NSMutableArray new];
    self.arr2 = [NSMutableArray new];
    int time = [model.shopInfo.ordertimes intValue];
    NSString *startTime = model.shopInfo.startdate;
    NSString *endTime = model.shopInfo.enddate;
    NSString *str1 =  [startTime substringToIndex:2];
    NSString *str2 =  [endTime substringToIndex:2];
//    NSLog(@">>>>%@", str1);
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
            NSString * str2 =minteArr[j];
            NSString *timeStr = [NSString stringWithFormat:@"%@:%@", str1, str2];
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
            NSString *timeStr = [NSString stringWithFormat:@"%@:%@", str1, str2];
            [self.arr1 addObject:timeStr];
        }
    }
    
    if (self.str0.length == 0) {
        self.str0 = self.arr0[0];
    }
    if (self.str1.length == 0) {
        self.str1 = self.arr1[0];
    }
    
    NSDate*nowDatenew = [NSDate date];
    NSDate* theDatenew;
    theDatenew = [nowDatenew initWithTimeIntervalSinceNow: 10 ];
    NSString *str = [NSString stringWithFormat:@"%@", theDatenew];
    NSString *first =  [str substringToIndex:4];
    NSString *backStr = [NSString stringWithFormat:@"%@-%@ %@%@", first,self.str0, self.str1,@":00"];
    self.timeStr = backStr;
    NSLog(@"%@", self.timeStr);
    
    
    return self.timeStr;
}

@end
