//
//  BZNetManger.m
//  BZLib
//
//  Created by zmj on 16/6/3.
//  Copyright © 2016年 zmj. All rights reserved.
//

#import "BZNetManger.h"
static BZNetManger* manger = nil;
@interface BZNetManger()
- (void)fail:(ASIHTTPRequest *)request;
- (void)finish:(ASIHTTPRequest *)request;
@end
@implementation BZNetManger
@synthesize postQueue = _postQueue;
@synthesize delegate;

//@synthesize <#property#>
+(BZNetManger*)sharedManger{
    if (!manger) {
        manger = [[BZNetManger alloc] init];
        manger.postQueue = [ASINetworkQueue queue];
    }
    return manger;
}

- (void)closeAllConnections{
    
}
- (NSUInteger)numberOfConnections{
    return [_connections count];
}
- (NSArray *)connectionIdentifiers{
    return [_connections allKeys];
}


//拼接请求地址
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed{
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@",
                               name, [self _encodeString:[params objectForKey:name]]]];
            
        }
    }
    
    return str;
}

//过滤特殊字符
- (NSString *)_encodeString:(NSString *)string{
    NSRange range = [string rangeOfString:@"%"];
    if (range.location != NSNotFound)
        return string;
    NSString *result =[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet ]];
    return result;
}

//发送请求 post string
- (void)_sendRequestWithPath:(NSString *)path
             queryParameters:(NSMutableDictionary *)params
                     strBody:(NSString *)bodyData
                responseType:(NSString*)responseType{
    NSData* data = [bodyData dataUsingEncoding:NSUTF8StringEncoding];
    return [self _sendRequestWithPath:path queryParameters:params dataBody:data responseType:responseType];
}

- (void)_sendRequestWithPath:(NSString *)path
             queryParameters:(NSMutableDictionary *)params
                responseType:(NSString*)responseType{
    return [self _sendRequestWithPath:path queryParameters:params dataBody:nil responseType:responseType];
}

//发送请求 post data
- (void)_sendRequestWithPath:(NSString *)path
             queryParameters:(NSMutableDictionary *)params
                    dataBody:(NSData *)bodyData
                responseType:(NSString*)responseType{
    NSString* url = [self _queryStringWithBase:path parameters:params prefixed:YES];
    BZNetTask *request = [BZNetTask requestWithURL:[NSURL URLWithString:url] andType:responseType];
    [request setDelegate:self];
    if(bodyData){
        [request setPostBody:[NSMutableData dataWithData:bodyData]];
    }
    [request setDidFailSelector:@selector(fail:)];
    [request setDidFinishSelector:@selector(finish:)];
    [_postQueue addOperation:request];
    [_postQueue go];
}

//判断是否存在这种链接
- (BOOL)isHaveConnection:(NSString*)responseType{
    for (BZNetTask *connection in [_connections allValues]) {
        if (connection.responseType == responseType) {
            return YES;
        }
    }
    return NO;
}

//取消某种链接
- (void)closeConnect:(NSString*)responseType{
}

//生成post image data
- (NSData *)uniteDataFromImage:(UIImage *)image{
    NSData* imgData = UIImageJPEGRepresentation(image, 1.0f);
    
    NSMutableData *body = [NSMutableData data];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"filename\"; filename=\"image.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imgData];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}
- (NSData *)uniteDataFromParam:(NSDictionary *)dicParams{
    NSMutableData *body = [NSMutableData data];
    NSArray *arrKeys = [dicParams allKeys];
    for (NSString *strKey in arrKeys) {
        NSString *strContent = [dicParams objectForKey:strKey];
        if (strContent) {
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\"\r\n",strKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[strContent dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return body;
}
#pragma mark--
#pragma mark HTTPRESPONSE
- (void)fail:(ASIHTTPRequest *)request
{
    NSString* menthed = [(BZNetTask*)request responseType];
    NSDictionary* dic = [(BZNetTask*)request responseData];
    if (delegate && [delegate respondsToSelector:@selector(onResponseFail:response:)]) {
//        [delegate onResponseFinish:menthed response:menthed.]
    }
}
- (void)finish:(ASIHTTPRequest *)request
{
    NSString* menthed = [(BZNetTask*)request responseType];
    NSDictionary* dic = [(BZNetTask*)request responseData];

    if (delegate && [delegate respondsToSelector:@selector(onResponseFinish:response:)]) {
        //        [delegate onResponseFinish:menthed response:menthed.]
    }
}
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
//    NSLog(@"%@",[NS])
    [(BZNetTask*)request appendData:data];
}

@end
