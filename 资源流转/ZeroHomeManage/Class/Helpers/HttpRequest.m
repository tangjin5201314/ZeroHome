//
//  HttpRequest.m
//  Himi
//
//  Created by NPHD on 14-9-2.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "HttpRequest.h"
#import "UIUtility.h"
#import "UserDefalut.h"
#import "YDGHUB.h"
#import "LoginViewController.h"
#import "NSString+category.h"
#import "WorkOrderHomeController.h"
#import "TabBarMainViewController.h"
#import "AuthentifiModel.h"
#import "MJExtension.h"

@implementation HttpRequest{
    NSMutableDictionary *_taskDict;
    NSMutableDictionary *_sourceDict;
    AFHTTPRequestOperationManager *manager;
    
    UserDefalut *user;
    YDGHUB *hub;
 
}

static HttpRequest *_sharedHttpResquest;
+(HttpRequest *)sharedHttpRequest;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHttpResquest= [[HttpRequest alloc] init];
    });
    return _sharedHttpResquest;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskDict = [[NSMutableDictionary alloc]init];
        _sourceDict = [[NSMutableDictionary alloc]init];
        _CkeckArray = [[NSMutableArray alloc]init];
        user = [UserDefalut ShardUserDefalut];
        hub = [YDGHUB shardYDGHUB];
    }
    return self;
}


-(void)getNewsWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url IsSava:(BOOL)Save{

    if(![_sourceDict objectForKey:url]){
        if(![_taskDict objectForKey:url]){
            NSLog(@"正在下载");
            manager = [AFHTTPRequestOperationManager manager];
            [_taskDict setObject:manager forKey:url];
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"下载成功");
                
                [_taskDict removeObjectForKey:url];
                NSDictionary *rootdict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                if (Save) {
                    [_sourceDict setObject:rootdict forKey:url];
                }
                finishHandler(nil,rootdict);
                //NSLog(@"%@", [NSThread currentThread]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_taskDict removeObjectForKey:url];
                NSLog(@"op:%@",operation.responseString);
                NSLog(@"op:%@",error);
//                [UIUtility showAlertViewWithTitle:@"提示" messsge:@"网络请求失败"];
                //Error(nil,rootdict);
            }];
        }
        else
            NSLog(@"无需重复下载");
    }
    else{
        NSLog(@"有对应缓存");
        finishHandler(nil,[_sourceDict objectForKey:url]);
    }
    
    
}
-(void)PostNewsWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh{
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/xml",@"text/plain",nil];
    
    if(![_sourceDict objectForKey:url]){
        UIViewController *selfView = (UIViewController *)delegate;
        if(!refresh){
            [selfView.view addSubview:hub];
        }
          __weak HttpRequest *weakself = (HttpRequest *)self;
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if(!refresh){
                    [hub removeFromSuperview];
                }
                NSLog(@"json:%@",operation.responseString);

                NSDictionary *rootdict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                if(![[rootdict objectForKey:@"success"] boolValue]){

                }
                //判断token是否失效
                if([rootdict objectForKey:@"overdue"]){
                    if([[rootdict objectForKey:@"overdue"] intValue]!=1){
                        if ([rootdict objectForKey:@"reason"]) {
                             [UIUtility showAlertViewWithTitle:@"提示" messsge:[rootdict objectForKey:@"reason"]];
                        }
                        //当token为3或4时，跳转到登陆页面
                        if ([[rootdict objectForKey:@"overdue"]intValue] ==2) {
                          
                            [weakself loginMethodWithParams];
                        }else{
                            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                            delegate.window.rootViewController = nav;
                            
                            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                            [ud removeObjectForKey:@"token"];
                            [ud removeObjectForKey:@"iphoneNumber"];
                            user.token = nil;
                            user.loginPassWord = nil;
                            user.isLogin = NO;
                            user.isThirdLogin = NO;
                            usertoken  = nil;
                            
                        
                        }
                        return ;
                    }
                }

                if (save) {
                    [_sourceDict setObject:rootdict forKey:url];
                }
                finishHandler(nil,rootdict);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //[_taskDict removeObjectForKey:url];
                if(!refresh){
                    [hub removeFromSuperview];
                }
//               [UIUtility showAlertViewWithTitle:@"提示" messsge:@"网络链接失败"];
                NSLog(@"op:%@",operation.responseString);
                NSLog(@"op:%@",[error description]);
                Error(nil,error);
            }];
        }

    else{
        NSLog(@"有对应缓存");
        finishHandler(nil,[_sourceDict objectForKey:url]);
    }

}

