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


@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@end

@implementation ViewController

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.url = @"http://vod3.nty.tv189.cn/6/mobi/vod/ts01/TVM/video/3gp/TVM/HuNanHD/2017/06/12/e5372776-626b-463c-89d5-c6d8540bed7c/Q350/Q350.3gp?sign=4688252dbe32506130e962c083529c36&qualityCode=452&version=1&guid=a394b6e5-273b-0077-f008-a82b7d18c36b&app=111010310225&cookie=058dc7c3114c237754a13ac95f7b70b0&session=058dc7c3114c237754a13ac95f7b70b0&uid=104318900000021130118&uname=18900000021&time=20170626210600&videotype=4&cid=C40142615&cname=&cateid=&dev=000001&ep=10&os=30&ps=0099&clienttype=x86_64&appver=1.15.1.4&res=1242%252A2208&channelid=&pid=1000000228&orderid=1100339630570&nid=&cp=00000175&sp=00000014&ip=223.166.74.223&ipSign=f3f15746a82bf41ef2cd792ef4981f3a&cdntoken=api_595106b888ce5&a=z2vOo%252F%252BR7mpA2EA4R7NhAZI4dG8FubQF0BFcEfW4gYGdzmkbBcVeINizmnO8yM%252Fu&pvv=&t=59513ef8&cf=tx&s2=cfcd208495d565ef66e7dff9f98764da";
        
        
    }
    return self;
}

- (void)rilegou:(NSNotification *)notify {
    
    NSLog(@".....");
    
    [[NSUserDefaults standardUserDefaults] setObject:@(10000) forKey:@"testKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rilegou:) name:UIApplicationWillTerminateNotification object:nil];
    //
    self.url = @"http://vod3.nty.tv189.cn/6/mobi/vod/ts01/TVM/video/3gp/TVM/HuNanHD/2017/06/12/e5372776-626b-463c-89d5-c6d8540bed7c/Q350/Q350.3gp?sign=4688252dbe32506130e962c083529c36&qualityCode=452&version=1&guid=a394b6e5-273b-0077-f008-a82b7d18c36b&app=111010310225&cookie=058dc7c3114c237754a13ac95f7b70b0&session=058dc7c3114c237754a13ac95f7b70b0&uid=104318900000021130118&uname=18900000021&time=20170626210600&videotype=4&cid=C40142615&cname=&cateid=&dev=000001&ep=10&os=30&ps=0099&clienttype=x86_64&appver=1.15.1.4&res=1242%252A2208&channelid=&pid=1000000228&orderid=1100339630570&nid=&cp=00000175&sp=00000014&ip=223.166.74.223&ipSign=f3f15746a82bf41ef2cd792ef4981f3a&cdntoken=api_595106b888ce5&a=z2vOo%252F%252BR7mpA2EA4R7NhAZI4dG8FubQF0BFcEfW4gYGdzmkbBcVeINizmnO8yM%252Fu&pvv=&t=59513ef8&cf=tx&s2=cfcd208495d565ef66e7dff9f98764da";
    
    [self.progressView setProgress:0];
    
    NSLog(@"------%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]);
    id di = [[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"];
    if(di != nil) {
        
        self.view.backgroundColor = [UIColor orangeColor];
    }
    
}

- (IBAction)buttonClick:(UIButton *)sender {
    if(sender.tag == 0) {
        if(!self.task) {
            
            NSURLSession *session = self.session;
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            NSString *range = [NSString stringWithFormat:@"bytes=%zd-", 0];
            [request setValue:range forHTTPHeaderField:@"Range"];
            
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
            self.task = task;
            
        }
        [self.task resume];
        sender.tag = 1;
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
    else {
        
        [self.task suspend];
        sender.tag = 0;
        [sender setTitle:@"开始" forState:UIControlStateNormal];
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
