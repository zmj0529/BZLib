//
//  BZNetTask.h
//  BZLib
//
//  Created by zmj on 16/6/7.
//  Copyright © 2016年 zmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface BZNetTask : ASIHTTPRequest
{
    NSString* _responseType;
    NSMutableData * _htmlData;
    NSString *_identifier;
}
@property (nonatomic,retain) NSString* responseType;
@property (nonatomic,retain) NSMutableData* htmlData;

+ (BZNetTask*)requestWithURL:(NSURL *)newURL andType:(NSString*)type;
- (BZNetTask*)initWihtURL:(NSURL *)newURL andType:(NSString*)type;

- (void)appendData:(NSData *)data;
-(NSDictionary*)responseData;
@end
