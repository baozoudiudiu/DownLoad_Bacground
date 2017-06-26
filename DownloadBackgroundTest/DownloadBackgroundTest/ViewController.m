//
//  ViewController.m
//  DownloadBackgroundTest
//
//  Created by chenwang on 2017/6/26.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIButton   *button;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //
    self.url = @"http://vod3.nty.tv189.cn/6/mobi/vod/ts01/TVM/video/3gp/TVM/HuNanHD/2017/06/08/68be2673-c7b1-400e-8f11-50c87004cec5/Q350/Q350.3gp?sign=f05f57f53e03e60e968cf04bcb65f9ec&qualityCode=452&version=1&guid=122ccef8-2f63-61d8-53ea-27a3ba714e2a&app=111010310225&cookie=614ecaeeacee06494b8209ce889a6d58&session=614ecaeeacee06494b8209ce889a6d58&uid=104318900000021130118&uname=18900000021&time=20170626152724&videotype=4&cid=C40129833&cname=&cateid=&dev=000001&ep=8&os=30&ps=0099&clienttype=iPod7%252C1&appver=1.15.1.4&res=640%252A1136&channelid=&pid=1000000228&orderid=1100339630570&nid=&cp=00000175&sp=00000014&ip=101.81.59.138&ipSign=f8a8c5269a88de224d96ab1fc85d1728&cdntoken=api_5950b75cdfcd0&a=qtLFG8CsZ8PHhDjpAX3BvfNXME7VYlr0P%252BwRlE5qk0vOqsnP%252B6E5xBIPyG6BR%252B%252F4&pvv=&t=5950ef9c&cf=tx&s2=a0a080f42e6f13b3a2df133f073095dd";
    
    [self.progressView setProgress:0];
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if(sender.tag == 0) {
        if(!self.session || !self.task) {
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"id"] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            NSString *range = [NSString stringWithFormat:@"bytes=%zd-", 0];
            [request setValue:range forHTTPHeaderField:@"Range"];
            
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
            
            self.session = session;
            self.task = task;
        }
        [self.task resume];
        sender.tag = 1;
    }
    else {
        
        [self.task suspend];
        sender.tag = 0;
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    [self.progressView setProgress:totalBytesWritten / (CGFloat)totalBytesExpectedToWrite];
    
    NSLog(@"%lf", totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