-(void)Post1NewsWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh{
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    
    if(![_sourceDict objectForKey:url]){
        UIViewController *selfView = (UIViewController *)delegate;
        if(!refresh){
            [selfView.view addSubview:hub];
        }
        
        __weak HttpRequest *weakself = (HttpRequest *)self;
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(!refresh){
                [hub removeFromSuperview];
            }
            NSLog(@"news1json:%@",operation.responseString);
            
            NSDictionary *rootdict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

            //判断token是否失效 overdue不为1时，异常
            if([rootdict objectForKey:@"overdue"]){
                if([[rootdict objectForKey:@"overdue"] intValue]!=1){
                    if ([rootdict objectForKey:@"reason"]) {
                        [UIUtility showAlertViewWithTitle:@"提示" messsge:[rootdict objectForKey:@"reason"]];
                    }
                    //当token为3或4时，跳转到登陆页面，
                    if ([[rootdict objectForKey:@"overdue"] intValue] == 2) {
                        [weakself loginMethodWithParams];
                    }else{
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        [ud removeObjectForKey:@"token"];
                        [ud removeObjectForKey:@"iphoneNumber"];
                        user.token = nil;
                        user.loginPassWord = nil;
                        user.isLogin = NO;
                        user.isThirdLogin = NO;
                        usertoken  = nil;

                        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                        delegate.window.rootViewController = nav;
                        
                        
                    }
                    
                    return ;
                }
            }

            if (save) {
                [_sourceDict setObject:rootdict forKey:url];
            }
            finishHandler(nil,rootdict);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[_taskDict removeObjectForKey:url];
            if(!refresh){
                [hub removeFromSuperview];
            }
//            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"网络链接失败"];
            NSLog(@"op:%@",operation.responseString);
            NSLog(@"op:%@",[error description]);
            Error(nil,error);
        }];
    }
    else{
        NSLog(@"有对应缓存");
        finishHandler(nil,[_sourceDict objectForKey:url]);
    }
    
}

-(void)PostRequestDataWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh{
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    
    if(![_sourceDict objectForKey:url]){
        UIViewController *self = (UIViewController *)delegate;
        if(!refresh){
            [self.view addSubview:hub];
        }
        NSLog(@"正在下载");
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(!refresh){
                [hub removeFromSuperview];
            }
            NSLog(@"PostRequestData:%@",operation.responseString);
            
            NSDictionary *rootdict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            if (save) {
                [_sourceDict setObject:rootdict forKey:url];
            }
            finishHandler(nil,rootdict);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            if(!refresh){
                [hub removeFromSuperview];
            }
        }];
    }
    else{
        NSLog(@"有对应缓存");
        finishHandler(nil,[_sourceDict objectForKey:url]);
    }
    
}

-(void)PostRequestXMLDataWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh
{

    manager = [AFHTTPRequestOperationManager manager];

    NSString *soapHead = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Header>\n"
    "<username>njptpeixian</username>\n"
    "<password>49ba59abbe56e057(md5加密后)</password>\n"
    "</soap:Header>\n"
    "<soap:Body>\n"
    
    "</soap:Body>\n";
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapHead length]];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    NSData *xmlData = [soapHead dataUsingEncoding:NSUTF8StringEncoding];

    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       [formData appendPartWithFormData:xmlData name:@"xml"];
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"responseObject == %@",responseObject);
         NSDictionary *rootdict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"rootdict == %@",rootdict);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"operation == %@ error == %@",operation,Error);
    
     }];
}


-(void)stop{
    [manager.operationQueue cancelAllOperations];
    [_taskDict removeAllObjects];
}


-(void)getLinkStatus:(void (^)(NSInteger linkStatus))finishHandler{
    
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 移动网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络
     */
    
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        finishHandler(status);
    }];
    
}

-(void)loginMethodWithParams{
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *channelID = app.channelId;
    if(channelID == nil){
        channelID = @"0";
    }
   NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
   NSString *passWord = [[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"];
    //版本号
    NSString *vesion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    vesion = [NSString stringWithFormat:@"i-%@",vesion];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kLogin];
    NSString *password = [passWord stringFromMD5];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:userName forKey:@"tel"];
    [parameters setObject:password forKey:@"pwd"];
    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"coreVersion"];
    [parameters setObject:channelID forKey:@"channelId"];
    [parameters setObject:vesion forKey:@"version"];
    [parameters setObject:@4 forKey:@"belong"];
    NSLog(@"%@",parameters);
    [self PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"登录:%@",jsonObj);
        [SVProgressHUD showSuccessWithStatus:@"重新登录"];
        NSString *result = [jsonObj objectForKey:@"success"];
        if([result boolValue]){
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *token = [[jsonObj objectForKey:@"message"] objectForKey:@"token"];
            [ud setObject:token forKey:@"token"];
            usertoken = token;
            NSString *phoneNum =  userName;
            [ud setObject:phoneNum forKey:@"iphoneNumber"];
            phoneNumber = phoneNum;
            [[NSUserDefaults standardUserDefaults] synchronize];

//            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//            TabBarMainViewController *tabVC = [[TabBarMainViewController alloc]init];
//            delegate.window.rootViewController = tabVC;
            [self requestQueryCheckUserState];
        }else{
            
            [SVProgressHUD showErrorWithStatus:[jsonObj objectForKey:@"reason"]];
        }
        
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:nil isRefresh:NO];
    
}

#pragma mark - 查询用户是什么权限  1、通网  6、管理员  其他
- (void)requestQueryCheckUserState
{
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryCheckUser];
    
    NSDictionary *parameters = @{@"token":usertoken};
    NSLog(@"xxxx==%@",parameters);
    [self PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"查询用户是否为认证用户==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSDictionary *dic = jsonObj[@"message"][@"constructionUserVO"];
            AuthentifiModel *model = [AuthentifiModel mj_objectWithKeyValues:dic];
            
            areaType = model.type;
            if (areaType == 6 || areaType == 9) {
                TabBarMainViewController *tabVC = [[TabBarMainViewController alloc]init];
                app.window.rootViewController = tabVC;
                
            }else{
                WorkOrderHomeController *vc = [[WorkOrderHomeController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                app.window.rootViewController = nav;
            }
            
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


@end
