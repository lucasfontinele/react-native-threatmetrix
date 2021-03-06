//
//  TMXProfileController.m
//  TMXReactNative
//
//  Created by Don Onwunumah on 24/04/2018.
//  Copyright © 2018 Jura Skrlec. All rights reserved.
//

#import "TMXProfileController.h"
#import "TMXReactNative.h"

@interface TMXProfileController()
@property(readwrite, nonatomic) NSString* sessionID;
@property(readwrite, nonatomic) NSString* requestID;
@property(readwrite, nonatomic) NSString* optionOrgId;
@property(readwrite, nonatomic) NSString* optionFingerPrintServer;
@end

@implementation TMXProfileController

- (instancetype) init
{
    self = [super init];
    
    _sessionID = nil;
    _timeout   = @10;
    _profile   = [THMTrustDefender sharedInstance];
    return self;
}


-(void)initialiseTMX:(NSDictionary*)options {
    
    self.optionOrgId = [options valueForKey:kOptionOrgIDJsKey];
    self.optionFingerPrintServer = [options valueForKey:kOptionFingerprintServerJsKey];
    static dispatch_once_t configureOnce = 0;
    
    //The [_profile configure] method is effective only once and subsequent calls to it will be ignored. By having a dipatch_once here we make sure configure is called
    //only once, although using a dispatch_once is not technically required.
    dispatch_once(&configureOnce,
                  ^{
                      // The profile.configure method is effective only once and subsequent calls to it will be ignored.
                      // Please note that configure may throw NSException if NSDictionay key/value(s) are invalid.
                      // This only happen due to programming error, therefore we don't catch the exception to make sure there is no error in our configuration dictionary
                      [_profile configure:@{
                                            THMOrgID :  self.optionOrgId,
                                            // (REQUIRED) Enhanced fingerprint server
                                            THMFingerprintServer : self.optionFingerPrintServer,
                                            // (OPTIONAL) Set the connection timeout, in seconds
                                            THMTimeout : _timeout,
                                            // (OPTIONAL) If Keychain Access sharing groups are used, specify like this
                                            THMKeychainAccessGroup: @"YLLQ57PVDB.com.10xbanking.vmdb.app",
                                            // (OPTIONAL) Register for location service updates
                                            // Note that this call can prompt the user for permissions. The related call
                                            // registerLocationServices will only activate location services have already been
                                            // granted. But in this case, we want the request to happen
                                            THMLocationServicesWithPrompt: @YES,
                                            //(OPTIONAL) Register for ThreatMetrix Strong Authentication, using this feature needs some setup in the AppDelegate class.
                                            THMRegisterForPush: @YES
                                            }];
                  });
//    return self;
}

-(void)doProfile
{
    // (OPTIONAL) Retrieve the version of the mobile SDK
    NSLog(@"Using: %@", self.profile.version);
    
    NSArray *customAttributes = @[@"attribute 1", @"attribute 2"];
    
    self.loginOkay = NO;
    
    // Fire off the profiling request.
    THMProfileHandle *profileHandle = [self.profile
                                       doProfileRequestWithOptions:@{
                                                                     // (OPTIONAL) Assign some custom attributes to be included with the profiling information
                                                                     THMCustomAttributes: customAttributes
                                                                     }
                                       andCallbackBlock:^(NSDictionary *result)
                                       {
                                           THMStatusCode statusCode = [[result valueForKey:THMProfileStatus] integerValue];
                                           // If we registered a delegate, this function will be called once the profiling is complete
                                           if(statusCode == THMStatusCodeOk)
                                           {
                                               // No errors, profiling succeeded!
                                           }
                                           NSLog(@"Profile completed with: %s and session ID: %@", statusCode == THMStatusCodeOk ? "OK"
                                                 : statusCode == THMStatusCodeNetworkTimeoutError ? "Timed out"
                                                 : statusCode == THMStatusCodeConnectionError     ? "Connection Error"
                                                 : statusCode == THMStatusCodeHostNotFoundError   ? "Host not found error"
                                                 : statusCode == THMStatusCodeInternalError       ? "Internal Error"
                                                 : statusCode == THMStatusCodeInterruptedError    ? "Interrupted"
                                                 : "other",
                                                 [result valueForKey:THMSessionID]);
                                           [self setLoginOkay:YES];
                                       }];
    
    // Session id can be collected here (to use in API call (AKA session query))
    self.sessionID = profileHandle.sessionID;
    NSLog(@"Session id is %@", self.sessionID);
    
}
@end
