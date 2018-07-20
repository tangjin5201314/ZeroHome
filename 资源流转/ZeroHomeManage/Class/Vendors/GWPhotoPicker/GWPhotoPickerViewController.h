//
//  GWPhotoPickerViewController.h
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/18.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALAssetModel.h"    //避免在其它地方也需要导入这个头问题

@class GWPhotoPickerViewController;
@protocol DVPhotoLibrayViewControllerDelegate <NSObject>
@optional
- (void)DVPhotoLibrayViewController:(GWPhotoPickerViewController *)photoLibray didFinishPickingAssets:(NSArray *)assets;
- (void)DVPhotoLibrayViewController:(GWPhotoPickerViewController *)photoLibray didFinishPickingAssets:(NSArray *)assets content:(NSString *)content;
- (void)DVPhotoPickerViewController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
@end

typedef void(^DidFinishPickingAssetsBlock)(NSArray *assets);
typedef void(^DidFinishPickingAssetsWithContentBlock)(NSArray *assets, NSString *content);
typedef void(^DidFinishPickingPhotoPickerBlock)(UIImagePickerController *pick, NSDictionary *info);

@interface GWPhotoPickerViewController : UIViewController

@property (nonatomic, assign) NSInteger maxSelectedItem;
@property (nonatomic, assign) BOOL showContentTextField;
@property (nonatomic, assign) BOOL allowsEditing;

@property (nonatomic, assign) id<DVPhotoLibrayViewControllerDelegate> photoLibrayDelegate;

@property (nonatomic,   copy) DidFinishPickingAssetsBlock finishPickingBlock;
@property (nonatomic,   copy) DidFinishPickingAssetsWithContentBlock finishPickingWithContentBlock;
@property (nonatomic,   copy) DidFinishPickingPhotoPickerBlock  finishPickingPhotoPickerBlock;

@end