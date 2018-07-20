//
//  gongzhonghaoViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "gongzhonghaoViewController.h"
#import "UMSocial.h"


@interface gongzhonghaoViewController ()<UIActionSheetDelegate>
{
    NSString *_pincodeURL;
    UIImageView*tempImageView;
}

@end

@implementation gongzhonghaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back:)];
    self.title_lbl.text = @"微信公众号";

   // _label.left = _iconImage.left;
    _label.left = 0;
    if(SCREEN_WIDTH == 320){
        CGPoint center = _erweima.center;
        _erweima.width = SCREEN_WIDTH*0.6;
        _erweima.height = SCREEN_WIDTH*0.6;
        _erweima.center = center;
        _erweima.top = _label.bottom+20;
    }
    
    _erweima.userInteractionEnabled=YES;
    [self.view addSubview:_erweima];
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
       [_erweima addGestureRecognizer:longPress];
    
}
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------判断是否为二维码
/*
- (void)isPinCodeWithImage:(UIImage *)image{
    ZBarReaderController* read = [ZBarReaderController new];
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol* symbol = nil;
    for(symbol in  [read scanImage:cgImageRef])
        break;
    _pincodeURL = symbol.data;
    NSLog(@"URL == %@",symbol.data);
    UIActionSheet *actionSheet;
    if ([symbol.data hasPrefix:@"http"]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:@"保存图片"
                                         otherButtonTitles:@"发送图片到微信", nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:@"保存图片"
                                         otherButtonTitles:nil];
    }
     [actionSheet showInView:self.view];
}
*/
 
#pragma mark->长按识别二维码

-(void)dealLongPress:(UIGestureRecognizer*)gesture{
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        tempImageView = (UIImageView*)gesture.view;
//        [self isPinCodeWithImage:tempImageView.image];
         UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:@"保存图片"
                                         otherButtonTitles:@"发送图片到微信", nil];
         [actionSheet showInView:self.view];

    }else if(gesture.state==UIGestureRecognizerStateEnded){

    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //系统方法，保存图片到相册
            UIImageWriteToSavedPhotosAlbum(tempImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            break;
            case 1:
            [self ShardToFriend];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_pincodeURL]];
            break;
            
        default:
            break;
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存图片失败";
    
    if (!error) {
        
        message = @"成功保存到相册";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }else
    {
        message = [error description];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }
    
}

//邀请朋友
-(void)ShardToFriend{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"app_Center_Shared"};
    [MobClick event:@"app_Center_Shared" attributes:dict];
    
    //58@2x.png
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAPPKEY
                                      shareText:@"亲，快来用业主专属零点家园APP吧！投诉、报修、邻里交流、物业公告等各种服务应有尽有，快来体验吧！"
                                     shareImage:[UIImage imageNamed:@"二维码"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"零点家园-邀请好友";
    [UMSocialData defaultData].extConfig.qqData.title = @"零点家园-邀请好友";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = ShareToWeixinURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = ShareToWeixinURL;
    [UMSocialData defaultData].extConfig.qqData.url = ShareToWeixinURL;
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
    
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
