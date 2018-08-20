//
//  CocoaSocketManager.m
//  CocoaSocket
//
//  Created by grx on 2018/8/20.
//  Copyright © 2018年 grx. All rights reserved.
//

#import "CocoaSocketManager.h"
#import "GCDAsyncSocket.h"

@interface CocoaSocketManager () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, copy) NSString *dataStr;

@end

static CocoaSocketManager *_manager = nil;
@implementation CocoaSocketManager


+ (instancetype)shareHBTCPSocketManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager == nil) {
            _manager = [super allocWithZone:zone];
        }
    });
    return _manager;
}

- (int)connectServer:(NSString *)hostIP port:(int)hostPort {
    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *err = nil;
        int t = [_socket connectToHost:hostIP onPort:hostPort withTimeout:10 error:&err];
        if (!t) {
            return 0;
        }else{
            return 1;
        }
    }else {
        [_socket readDataWithTimeout:-1 tag:0];
        return 1;
    }
}

// 发送命令
- (void)sendWithDataStr:(NSString *)dataStr {
    NSLog(@"to : %@",dataStr);
    self.dataStr = dataStr;
    NSData *data =[dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)disconnectSocket {
    [self.socket disconnect];
}

// 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    BOOL state = [self.socket isConnected];  //判断是否连接成功
    if (state) {
        NSLog(@"socket 连接成功");
    }else {
        NSLog(@"socket 没有连接");
    }
    [self.socket readDataWithTimeout:-1 tag:0]; //WithTimeout 是超时时间,-1表示一直读取数据
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

// 读取数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString* aStr = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"from :  %@",aStr);
    if (aStr.length > 0) {
        if (self.TcpConnectBlock) {
            self.TcpConnectBlock(aStr);
        }
    }
    [self.socket disconnect];
}

// 断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"断开连接 %@ ", err);
    BOOL state = [_socket isConnected];   // 判断当前socket的连接状态
    NSLog(@"state %d",state);
    self.socket=nil;
    if (err) {
        if (self.TcpErrorBlock) {
            self.TcpErrorBlock(err);
        }
    }
}

@end
