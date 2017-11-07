//
//  OrderInfoFootView.m
//  BaseProject
//
//  Created by cc on 2017/9/26.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderInfoFootView.h"
#import "UIView+Utils.h"
@implementation OrderInfoFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)updateinfo:(OrderDetailModel *)model {
    NSString *orderid = [NSString stringWithFormat:@"订单号：%@", model.order_no];
    NSString *time = [NSString stringWithFormat:@"下单时间：%@", model.create_time];
    NSString *state = [NSString stringWithFormat:@"订单状态：%@", model.status_name];
    self.orderNumLab.text = orderid;
    self.orderTimeLab.text = time;
    if ([model.status intValue] == 6) {
        //   审核中  1
        if ([model.isrefund intValue] == 1) {
             self.OrderState.text = @"退款审核中";
        }else {
             self.OrderState.text = @"退款成功";
        }
        //   退款成功 2
        
        
    }else {
      self.OrderState.text = state;
    }
    
    
}

- (void)createView {
    [self addSubview:self.orderNumLab];
    [self addSubview:self.orderTimeLab];
    [self addSubview:self.OrderState];
    [self addSubview:self.copuBtn];
}

- (UILabel *)orderNumLab {
    if (!_orderNumLab) {
        _orderNumLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(20), kScreenW - SizeWidth(30), SizeHeigh(15))];
        _orderNumLab.font = Verdana(13);
        _orderNumLab.textColor = UIColorFromHex(0x999999);
        _orderNumLab.text = @"订单编号：1111111111111111111";
    }
    return _orderNumLab;
}

- (UILabel *)orderTimeLab {
    if (!_orderTimeLab) {
        _orderTimeLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15),self.orderNumLab.bottom + SizeHeigh(12) , kScreenW - SizeWidth(30), SizeHeigh(15))];
        _orderTimeLab.textColor = UIColorFromHex(0x999999);
        _orderTimeLab.font = Verdana(13);
        _orderTimeLab.text = @"下单时间：2017-06-27 15：23：03";
    }
    return _orderTimeLab;
}

- (UILabel *)OrderState {
    if (!_OrderState) {
        _OrderState = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), self.orderTimeLab.bottom + SizeHeigh(13), kScreenW - SizeWidth(30), SizeHeigh(15))];
        _OrderState.font = SourceHanSansCNRegular(13);
        _OrderState.textColor = UIColorFromHex(0x999999);
        _OrderState.text = @"订单状态：待配送";
    }
    return _OrderState;
}

- (UIButton *)copuBtn {
    if (!_copuBtn) {
        _copuBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - SizeWidth(60), SizeHeigh(20), SizeWidth(45), SizeHeigh(15))];
        _copuBtn.backgroundColor = [UIColor clearColor];
        [_copuBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copuBtn setTitleColor:UIColorFromHex(0x3e7bb1) forState:UIControlStateNormal];
        _copuBtn.titleLabel.font = SourceHanSansCNMedium(12);
        [_copuBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copuBtn;
}

- (void)copyBtnClick:(UIButton *)sender {
    if (self.copyBtnBlock) {
        self.copyBtnBlock();
    }
}

@end
