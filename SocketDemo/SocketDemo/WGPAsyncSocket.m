//
//  WGPAsyncSocket.m
//  SocketDemo
//
//  Created by yougou-sk on 2017/6/8.
//  Copyright © 2017年 yougou. All rights reserved.
//

#import "WGPAsyncSocket.h"



@implementation WGPAsyncSocket




#pragma mark - public method

- (BOOL)connectToHost{
    
    NSString *host = @"10.0.60.65";
    uint16_t port = 8088;
    
    NSError *error;
    
    BOOL sucess = NO ;
    if (!self.socket.isConnected) {
        
        sucess = [self.socket connectToHost:host onPort:port error:&error];
        
        if (error) {
            NSLog(@"%@",error);
        }
    }
    
    return sucess;
}

- (void)sendDataWithDic:(NSDictionary *)dic{

    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    [self.socket writeData:data withTimeout:-1 tag:1];
}

#pragma mark - GCDAsyncSocket delegate

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到消息：%@",msg);
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    [sock readDataWithTimeout:-1 tag:100];
    
    if (self.delegate) {
        
        [self.delegate  didReadDataWithDic:jsonDict];
    }
    

}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{

    NSLog(@"发送成功");
    
    [sock readDataWithTimeout:-1 tag:100];

}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{

    NSLog(@"%@:连接成功",host);
    
    [sock readDataWithTimeout:-1 tag:100];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    NSLog(@"%@:连接失败",err);

}




- (GCDAsyncSocket *)socket{

    if (!_socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _socket;
}

+ (WGPAsyncSocket *)shareSocket{
    static WGPAsyncSocket *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self alloc];
    });
    
    return instance;
}

@end
