//
//  TJHttpTool.m
//  ZeroHome
//
//  Created by TW on 17/9/19.
//  Copyright © 2017年 tangjin. All rights reserved.
//

#import "TJHttpTool.h"
#import "NSString+category.h"

@implementation TJHttpTool

+ (void)requestWithPath:(NSString *)path param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success == nil) return;

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功-->%@", dic);
            success(dic);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure == nil) return;
            

            NSLog(@"请求失败-->%@", error);
            failure(error);
        }];

}

#pragma mark --- 判断是否连接成功
+ (void)requestisConnectWebserviceWithSuccess:(SuccessBlock)success failure:(FailedBlock)failure
{
    NSString *bodyMsg = [NSString stringWithFormat:@"<iter:downloadWorkList>\n"
                         "<xml>"
                         "&lt;request&gt;"
                         "&lt;userName&gt;%@&lt;/userName&gt;"
                         "&lt;/request&gt;"
                         "</xml>\n"
                         "</iter:downloadWorkList>\n",@"zhou"];
    
    [self requsetWithBody:bodyMsg success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}
/*
 
 "&lt;request&gt;"
 "&lt;workAccount&gt;%@&lt;/workAccount&gt;"
 "&lt;datefrom&gt;2017-05-01&lt;/datefrom&gt;"
 "&lt;dateTo&gt;2017-09-18&lt;/dateTo&gt;"
 "&lt;page&gt;0&lt;/page&gt;"
 "&lt;/request&gt;"
 
 */

#pragma mark --- 下载工单列表
+ (void)requestDownLoadWorkListWithSuccess:(SuccessBlock)success failure:(FailedBlock)failure
{
    NSString *bodyMsg = [NSString stringWithFormat:@"<iter:queryWorkorder>\n"
                         "<xml>"
                         "&lt;request&gt;"
                         "&lt;workAccount&gt;%@&lt;/workAccount&gt;"
                         "&lt;datefrom&gt;2017-05-01&lt;/datefrom&gt;"
                         "&lt;dateTo&gt;2017-09-18&lt;/dateTo&gt;"
                         "&lt;page&gt;1&lt;/page&gt;"
                         "&lt;state&gt;0&lt;/state&gt;"
                         "&lt;size&gt;100&lt;/size&gt;"
                         "&lt;/request&gt;"
                         "</xml>\n"
                         "</iter:queryWorkorder>\n",@"zhou"];
    
    [self requsetWithBody:bodyMsg success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

//下载工单列表详情
+(void)requestDownLOadWorkDetailWithWorkID:(NSString *)workId Success:(SuccessBlock)success failure:(FailedBlock)failure
{
    NSString *bodyMsg = [NSString stringWithFormat:@"<iter:downloadWork>\n"
                         "<xml>"
                         "&lt;request&gt;"
                         "&lt;userName&gt;%@&lt;/userName&gt;"
                         "&lt;workId&gt;%@&lt;/workId&gt;"
                         "&lt;/request&gt;"
                         "</xml>\n"
                         "</iter:downloadWork>\n",@"zhou",workId];
    
    [self requsetWithBody:bodyMsg success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error) {
        failure(error);
    }];

}


+ (void)requsetWithBody:(NSString *)bodyStr success:(SuccessBlock)success failure:(FailedBlock)failure
{
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:iter=\"http://iterface.mobil.com/\">\n"
                         "<soapenv:Header>\n"
                         "<ptpx>\n"
                         "<username>njptpeixian</username>\n"
                         "<password>49ba59abbe56e057</password>\n"
                         "</ptpx>\n"
                         "</soapenv:Header>\n"
                         "<soapenv:Body>\n"
                         "%@"
                         "</soapenv:Body>\n"
                         "</soapenv:Envelope>\n",bodyStr
                         ];
    
    NSLog(@"%@",soapMsg);
    //http://120.77.212.148:8888/iodn_ptpx/face.do?wsdl
    //请求发送到的路径
    NSString *urlStr = @"http://192.168.1.217:8888/iodn_ptpx/face.do?wsdl";
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 60;
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapMsg.length] forHTTPHeaderField:@"Content-Length"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error)
     {
         return soapMsg;
     }];

    [manager POST:urlStr parameters:soapMsg success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject                            encoding:NSUTF8StringEncoding];
        //使用自己写的请求方法resultWithDiction进行解析
        
        //通过Block传回数据
        NSString *strUrl = [result stringByReplacingOccurrencesOfString:@"&#xD;" withString:@""];
        //        NSLog(@"-----%@",strUrl);
                strUrl = [strUrl subStringFrom:@"><return>" to:@"</return></"];
                strUrl = [strUrl stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                strUrl = [strUrl stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                success(strUrl);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"%@",error);
            failure(error);
        }
    }];
    

}


@end
