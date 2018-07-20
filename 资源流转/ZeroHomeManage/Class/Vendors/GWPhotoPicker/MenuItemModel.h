//
//  MenuItemModel.h
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/22.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItemModel : NSObject

@property (nonatomic,   copy) NSString  *groupName;     //相册名称
@property (nonatomic,   copy) UIImage   *posterImage;   //相册菜单封面
@property (nonatomic, assign) NSInteger numberOfAssets; //相册菜单下相片数量
@property (nonatomic, assign) BOOL isSysLibrary;        

@end
