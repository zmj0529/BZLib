//
//  ViewController.m
//  BZLibTest
//
//  Created by zmj on 16/6/9.
//  Copyright © 2016年 zmj. All rights reserved.
//

#import "ViewController.h"
#import "BZNetManger.h"
@interface ViewController ()

@end

@implementation ViewController
//ttps://www.baidu.com/s?cl=3&tn=baidutop10&fr=top1000&wd=%E9%85%92%E9%A9%BE%E6%8B%BF%E5%84%BF%E9%A9%BE%E7%85%A7%E9%A1%B6%E6%9B%BF&rsv_idx=2
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray* keys = [NSArray arrayWithObjects:@"cl",@"tn",@"fr",@"wd",@"rsv_idx", nil];
//    NSArray* values = [NSArray arrayWithObjects:@"3",@"baidutop10",@"top1000",@"条例拟规精神病人",@"2", nil];
//[NSMutableDictionary dictionaryWithObjects:values forKeys:keys]
    [[BZNetManger sharedManger] _sendRequestWithPath:@"http://allseeing-i.com/ASIHTTPRequest/tests/the_great_american_novel.txt" queryParameters:nil responseType:@"a"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
