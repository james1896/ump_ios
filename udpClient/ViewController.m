//
//  ViewController.m
//  udpClient
//
//  Created by toby on 16/07/2017.
//  Copyright © 2017 kg.self.edu. All rights reserved.
//

#import "ViewController.h"

#import "GCDAsyncUdpSocket.h"
#define SERVIC_PORT 9527

#define LOCAL_PORT 2501
#define ipAddress @"10.71.66.2"

@interface ViewController ()<GCDAsyncUdpSocketDelegate>{
    NSInteger flag;
}


@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, copy) NSString *serviceAddress;

@end

@implementation ViewController


- (IBAction)sendData:(id)sender {
    
     [_udpSocket sendData:[[NSString stringWithFormat:@"flag %ld",flag++] dataUsingEncoding:NSUTF8StringEncoding]
                   toHost:ipAddress
                     port:SERVIC_PORT
              withTimeout:-1 tag:0];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    NSError *error = nil;
    if(![_udpSocket bindToPort :LOCAL_PORT error:&error])
    {
        NSLog(@"error in bindToPort");
        //return;
    }else{
        NSLog(@"bindToPort success  And  send data");
        [_udpSocket beginReceiving:&error];
       
    }
}

//send
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}

//receive
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    
    
    NSLog(@"接收到的消息:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);//自行转换格式吧
    
    NSLog(@"server adrress:%@",[[NSString alloc]initWithData:address encoding:NSUTF8StringEncoding]);
}


@end
