//
//  ViewController.m
//  CocoaSocket
//
//  Created by grx on 2018/8/20.
//  Copyright © 2018年 grx. All rights reserved.
//
#define HOST_IP   @"192.168.74.9" //IP
#define HOST_PORT 8885            //端口
#import "ViewController.h"
#import "CocoaSocketManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 连接服务 */
    [[CocoaSocketManager shareHBTCPSocketManager] connectServer:HOST_IP port:HOST_PORT];
    /** 发送数据 */
    [[CocoaSocketManager shareHBTCPSocketManager] sendWithDataStr:[NSString stringWithFormat:@"发送内容"]];
    /** 接受数据 */
    [CocoaSocketManager shareHBTCPSocketManager].TcpConnectBlock = ^(NSString *tcpBackStr) {
        NSLog(@"%@",tcpBackStr);

    };
    /** 错误反馈 */
    [CocoaSocketManager shareHBTCPSocketManager].TcpErrorBlock = ^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",error);
        });
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
