#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@interface AppDelegate () {
    FlutterResult _result;
}

@end

@implementation AppDelegate

BOOL isWechatRegistered = NO;
BOOL handleOpenURLByFluwx = YES;
BOOL isWechatLoginStarted = NO;
BOOL isQQLoginStarted = NO;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
    FlutterMethodChannel *methodChannel =
        [FlutterMethodChannel methodChannelWithName:@"io.xiaoyan.xlive/method_channel"
                                    binaryMessenger:controller];
    FlutterBasicMessageChannel *messageChannel =
        [FlutterBasicMessageChannel messageChannelWithName:@"io.xiaoyan.xlive/message_channel"
                                           binaryMessenger:controller];
    FlutterEventChannel *eventChannel =
        [FlutterEventChannel eventChannelWithName:@"io.xiaoyan.xlive/event_channel"
                                  binaryMessenger:controller];

    [MethodHandler.sharedHandler setMethodChannel:methodChannel];
    [HomekitMessageHandler.sharedHandler setMessageChannel:messageChannel];
    [EventHandler.sharedHandler setEventChannel:eventChannel];
    [MessageHandler.sharedHandler setMessageChannel:messageChannel];

    [[WXResponseHandler defaultManager] setMethodChannel:methodChannel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endBackground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)endBackground {
    NSLog(@"end background");
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_MSEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
      if (isWechatLoginStarted) {
          NSLog(@"cancel wechat login");
          [[WXResponseHandler defaultManager] cancelLogin];
          isWechatLoginStarted = NO;
      }
      if (isQQLoginStarted) {
          [QQResponseHandler.sharedHanler cancelQQLogin];
          isQQLoginStarted = NO;
      }
    });
    [HomeStore.sharedStore accessoryReadCharacteristicValue];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    [QQApiInterface handleOpenURL:url delegate:QQResponseHandler.sharedHanler];
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    [WXApi handleOpenURL:url delegate:[WXResponseHandler defaultManager]];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
    [QQApiInterface handleOpenURL:url delegate:QQResponseHandler.sharedHanler];
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    [WXApi handleOpenURL:url delegate:[WXResponseHandler defaultManager]];
    return YES;
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    [QQApiInterface handleOpenURL:url delegate:QQResponseHandler.sharedHanler];
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    [WXApi handleOpenURL:url delegate:[WXResponseHandler defaultManager]];
    return YES;
}

@end
