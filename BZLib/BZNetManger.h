//
//  BZNetManger.h
//  BZLib
//
//  Created by zmj on 16/6/3.
//  Copyright © 2016年 zmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "BZNetTask.h"

@protocol BZNetMangerDelegate <NSObject>

-(void)onResponseFinish:(NSString*)menthed response:(NSDictionary*)response;
-(void)onResponseFail:(NSString*)menthed response:(NSDictionary*)response;
-(void)onResponseTimeOut:(NSString*)menthed response:(NSDictionary*)response;

@end

@interface BZNetManger : NSObject
{
    NSMutableDictionary *_connections;
    ASINetworkQueue *_postQueue;
    id<BZNetMangerDelegate> delegate;
}
@property (nonatomic,retain) ASINetworkQueue *postQueue;
@property (nonatomic,retain) id<BZNetMangerDelegate> delegate;

+ (BZNetManger*)sharedManger;
- (void)closeAllConnections;
- (NSUInteger)numberOfConnections;
- (NSArray *)connectionIdentifiers;


//拼接请求地址
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;

//过滤特殊字符
- (NSString *)_encodeString:(NSString *)string;

//发送请求 post string
- (void)_sendRequestWithPath:(NSString *)path
             queryParameters:(NSMutableDictionary *)params
                     strBody:(NSString *)bodyData
                responseType:(NSString*)responseType;

- (void)_sendRequestWithPath:(NSString *)path
             queryParameters:(NSMutableDictionary *)params
                responseType:(NSString*)responseType;

//发送请求 post data
- (void)_sendRequestWithPath:(NSString *)path
             queryParameters:(NSMutableDictionary *)params
                    dataBody:(NSData *)bodyData
                responseType:(NSString*)responseType;

//判断是否存在这种链接
- (BOOL)isHaveConnection:(NSString*)responseType;

//取消某种链接
- (void)closeConnect:(NSString*)responseType;

//生成post image data
- (NSData *)uniteDataFromImage:(UIImage *)image;
- (NSData *)uniteDataFromParam:(NSDictionary *)dicParams;

@end
