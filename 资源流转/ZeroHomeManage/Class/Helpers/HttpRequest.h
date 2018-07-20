//
//  HttpRequest.h
//  Himi
//
//  Created by NPHD on 14-9-2.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject
@property(nonatomic,strong)NSMutableArray *CkeckArray;

+(HttpRequest *)sharedHttpRequest;
//通过url获取数据
-(void)getNewsWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url IsSava:(BOOL)Save;
-(void)PostNewsWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh;
-(void)Post1NewsWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh;

-(void)PostRequestDataWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh;

//xml请求数据
-(void)PostRequestXMLDataWithFinish:(void (^)(NSString * errMsg,id jsonObj))finishHandler Error:(void(^)(NSString* errMsg,id jsonObj))Error byUrl:(NSString*)url parameters:(NSDictionary *)parameters IsSava:(BOOL)save delegate:(id)delegate isRefresh:(BOOL)refresh;

//获取网络连接状态
-(void)getLinkStatus:(void (^)(NSInteger linkStatus))finishHandler;

-(void)stop;
@end
