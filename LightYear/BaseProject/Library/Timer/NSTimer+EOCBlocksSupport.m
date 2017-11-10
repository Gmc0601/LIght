//
//  NSTimer+EOCBlocksSupport.m
//  HuoHaoApp
//
//  Created by liqu on 16/8/26.
//  Copyright © 2016年 com.HuoHao.app. All rights reserved.
//

#import "NSTimer+EOCBlocksSupport.h"

@implementation NSTimer (EOCBlocksSupport)

+(NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats{

    return [ self scheduledTimerWithTimeInterval:interval
                                          target:self
                                        selector:@selector(eoc_blockInvoke:)
                                        userInfo:[block copy]
                                         repeats:repeats];


}


+(void)eoc_blockInvoke:(NSTimer *)timer{

    void (^block)()=timer.userInfo;
    if (block) {
        block();
    }
}
@end
