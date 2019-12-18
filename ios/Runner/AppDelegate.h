#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "QQResponseHandler.h"
#import "WXResponseHandler.h"
#import "WXApiHandler.h"
#import "WXAuthHandler.h"
#import "MethodHandler.h"
#import "HomekitMessageHandler.h"

extern BOOL isWechatRegistered;
extern BOOL handleOpenURLByWx;
extern BOOL isWechatLoginStarted;
extern BOOL isQQLoginStarted;

@interface AppDelegate : FlutterAppDelegate

@end
