//
//  CenterUserTableViewCell.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "CenterUserTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CenterUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //_RightLabel.adjustsFontSizeToFitWidth  = YES;
    _RightLabel.numberOfLines = 2;
    
//    CALayer *lay  = self.ImageView.layer;//获取ImageView的层
//    [lay setMasksToBounds:YES];
//    [lay setCornerRadius:18.0];
    _seperatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _seperatView.backgroundColor = COLOR_RGB(200, 199, 204);
    [self addSubview:_seperatView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImage:(NSString *)imageURL{
    
    NSString *path = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"person.png"]];
    
}
@end
