//
//  SystemMethodHandle.m
//  Runner
//
//  Created by litao on 2018/11/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "SystemMethodHandler.h"

@interface SystemMethodHandler () <AVCaptureMetadataOutputObjectsDelegate> {
    UIViewController *_qrcodeViewController;
    UIWindow *_prewindow;
    UIView *_qrcodeView;
    UILabel *_text;
    AVCaptureSession *_scanSession;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    UIImageView *_scanPan;
    UIImageView *_scanLine;
    UIImageView *_iconBack;
    UIView *_barView;
    UILabel *_title;
    UIView *_backView;
}
@end

@implementation SystemMethodHandler

+ (instancetype)sharedHandler {
    static SystemMethodHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[SystemMethodHandler alloc] init];
    });
    return instance;
}

- (void)handleGetClientId {
    [MethodHandler.sharedHandler resultString:@"xy_ios_mnkty87sj6HGddf5"];
}

- (void)handleGetClientType {
    [MethodHandler.sharedHandler resultString:@"ios_"];
}

- (void)handleGetPlatform {
    [MethodHandler.sharedHandler resultString:@"iOS"];
}

- (void)handleGetSyetemVersion {
    NSString *version = UIDevice.currentDevice.systemVersion;
    [MethodHandler.sharedHandler resultDouble:version.doubleValue];
}

- (void)handleGetAppVersion {
    NSDictionary *info = NSBundle.mainBundle.infoDictionary;
    NSString *appVersion = [info objectForKey:@"CFBundleShortVersionString"];
    [MethodHandler.sharedHandler resultString:appVersion];
}

- (void)handleGetHttpAgent {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *agent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [MethodHandler.sharedHandler resultString:agent];
}

- (void)handleScanLocalService {
    [ServiceDetector.sharedInstance startBrowsing];
    [MethodHandler.sharedHandler resultBool:true];
}

- (void)handleGetFoundLocalServices {
    [MessageHandler.sharedHandler handleGetFoundedLocalServices];
    [MethodHandler.sharedHandler resultBool:true];
}

- (void)handleScanQRCode:(NSString *)title text:(NSString *)text {
    CGFloat width = UIScreen.mainScreen.applicationFrame.size.width;
    CGFloat height = UIScreen.mainScreen.applicationFrame.size.height;
    CGFloat ration = (CGFloat)0.6;
    _scanPan = [[UIImageView alloc] init];
    [_scanPan setFrame:CGRectMake(width / 2 - ration * width / 2, height / 2 - ration * width / 2,
                                  ration * width, ration * width)];
    [_scanPan setImage:[UIImage imageNamed:@"scan_box"]];
    [_scanPan setContentMode:UIViewContentModeRedraw];
    _scanLine = [[UIImageView alloc] init];
    [_scanLine setFrame:CGRectMake(0, 0, _scanPan.bounds.size.width, 3)];
    [_scanLine setImage:[UIImage imageNamed:@"scan_line"]];

    [self showQRCodeView:title text:text];
}

- (void)showQRCodeView:(NSString *)title text:(NSString *)text {
    _qrcodeViewController = [[UIViewController alloc] init];
    CGFloat statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    _barView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.applicationFrame.size.width,
                                 40 + statusBarHeight)];
    [_barView setBackgroundColor:[UIColor whiteColor]];
    _title = [[UILabel alloc]
        initWithFrame:CGRectMake(UIScreen.mainScreen.applicationFrame.size.width / 2 - 50,
                                 statusBarHeight + 11, 100, 18)];
    [_title setTextAlignment:NSTextAlignmentCenter];
    [_title setText:title];
    [_title setTextColor:[UIColor blackColor]];
    [_title setFont:[UIFont systemFontOfSize:18]];
    [_title setBackgroundColor:[UIColor clearColor]];
    _iconBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, statusBarHeight + 12, 9, 16)];
    _iconBack.image = [UIImage imageNamed:@"icon_back"];

    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, 40, 40)];
    [_backView setUserInteractionEnabled:YES];
    [_backView
        addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(popBack)]];

    _prewindow = UIApplication.sharedApplication.delegate.window;
    _prewindow.hidden = YES;
    UIWindow *newWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIApplication.sharedApplication.delegate.window = newWindow;
    newWindow.rootViewController = _qrcodeViewController;
    [newWindow makeKeyAndVisible];
    [self loadViewQRCode:text];
    [self viewQRCodeDidLoad];
}

