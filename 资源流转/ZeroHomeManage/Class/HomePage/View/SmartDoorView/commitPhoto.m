//
//  commitPhoto.m
//  ZeroHome
//
//  Created by TW on 16/3/13.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "commitPhoto.h"
#import "UIViewExt.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "UIUtility.h"
#import "BaseViewController.h"
#import "CapacityUnlockController.h"
#import "GWPhotoPickerViewController.h"
#import "WorkApplyViewController.h"

#import "TZImageManager.h"
#import "TZLocationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
// 每行个数
#define RowCount 4

// 每个按钮的高度
#define photoHeight 40

@implementation commitPhoto{
    UIActionSheet *sheet;
    UIImagePickerController *pickerView;
    UIImage *m_selectImage;
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}

- (instancetype)initWith:(id)object
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc]initWithObjects:@"add_newphoto@2x.png", nil];
//        self.backgroundColor = [UIColor whiteColor];
        _object = object;
        [self CreatCollection];
    }
    return self;
}
-(void)CreatCollection{
    //1.实例化布局模式
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //2.设置item的大小
    [layout setItemSize:CGSizeMake((SCREEN_WIDTH-100)/4, (SCREEN_WIDTH-100)/4)];
    
    //3设置布局方向(默认是纵向)
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //4.实例化UICollectionView
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH-100)/4+10) collectionViewLayout:layout];
    //5设置协议代理
    _collection.delegate = self;
    _collection.dataSource = self;
    //6.注册item
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    _collection.backgroundColor = [UIColor whiteColor];

    //7.加入到view中
    [self addSubview:_collection];

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    
    for(UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    imageView.userInteractionEnabled = YES;
    if(_dataArray.count>0){
        if(indexPath.row == _dataArray.count-1){
            imageView.image = [UIImage imageNamed:@"add_newphoto@2x.png"];
        }else{

             imageView.image = self.dataArray[indexPath.row];
        }
    }
    [cell.contentView addSubview:imageView];
    if(indexPath.row!=_dataArray.count-1){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = indexPath.row+20;
        [btn setBackgroundImage:[UIImage imageNamed:@"icon-删除"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(delectPgoto:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(imageView.width-10, -3, 20, 20);
        btn.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds  = YES;
        [imageView addSubview:btn];
    }
    
    
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5 ,20, 5, 20);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.window endEditing:YES];
    
    if(_dataArray.count-1 == indexPath.row){
        if(8-_dataArray.count<1){
            [UIUtility showAlertViewWithTitle:@"提醒" messsge:@"最多只能选8张图片"];
            return;
        }
        [self photo];
    }
}
-(void)refreshHeight{
    
    int row = (int)(_dataArray.count-1)/4+1;
    int imageWidth = (SCREEN_WIDTH-100)/4;
    if ([_object isKindOfClass:[WorkApplyViewController class]]) {
         WorkApplyViewController *vc = (WorkApplyViewController *)_object;
        if (IS_IPHONE5) {
            vc.phto_view.height = (imageWidth+10)*row+10+29+40;
            //        vc.mtorRoom_view.top = vc.phto_view.bottom;
            //        vc.authenTime_view.top = vc.mtorRoom_view.bottom;
            //        vc.bottom_view.top = vc.authenTime_view.bottom;
            //        if (row>1) {
            //            vc.bottom_view.height = 207;
            //        }
        }else if (IS_IPhone6){
            vc.phto_view.height = 116- (imageWidth+10)+(imageWidth+10)*row+40;
            //        if (row>1) {
            //            vc.bottom_view.height = 194+2;
            //        }
        }else if(IS_IPhone6plus){
            vc.phto_view.height = 126- (imageWidth+10)+(imageWidth+10)*row+40;
            //        if (row>1) {
            //            vc.bottom_view.height = 194+5;
            //        }else{
            //            vc.bottom_view.height = 194+92;
            //        }
        }
        vc.mtorRoom_view.top = vc.phto_view.bottom;
        vc.authenTime_view.top = vc.mtorRoom_view.bottom;
        vc.bottom_view.top = vc.authenTime_view.bottom;
        [vc.backScrollView setContentSize: CGSizeMake(SCREEN_WIDTH,vc.bottom_view.bottom+20)];
    }else{
        CapacityUnlockController *vc = (CapacityUnlockController *)_object;
        if (IS_IPHONE5) {
            vc.phto_view.height = (imageWidth+10)*row+10+29;
            //        vc.mtorRoom_view.top = vc.phto_view.bottom;
            //        vc.authenTime_view.top = vc.mtorRoom_view.bottom;
            //        vc.bottom_view.top = vc.authenTime_view.bottom;
            //        if (row>1) {
            //            vc.bottom_view.height = 207;
            //        }
        }else if (IS_IPhone6){
            vc.phto_view.height = 116- (imageWidth+10)+(imageWidth+10)*row;
            //        if (row>1) {
            //            vc.bottom_view.height = 194+2;
            //        }
        }else if(IS_IPhone6plus){
            vc.phto_view.height = 126- (imageWidth+10)+(imageWidth+10)*row;
            //        if (row>1) {
            //            vc.bottom_view.height = 194+5;
            //        }else{
            //            vc.bottom_view.height = 194+92;
            //        }
        }
        vc.mtorRoom_view.top = vc.phto_view.bottom;
        vc.authenTime_view.top = vc.mtorRoom_view.bottom;
        vc.bottom_view.top = vc.authenTime_view.bottom;
        [vc.backScrollView setContentSize: CGSizeMake(SCREEN_WIDTH,vc.bottom_view.bottom+20)];
    }
    self.height = (imageWidth+10)*row;
    _collection.height = (imageWidth+10)*row;
    
}
-(void)delectPgoto:(UIButton *)btn{
    [_dataArray removeObjectAtIndex:btn.tag-20];
    CapacityUnlockController *vc = (CapacityUnlockController *)_object;
    
    int row = (int)(_dataArray.count-1)/4+1;
    int imageWidth = (SCREEN_WIDTH-100)/4;
//    if (IS_IPHONE5) {
//         vc.bottom_view.height = 207;
//
//    }else if (IS_IPhone6) {
//        if (row>1) {
//            vc.bottom_view.height = 194+2;
//        }else{
//            vc.bottom_view.height = 194+34;
//        }
//    }else if (IS_IPhone6plus)
//    {
//        if (row>1) {
//            vc.bottom_view.height = 194+5;
//        }else{
//            vc.bottom_view.height = 194+92;
//        }
//        
//    }
    vc.phto_view.height = (imageWidth+10)*row+10+29+40;
//    vc.phto_view.height = 116- (imageWidth+10)+(imageWidth+10)*row;
    vc.mtorRoom_view.top = vc.phto_view.bottom;
    vc.authenTime_view.top = vc.mtorRoom_view.bottom;
    vc.bottom_view.top = vc.authenTime_view.bottom;
    [vc.backScrollView setContentSize: CGSizeMake(SCREEN_WIDTH,vc.bottom_view.bottom)];
//    [vc.my_ScrollView setContentSize: CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT)];

    
    [_collection reloadData];
    NSLog(@"aa：%@",_dataArray);
}

#pragma mark - DVPhotoLibrayViewControllerDelegate
/**
 *  选择图片后返回
 *
 *  @param photoLibray 图库
 *  @param assets      图片数组
 */
- (void)DVPhotoLibrayViewController:(GWPhotoPickerViewController *)photoLibray didFinishPickingAssets:(NSArray *)assets
{
    __weak typeof(self) weakSelf = self;
    for (ALAssetModel *model in assets) {
        UIImage *image = model.fullScreenImage;
        
        [weakSelf.dataArray insertObject:image atIndex:_dataArray.count-1];
    }
    [_collection reloadData];
    [self refreshHeight];
    
}



//拍照
-(void)photo{
    UIViewController *obj = (UIViewController *)_object;
    
    sheet  =[[UIActionSheet alloc]init];
    sheet.delegate = _object;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:obj.view];
}
#pragma mark - sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    UIViewController *obj = (UIViewController *)_object;
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0://相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
//                [self enterCamera];
                [self takePhoto];
                break;//相册
            case 1:
                //sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                [self enterPhotograph];
                [self pushTZImagePickerController];
                return;
                break;
            case 2:
                return;
        }
    }
    else {
        if (buttonIndex == 0) {
            
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            [self enterPhotograph];
            [self pushTZImagePickerController];
            return;
            
        } else {
            return;
        }
    }
}


#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    //    imagePickerVc.photoWidth = 100.0f;
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    //    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    //    if (self.maxCountTF.text.integerValue > 1) {
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //    }
    //    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.allowPickingMultipleVideo = YES; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    imagePickerVc.showSelectBtn = YES;
 
    
#pragma mark - 到这里为止
    [_object presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
//    _dataArray = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    __weak typeof(self) weakSelf = self;
    for(UIImage *image in photos)
    {
      [weakSelf.dataArray insertObject:image atIndex:_dataArray.count-1];
    }
    
    //    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));

    [_collection reloadData];
    [self refreshHeight];

}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = sourceType;
        if(iOS8Later) {
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [_object presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    __weak typeof (self)weakSelf = self;
        [weakSelf.dataArray insertObject:image atIndex:_dataArray.count-1];
        [_collection reloadData];
        [self refreshHeight];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
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
