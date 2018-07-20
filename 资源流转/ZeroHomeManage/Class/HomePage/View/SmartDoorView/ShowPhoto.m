//
//  ShowPhoto.m
//  ZeroHome
//
//  Created by TW on 16/3/13.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "ShowPhoto.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"
@implementation ShowPhoto

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    for(int j = 0;j<dataArray.count; j++){
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10+((self.width-40)/3+10)*j, 5, (self.width-40)/3, (self.width-40)/3)];
        imageview.backgroundColor = [UIColor clearColor];
        
        NSString *path = [dataArray[j] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageview sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"加载图片-图标"]];
        [self addSubview:imageview];
        
    }
}
-(void)setShardArray:(NSMutableArray *)shardArray{
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    for(int j = 0;j<shardArray.count; j++){
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(((self.width-10)/3+10)*j, 0, (self.width-10)/3, (self.width-10)/3)];
        imageview.backgroundColor = [UIColor clearColor];
        
         NSString *path = [shardArray[j] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageview sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"组-11"]];
        [self addSubview:imageview];
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
