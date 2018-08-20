//
//  CocoaSocketManager.h
//  CocoaSocket
//
//  Created by grx on 2018/8/20.
//  Copyright © 2018年 grx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CocoaSocketManager : NSObject

@property (copy, nonatomic) void(^TcpConnectBlock)(NSString *tcpBackStr);
@property (copy, nonatomic) void(^TcpErrorBlock)(NSError *error);

+ (instancetype)shareHBTCPSocketManager;

/** 连接服务 */
- (int)connectServer:(NSString *)hostIP port:(int)hostPort;
/** 发送数据 */
- (void)sendWithDataStr:(NSString *)dataStr;
/** 断开链接 */
- (void)disconnectSocket;

@end
