//
//  ViewController.m
//  ToolBox
//
//  Created by 高继鹏 on 16/5/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+ExecuteOnce.h"
#import <AVFoundation/AVFoundation.h>

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _showURLTV.text = @"";
    _showURLTV.userInteractionEnabled = NO;
    self.lightningBtn.clipsToBounds = YES;
    self.lightningBtn.layer.cornerRadius = 20.0f;
    self.lightningBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lightningBtn.layer.borderWidth = 0.5f;
    self.lightningBtn.clickOnce = NO;
    [self.lightningBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    
    _lastResut = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 开关闪光灯
- (void)openLight:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (self.lightningBtn.clickOnce) {
            // 关闪光灯
            self.lightningBtn.clickOnce = NO;
            [device setTorchMode:AVCaptureTorchModeOff];
        } else {
            // 开闪光灯
            self.lightningBtn.clickOnce = YES;
            [device setTorchMode:AVCaptureTorchModeOn];
        }
        [device unlockForConfiguration];
    }
}

- (IBAction)startScan:(UIButton*)sender {
    if ([sender.currentTitle isEqualToString:@"开始扫描"]) {
        [sender setTitle:@"停止扫描" forState:UIControlStateNormal
         ];
        [self startReading];
    } else {
        [sender setTitle:@"开始扫描" forState:UIControlStateNormal
         ];
        [self endReading];
    }
}

- (IBAction)goLink:(id)sender {
    if (_showURLTV.text && ![_showURLTV.text isEqualToString:@""]) {
        NSURL *openUrl = [NSURL URLWithString:_showURLTV.text];
        if ([[openUrl scheme] isEqualToString: @"http"] || [[openUrl scheme] isEqualToString:@"https"] || [[openUrl scheme] isEqualToString: @"mailto" ]) {
            [[UIApplication sharedApplication] openURL:openUrl];
        }
    }
}

- (BOOL)startReading {
    // 获取AVCaptureDevice 实例
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 加入输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetaDataOutput];
    
    // 创建dispatch_queue
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetaDataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetaDataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.scanView.layer.bounds];
    [_scanView.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)endReading {
    [_captureSession stopRunning];
    _captureSession = nil;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
        } else {
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

- (void)reportScanResult:(NSString *)result
{
    [self endReading];
    _showURLTV.text = result;
}

- (void)dealloc
{
    [self endReading];
}

@end
