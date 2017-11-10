//
//  NSTimer+EOCBlocksSupport.h
//  HuoHaoApp
//
//  Created by liqu on 16/8/26.
//  Copyright © 2016年 com.HuoHao.app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (EOCBlocksSupport)

+(NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
