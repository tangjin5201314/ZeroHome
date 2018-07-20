//
//  ManageRoomCell.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "ManageRoomCell.h"


@implementation ManageRoomCell
{
    NSArray *images;
    NSArray *titles;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatBtn];
    }
    return self;
}


- (void)creatBtn
{
    CGFloat btnHeight = 92;
    images = [[NSArray alloc]initWithObjects:@"机房信息",@"机柜信息",@"个人中心", nil];
    titles = [[NSArray alloc]initWithObjects:@"机房信息",@"机柜信息",@"个人中心", nil];
    
    float btnWidth = (SCREEN_WIDTH)/3;
    for(int i = 0;i<images.count;i++){
        _btn = [convenceBtn buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake((btnWidth+0.5)*(i%3), (btnHeight+0.5)*(i/3)+0.5, btnWidth, btnHeight);
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btn setTitleColor:COLOR_RGB(51, 51, 51) forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        _btn.tag = i + 3000;
        [_btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
    }

    
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate &&[_delegate respondsToSelector:@selector(selectManageBtnTag:)]) {
        [_delegate selectManageBtnTag:btn.tag];
    }
}


@end
