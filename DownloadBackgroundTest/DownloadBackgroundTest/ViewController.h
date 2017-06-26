//
//  ViewController.h
//  DownloadBackgroundTest
//
//  Created by chenwang on 2017/6/26.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) void (^complete)(void);
@end

