//
//  TableViewController.m
//  SocketDemo
//
//  Created by yougou-sk on 2017/6/8.
//  Copyright © 2017年 yougou. All rights reserved.
//

#import "TableViewController.h"
#import <GCDAsyncSocket.h>

@interface TableViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) NSMutableArray *clientSocket;
@end

@implementation TableViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        
        NSError *err;
        [self.serverSocket acceptOnPort:8088 error:&err];
        
        if (!err) {
            NSLog(@"服务开启成功");
        }else{
            NSLog(@"服务开启失败:%@",err);
        }
        
    }
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
