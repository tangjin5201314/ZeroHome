//
//  ALAssetModel.h
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/22.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetModel : NSObject

@property (nonatomic) ALAsset *alasset;
@property (nonatomic,copy) NSURL *assetUrl;
@property (nonatomic,copy) NSString *tickImgName;
@property (nonatomic,copy) UIImage *image;
@property (nonatomic,copy) UIImage *fullResolutionImage;
@property (nonatomic,copy) UIImage *fullScreenImage;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *Type;
//@property (nonatomic,copy) NSString *

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL loaded;

@end
