//
//  ViewController.m
//  SocketDemo
//
//  Created by yougou-sk on 2017/6/8.
//  Copyright © 2017年 yougou. All rights reserved.
//

#import "ViewController.h"
#import "WGPAsyncSocket.h"
@interface ViewController ()<WGPAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTf;
@property (weak, nonatomic) IBOutlet UITextView *contentView;
- (IBAction)sendFile:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)login:(id)sender;

- (IBAction)logout:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [WGPAsyncSocket shareSocket].delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReadDataWithDic:(NSDictionary *)dic{

    NSLog(@"%@",dic);
    if (dic) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self.contentView.text];
        
        [ms appendString:dic[@"msg"]];
        self.contentView.text = ms;
    }
    
}

- (void)didWriteDataWithTag:(long)tag{

}


- (IBAction)sendFile:(id)sender {
    
    [[WGPAsyncSocket shareSocket] sendDataWithDic:@{
                                                    @"cmd":@"file",
                                                    @"name":@"鹏",
                                                    @"content":self.inputTf.text
                                                    }
     ];

}

- (IBAction)send:(id)sender {
    
    
    [[WGPAsyncSocket shareSocket] sendDataWithDic:@{
                                                    @"cmd":@"msg",
                                                    @"name":@"鹏",
                                                    @"content":self.inputTf.text
                                                    }
     ];

}

- (IBAction)login:(id)sender {
    
    [[WGPAsyncSocket shareSocket] connectToHost];

    [[WGPAsyncSocket shareSocket] sendDataWithDic:@{
                                                    @"cmd":@"login",
                                                    @"name":@"鹏"
                                                    }];

}

- (IBAction)logout:(id)sender {
    
    [[WGPAsyncSocket shareSocket] sendDataWithDic:@{
                                                    @"cmd":@"logout",
                                                    @"name":@"鹏"
                                                    }];
}
@end
