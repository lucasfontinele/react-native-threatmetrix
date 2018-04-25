//
//  TMXReactNative.m
//  TMXReactNative
//
//

#import <Foundation/Foundation.h>
#import "TMXReactNative.h"
#import <React/RCTConvert.h>
#import <MicroBlink/MicroBlink.h>

@interface TMXReactNative ()

@property (nonatomic, strong) NSDictionary* options;

@property (nonatomic, strong) RCTPromiseResolveBlock promiseResolve;

@property (nonatomic, strong) RCTPromiseRejectBlock promiseReject;

@property (nonatomic, strong) NSString* orgId;

@end

// js result keys
static NSString* const kSessionId = @"sessionId";

@implementation TMXReactNative

RCT_EXPORT_MODULE();

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

RCT_REMAP_METHOD(tmx, initiateNativeTMX:(NSString *)orgid
                  fingerprintServer:(NSString *)fingerprintServer
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    self.promiseResolve = resolve;
    self.promiseReject  = reject;
    
    RCTLogInfo(@"starting...");
    TMXProfileController *ttd = [[TMXProfileController alloc] init];
    self.td = ttd;
    
    RCTLogInfo(@"doing Profile...");
    [self.td doProfile];
    
    RCTLogInfo(@"login Okay...");
    while([self.td loginOkay] == NO)
    {
        // If profiling isn't complete, wait before submitting
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeInterval:[[self.td timeout] intValue] sinceDate:[NSDate date]]];
    }
    
    NSDictionary *results  = @{kSessionId : self.td.sessionID};
    [self finishProfilingResults:results];
    
}

RCT_EXPORT_METHOD(sendSession:(NSString *)url) {
    NSString *session   = self.td.sessionID;
}

- (void) finishProfilingResults:(NSDictionary*) results {
    if (self.promiseResolve && results) {
        self.promiseResolve(results);
    }
    
    [self reset];
}

- (void) reset {
    self.promiseResolve = nil;
    self.promiseReject = nil;
    self.options = nil;
}

@end
