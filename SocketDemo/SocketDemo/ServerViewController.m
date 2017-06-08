

//
//  ServerViewController.m
//  SocketDemo
//
//  Created by yougou-sk on 2017/6/8.
//  Copyright © 2017年 yougou. All rights reserved.
//

#import "ServerViewController.h"
#import <GCDAsyncSocket.h>

@interface ServerViewController ()<GCDAsyncSocketDelegate>
- (IBAction)startServer:(id)sender;

@property (nonatomic,strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) NSMutableArray *clientSocket;

@end

@implementation ServerViewController

- (NSMutableArray *)clientSocket{

    if (!_clientSocket) {
        _clientSocket = [[NSMutableArray alloc] init];
    }
    
    return _clientSocket;
}

- (GCDAsyncSocket *)serverSocket{

    if (!_serverSocket) {
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return  _serverSocket;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{

    NSLog(@"新连接%@",newSocket);
    [self.clientSocket addObject:newSocket];
    [newSocket readDataWithTimeout:-1 tag:100];
    
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    NSLog(@"客户端发送:%@",jsonDict);
    
    NSString *cmd = jsonDict[@"cmd"];
    
    NSString *sendContent =@"";
    
    if ([cmd isEqualToString:@"login"]) {
        NSString *name = jsonDict[@"name"];
        sendContent = [NSString stringWithFormat:@"%@:加入聊天.\n",name];
    }else if ([cmd isEqualToString:@"msg"]) {
        NSString *name = jsonDict[@"name"];
        NSString *content = jsonDict[@"content"];
        sendContent = [NSString stringWithFormat:@"%@:%@\n",name,content];
    }else if ([cmd isEqualToString:@"logout"]){
        NSString *name = jsonDict[@"name"];
        sendContent = [NSString stringWithFormat:@"%@:退出聊天.\n",name];
        
        [self.clientSocket removeObject:sock];
    }
    
    NSData *sendData=[NSJSONSerialization dataWithJSONObject:@{@"msg":sendContent} options:NSJSONWritingPrettyPrinted error:nil];
    
    for (GCDAsyncSocket *socket in self.clientSocket) {
        [socket writeData:sendData withTimeout:-1 tag:100];

    }

    [sock readDataWithTimeout:-1 tag:100];

}

- (IBAction)startServer:(id)sender {
    NSError *err;
    [self.serverSocket acceptOnPort:8088 error:&err];

    if (!err) {
        NSLog(@"服务开启成功");
    }else{
        NSLog(@"服务开启失败:%@",err);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
