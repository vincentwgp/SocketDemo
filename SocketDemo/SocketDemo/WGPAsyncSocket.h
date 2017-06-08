//
//  WGPAsyncSocket.h
//  SocketDemo
//
//  Created by yougou-sk on 2017/6/8.
//  Copyright © 2017年 yougou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

@protocol WGPAsyncSocketDelegate <NSObject>

- (void)didReadDataWithDic:(NSDictionary *)dic;
- (void)didWriteDataWithTag:(long)tag;

@end

@interface WGPAsyncSocket : NSObject<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *socket;

@property (nonatomic,weak) id<WGPAsyncSocketDelegate> delegate;


/**
 连接服务器
 */
- (BOOL)connectToHost;

/**
 发送数据

 @param dic ：
 */
- (void)sendDataWithDic:(NSDictionary *)dic;

+ (WGPAsyncSocket *)shareSocket;
@end
