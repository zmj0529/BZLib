//
//  BZNetTask.m
//  BZLib
//
//  Created by zmj on 16/6/7.
//  Copyright © 2016年 zmj. All rights reserved.
//

#import "BZNetTask.h"

@implementation BZNetTask
@synthesize responseType = _responseType;
@synthesize htmlData = _htmlData;

+ (BZNetTask*)requestWithURL:(NSURL *)newURL andType:(NSString*)type{
    BZNetTask* task = [[BZNetTask alloc] initWihtURL:newURL andType:type];
    return task;
}
- (BZNetTask*)initWihtURL:(NSURL *)newURL andType:(NSString*)type{
    if (self=[super initWithURL:newURL]) {
        self.responseType = type;
        self.htmlData = [[NSMutableData alloc] init];

    }
    return self;
}

- (void)appendData:(NSData *)data{
    [_htmlData appendData:data];
}
-(NSDictionary*)responseData{
    
//    NSString *html = [[NSString alloc] initWithData:_htmlData encoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:_htmlData options:NSJSONReadingMutableContainers error:&error];
    return dic;
}
@end