- (void)loadViewQRCode:(NSString *)content {
    CGFloat width = UIScreen.mainScreen.applicationFrame.size.width;
    CGFloat height = UIScreen.mainScreen.applicationFrame.size.height;
    // CGFloat ration = (CGFloat) 0.6;

    _qrcodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_qrcodeView setOpaque:YES];
    [_qrcodeView setBackgroundColor:UIColor.clearColor];
    _qrcodeViewController.view = _qrcodeView;
    [_qrcodeView insertSubview:_scanPan atIndex:0];
    [_scanPan addSubview:_scanLine];

    [self setupScanSession];

    _text = [[UILabel alloc] init];
    _text.frame =
        CGRectMake(0, _scanPan.frame.origin.y + _scanPan.frame.size.height + 20, width, 20);
    [_text setTextAlignment:NSTextAlignmentCenter];
    [_text setText:content];
    [_text setTextColor:UIColor.blackColor];
    [_text setBackgroundColor:UIColor.clearColor];
    [_text setFont:[UIFont systemFontOfSize:12]];
}

- (void)viewQRCodeDidLoad {
    [[_qrcodeViewController view] addSubview:_barView];
    [[_qrcodeViewController view] addSubview:_iconBack];
    [[_qrcodeViewController view] addSubview:_backView];
    [[_qrcodeViewController view] addSubview:_title];
    [[_qrcodeViewController view] addSubview:_scanPan];
    [[_qrcodeViewController view] addSubview:_text];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(startScan)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)startScan {
    [_scanLine.layer addAnimation:[self scanAnimation] forKey:@"scan"];
    if (_scanSession == nil) {
        return;
    }
    if (![_scanSession isRunning]) {
        [_scanSession startRunning];
    }
}

- (CABasicAnimation *)scanAnimation {
    CGPoint startPoint = CGPointMake(_scanLine.center.x, 1);
    CGPoint endPoint = CGPointMake(_scanLine.center.x, _scanPan.bounds.size.height - 2);
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.fromValue = [NSValue valueWithCGPoint:startPoint];
    translation.toValue = [NSValue valueWithCGPoint:endPoint];
    translation.duration = 4.0;
    translation.repeatCount = MAXFLOAT;
    translation.autoreverses = YES;
    return translation;
}

- (void)setupScanSession {
    AVAuthorizationStatus status =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied) {
        NSString *tips = [[NSBundle mainBundle] localizedStringForKey:@"No access to camera"
                                                                value:@""
                                                                table:nil];
        [_qrcodeView makeToast:tips];
        return;
    }

    AVCaptureDevice *device = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].firstObject;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:NULL];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // AVCaptureSession* scanSession = [[AVCaptureSession alloc] init];
    NSLog(@"init scan session");
    _scanSession = [[AVCaptureSession alloc] init];
    [_scanSession canSetSessionPreset:AVCaptureSessionPresetHigh];
    if ([_scanSession canAddInput:input]) {
        [_scanSession addInput:input];
    }
    if ([_scanSession canAddOutput:output]) {
        [_scanSession addOutput:output];
    }
    output.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ];
    AVCaptureVideoPreviewLayer *scanPreviewLayer =
        [[AVCaptureVideoPreviewLayer alloc] initWithSession:_scanSession];
    scanPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    scanPreviewLayer.frame = UIScreen.mainScreen.applicationFrame;
    [[_qrcodeView layer] addSublayer:scanPreviewLayer];
    //    [[NSNotificationCenter defaultCenter] addObserver:<#(nonnull id)#> selector:<#(nonnull
    //    SEL)#> name:[NSNotificationName AVCaptureInputPortFormatDescriptionDidChangeNotification]
    //    object:NULL];
    // self.scanSession = scanSession;
}

- (void)captureOutput:(AVCaptureOutput *)output
    didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
              fromConnection:(AVCaptureConnection *)connection {
    [_scanLine.layer removeAllAnimations];
    [_scanSession stopRunning];

    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *resultObj = [metadataObjects objectAtIndex:0];
        //_result([resultObj stringValue]);
        [MethodHandler.sharedHandler resultString:[resultObj stringValue]];
        NSLog(@"result");
        UIApplication.sharedApplication.delegate.window = _prewindow;
        [_prewindow makeKeyAndVisible];
        _prewindow.hidden = NO;
    }
}

- (void)popBack {
    [_scanLine.layer removeAllAnimations];
    [_scanSession stopRunning];

    UIApplication.sharedApplication.delegate.window = _prewindow;
    _prewindow.hidden = NO;
    [_prewindow makeKeyAndVisible];
}

@end
