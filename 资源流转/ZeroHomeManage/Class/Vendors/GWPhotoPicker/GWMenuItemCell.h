//
//  GWMenuItemCell.h
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/22.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWMenuItemCell : UITableViewCell
{
    UIImageView *_imvPosterImage;
    UILabel *_lblGroupName;
    UILabel *_lblNumberOfAssets;
}

- (void)setContent:(id)model IndexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv obj:(id)obj;

@end
