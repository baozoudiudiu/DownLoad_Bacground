//
//  ViewController.m
//  DownloadBackgroundTest
//
//  Created by chenwang on 2017/6/26.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import "ViewController.h"
#import "NSURLSession+CorrectedResumeData.h"

@interface ViewController ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIButton   *button;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@end

@implementation ViewController

#pragma mark - < Life Cycle >
- (instancetype)init {
    
    if(self = [super init]) {
        
        self.url = @"http://vod3.nty.tv189.cn/6/mobi/vod/st02/2017/01/11/Q200_0cfd7439-cdc3-4279-8414-b966b54da79a.3gp?sign=6be394c33dcc1241f4c58a7bc873f8b6&qualityCode=253&version=1&guid=4afaf708-6517-96e7-4581-78f25c75c175&app=111010310225&cookie=9d77f3fb6f7fbb4eeeecafd94cf4f6fb&session=9d77f3fb6f7fbb4eeeecafd94cf4f6fb&uid=104318900000021130118&uname=18900000021&time=20170627090606&videotype=4&cid=C39504092&cname=&cateid=&dev=000001&ep=2&os=30&ps=0099&clienttype=x86_64&appver=1.15.1.4&res=750%252A1334&channelid=&pid=1000000432&orderid=1100339630570&nid=&cp=00000175&sp=00000014&ip=101.81.59.138&ipSign=5a94bab56dee27fc57043f4c1265baaa&cdntoken=api_5951af7e6c325&a=YkekjSd2P5e7D4HB0GDBCgpbaq%252BDJ55kt%252BBXLDts%252FYtfnCjJ1BJzu7zGjGcrW1hx&pvv=&t=5951e7be&cf=tx&s2=a87ff679a2f3e71d9181a67b7542122c";
        
        
    }
    return self;
}

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resumeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"resumeData"];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [NSString stringWithFormat:@"%@/test.3gp",documentsDirectory];
    if([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    
    self.url = @"http://vod3.nty.tv189.cn/6/mobi/vod/st02/2017/01/11/Q200_0cfd7439-cdc3-4279-8414-b966b54da79a.3gp?sign=6be394c33dcc1241f4c58a7bc873f8b6&qualityCode=253&version=1&guid=4afaf708-6517-96e7-4581-78f25c75c175&app=111010310225&cookie=9d77f3fb6f7fbb4eeeecafd94cf4f6fb&session=9d77f3fb6f7fbb4eeeecafd94cf4f6fb&uid=104318900000021130118&uname=18900000021&time=20170627090606&videotype=4&cid=C39504092&cname=&cateid=&dev=000001&ep=2&os=30&ps=0099&clienttype=x86_64&appver=1.15.1.4&res=750%252A1334&channelid=&pid=1000000432&orderid=1100339630570&nid=&cp=00000175&sp=00000014&ip=101.81.59.138&ipSign=5a94bab56dee27fc57043f4c1265baaa&cdntoken=api_5951af7e6c325&a=YkekjSd2P5e7D4HB0GDBCgpbaq%252BDJ55kt%252BBXLDts%252FYtfnCjJ1BJzu7zGjGcrW1hx&pvv=&t=5951e7be&cf=tx&s2=a87ff679a2f3e71d9181a67b7542122c";
//    [[NSUserDefaults standardUserDefaults] setObject:@(totalBytesWritten) forKey:@"totalBytesWritten"];
//    [[NSUserDefaults standardUserDefaults] setObject:@(totalBytesExpectedToWrite) forKey:@"totalBytesExpectedToWrite"];
    [self.progressView setProgress:[[[NSUserDefaults standardUserDefaults] objectForKey:@"totalBytesWritten"] floatValue] / [[[NSUserDefaults standardUserDefaults] objectForKey:@"totalBytesExpectedToWrite"] floatValue]];
}

#pragma mark - < Event Response >
- (IBAction)buttonClick:(UIButton *)sender {
    if(sender.tag == 0) {
        if(!self.task && !self.resumeData) {
            
            NSURLSession *session = self.session;
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            NSString *range = [NSString stringWithFormat:@"bytes=%zd-", 0];
            [request setValue:range forHTTPHeaderField:@"Range"];
            
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
            self.task = task;
            
        }
        if(self.resumeData) {
            
            self.task = [self.session downloadTaskWithCorrectResumeData:self.resumeData];
        }
        [self.task resume];
    }
    else if(sender.tag == 1){
        
    }else if(sender.tag == 2) {
        
        //
        __weak typeof  (&*self) weakSelf = self;
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            weakSelf.resumeData = resumeData;
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.resumeData forKey:@"resumeData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        self.task = nil;
    }else if(sender.tag == 3) {
        
    }
    
}
#pragma mark -
#pragma mark - -- < 下载相关代理 >


///下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"local : %@", location.absoluteString);
    
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    if([manager moveItemAtPath:location.path toPath:[NSString stringWithFormat:@"%@/test.3gp",documentsDirectory] error:&error]) {
        
        NSLog(@"download success : %@", documentsDirectory);
    }else {
        
        if(error) {
            
            NSLog(@"download error : %@", error);
        }
    }
}

///正在下载中
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    [self.progressView setProgress:totalBytesWritten / (CGFloat)totalBytesExpectedToWrite];
    
    NSLog(@"%lf", totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
    
    [[NSUserDefaults standardUserDefaults] setObject:@(totalBytesWritten) forKey:@"totalBytesWritten"];
    [[NSUserDefaults standardUserDefaults] setObject:@(totalBytesExpectedToWrite) forKey:@"totalBytesExpectedToWrite"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///恢复下载调用(断点续传要用)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    [self.progressView setProgress:fileOffset / (CGFloat)expectedTotalBytes];
}

/* 在任务下载完成、下载失败
 * 或者是应用被杀掉后，重新启动应用并创建相关identifier的Session时调用
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    if (error) {
//        // check if resume data are available
//        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
//            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
//            self.task = [[self session] downloadTaskWithResumeData:resumeData];
//            [self.task resume];
//        }
//    }
}

//NSURLSessionDelegate委托方法，会在NSURLSessionDownloadDelegate委托方法后执行
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"Background URL session %@ finished events.\n", session);
    if (session.configuration.identifier) {
        // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
                [self callCompletionHandlerForSession:session.configuration.identifier];
    }
}
- (void)callCompletionHandlerForSession:(NSString *)identifier {
    
    [self.view addSubview:self.progressView];
    [self.progressView setProgress:1];
    if (self.complete) {
        self.complete();
    }
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}

#pragma mark - < Property >
- (NSURLSession *)session {
    
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"id"] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    });
    return session;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
