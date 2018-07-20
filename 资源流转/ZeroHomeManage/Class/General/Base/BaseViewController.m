//
//  BaseViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 16/1/26.
//  Copyright (c) 2016年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIAlertViewDelegate>{
      UIImageView *navBarHairlineImageView;
    
}

@end

@implementation BaseViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
    
    [self unregisterForKeyboardNotifications];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    //隐藏导航栏下面线条
    navBarHairlineImageView.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _http = [HttpRequest sharedHttpRequest];
    _user = [UserDefalut ShardUserDefalut];
//    _app = [UIApplication sharedApplication].delegate;
    _hub = [YDGHUB shardYDGHUB];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    //设置导航栏透明
//    [self.navigationController.navigationBar setTranslucent:YES];
//    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

    
    _title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    _title_lbl.textColor = COLOR_RGB(79, 172, 246);
    _title_lbl.font = FONT_SYSTEM(18);
    _title_lbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _title_lbl;
    
    
     [self enanblePopGobackGesture];
     [self netWorkState];  //检测网络状态
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"";
//    //主要是以下两个图片设置
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"icon_back"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"icon_back"];
//    self.navigationItem.backBarButtonItem = backItem;
    
}


//设置左边的按钮(文字按钮)
- (void)setLeftButtonWithTitle:(NSString*)title action:(SEL)selector
{
    [self setLeftButtonWithTitle:title action:selector titleColor:[UIColor blackColor]];
}

- (void)setLeftButtonWithTitle:(NSString*)title action:(SEL)selector titleColor:(UIColor*)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIFont* font = [UIFont systemFontOfSize:17.0];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:font}].width+5*2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    [self setLeftButton:button action:selector];
}

//设置左边的返回按钮(图片按钮)
- (void)setLeftButtonWithImageName:(NSString*)imageName action:(SEL)selector
{
    [self setLeftButtonWithNormarlImageName:imageName highlightedImageName:imageName action:selector];
}


- (void)setLeftButtonWithNormarlImageName:(NSString*)normarName
                     highlightedImageName:(NSString *)highlightedName
                                   action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage* nmImage = [UIImage imageNamed:normarName];
    UIImage* hlImage = [UIImage imageNamed:highlightedName];
    CGFloat width = 44;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    [button setImage:nmImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
//    [button setBackgroundColor:[UIColor redColor]];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -33, 0, 0);
    [self setLeftButton:button action:selector];
}

//设置左边的返回按钮(通用按钮)
- (void)setLeftButton:(UIButton*)button action:(SEL)selector
{
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, button.bounds.size.width, button.bounds.size.height);
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -10;//IS_OS_7_Later ? -16 : -6;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


//设置右边的按钮(文字按钮), 可以指定按钮水平位置
- (void)setRightButtonWithTitle:(NSString*)title action:(SEL)selector
{
    [self setRightButtonWithTitle:title action:selector titleColor:COLOR_RGB(51, 51, 51)];
}

- (void)setRightButtonWithTitle:(NSString*)title action:(SEL)selector titleColor:(UIColor*)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIFont* font = [UIFont systemFontOfSize:17.0];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:font}].width+5*2;
    [button setFrame:CGRectMake(0, 0, width, 44)];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [self setRightButton:button action:selector];
}

//设置右边的按钮(图片按钮), 可以指定按钮水平位置
- (void)setRightButtonWithImageName:(NSString*)imageName action:(SEL)selector
{
    [self setRightButtonWithNormarlImageName:imageName highlightedImageName:imageName action:selector];
}

- (void)setRightButtonWithNormarlImageName:(NSString*)normarName
                      highlightedImageName:(NSString *)highlightedName
                                    action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* nmImage = [UIImage imageNamed:normarName];
    UIImage* hlImage = [UIImage imageNamed:highlightedName];
    CGFloat width = 36;
    [button setFrame:CGRectMake(0, 0, width, 36)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    [button setImage:nmImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
    
    [self setRightButton:button action:selector];
}

//设置右边的按钮
- (void)setRightButton:(UIButton*)button action:(SEL)selector
{
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, button.bounds.size.width, button.bounds.size.height);
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;//IS_OS_7_Later ? -16 : -6;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,barButtonItem];
    
    
}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//去掉导航栏下面线条
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)enanblePopGobackGesture
{
    //------滑动返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //自定义了返回键就要设置代理为nil
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)unEnanblePopGobackGesture
{
    //------滑动返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)netWorkState{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 移动网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络
     */
  [self.http getLinkStatus:^(NSInteger linkStatus) {
      switch (linkStatus) {
          case 0:
              [SVProgressHUD showInfoWithStatus:@"网络无连接,请打开网络设置"];
              break;
          default:
              break;
      }
  }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - keyboard
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)unregisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
- (void)keyboardWasShow:(NSNotification *)notification {
    
    
//    NSDictionary* info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    //CGRect rect = self.view.frame;
    [UIView animateWithDuration:0.1f animations:^{
        
        //self.view.frame = CGRectMake(0,-40, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.3f animations:^{
        //self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//     [[SDImageCache sharedImageCache]clearMemory]; 
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
