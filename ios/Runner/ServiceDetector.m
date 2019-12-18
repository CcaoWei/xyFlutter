//
//  ServiceDetector.m
//  Runner
//
//  Created by litao on 2018/12/21.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "ServiceDetector.h"

@interface ServiceDetector () <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
    BOOL _isBrowsing;
    NSMutableArray<NSNetService *> *_discoveredServices;
    NSMutableDictionary *_discoveredHomeCenters;
}

@end

@implementation ServiceDetector

+ (instancetype)sharedInstance {
    static ServiceDetector *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[ServiceDetector alloc] init];
    });
    return instance;
}

- (void)startBrowsing {
    if (self.browser == nil) {
        self.browser = [[NSNetServiceBrowser alloc] init];
        self.browser.delegate = self;
    }
    if (_isBrowsing) {
        [self.browser stop];
    }
    [self.browser searchForServicesOfType:@"_websocket._tcp" inDomain:@"local."];
    [self.browser scheduleInRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
}

- (void)stopBrowsing {
    if (_isBrowsing) {
        [self.browser stop];
    }
    [_discoveredServices removeAllObjects];
    [_discoveredHomeCenters removeAllObjects];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)service
               moreComing:(BOOL)moreComing {
    NSString *name = service.name;
    NSLog(@"local service found: %@", name);

    if (_discoveredServices == nil) {
        _discoveredServices = [[NSMutableArray alloc] init];
    }
    [_discoveredServices addObject:service];

    service.delegate = self;
    [service resolveWithTimeout:5.0];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)service
               moreComing:(BOOL)moreComing {
    NSString *name = service.name;
    NSLog(@"local service removed: %@", name);

    if (_discoveredHomeCenters != nil && [_discoveredHomeCenters objectForKey:name] != nil) {
        [_discoveredHomeCenters removeObjectForKey:name];

        [EventHandler.sharedHandler localServiceDidLost:name];
    }
}

- (void)netService:(NSNetService *)sender
     didNotResolve:(NSDictionary<NSString *, NSNumber *> *)errorDict {
    NSLog(@"============= %@", errorDict);
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSData *data = sender.TXTRecordData;
    NSDictionary *txtArgs = [NSNetService dictionaryFromTXTRecordData:data];
    for (NSString *key in txtArgs.allKeys) {
        NSString *value = [[NSString alloc] initWithData:[txtArgs objectForKey:key]
                                                encoding:NSUTF8StringEncoding];
        NSLog(@"key: %@ **** value: %@", key, value);
    }
    NSLog(@"host **** %@", sender.hostName);
    NSLog(@"type **** %@", sender.type);
    NSLog(@"ip *** %@", [self IPAddressesFromData:sender]);

    NSString *name = [[NSString alloc] initWithData:[txtArgs objectForKey:@"dn"]
                                           encoding:NSUTF8StringEncoding];
    NSString *version = [[NSString alloc] initWithData:[txtArgs objectForKey:@"sv"]
                                              encoding:NSUTF8StringEncoding];

    HomeCenter *homeCenter = [[HomeCenter alloc] initWithUuid:sender.name
                                                         name:name
                                                           ip:[self IPAddressesFromData:sender]
                                                versionString:version];
    if (_discoveredHomeCenters == nil) {
        _discoveredHomeCenters = [[NSMutableDictionary alloc] init];
    }
    [_discoveredHomeCenters setValue:homeCenter forKey:homeCenter.uuid];

    [EventHandler.sharedHandler localServiceDidFound:homeCenter];
}

- (NSString *)IPAddressesFromData:(NSNetService *)service {
    for (NSData *address in service.addresses) {
        struct sockaddr_in *socketAddress = (struct sockaddr_in *)[address bytes];
        NSString *retSrting = [NSString stringWithFormat:@"%s", inet_ntoa(socketAddress->sin_addr)];
        return retSrting;
    }
    return @"Unknown";
}

- (NSMutableArray<HomeCenter *> *)discoveredHomeCenters {
    NSMutableArray<HomeCenter *> *homeCenters = [[NSMutableArray alloc] init];
    for (HomeCenter *value in _discoveredHomeCenters.allValues) {
        [homeCenters addObject:value];
    }
    return homeCenters;
}

@end
