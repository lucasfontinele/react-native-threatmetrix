//
//  TMXProfileController.h
//  TMXReactNative
//
//  Created by Don Onwunumah on 24/04/2018.
//  Copyright © 2018 Jura Skrlec. All rights reserved.
//

#import <Foundation/Foundation.h>
#if defined(__has_feature) && __has_feature(modules)
@import TrustDefender;
@import Foundation;
#else
#import <TrustDefender/TrustDefender.h>
#import <Foundation/Foundation.h>
#endif

@interface TMXProfileController : NSObject

/// The TrustDefender SDK instance
@property (readonly) THMTrustDefender* profile;

/// Session id used in profiling, this can be created by ThreatMetrix SDK or passed to
/// profiling request. NOTE: session id must be unique otherwise the result of API call will
/// be unexpected.
@property (readonly, nonatomic) NSString *sessionID;

/// Indicate if the login can proceed or if it needs to wait for the profiling to complete
@property (readwrite)BOOL loginOkay;

/// Timeout for profiling, this timeout is used for all netweork requests made from the ThreatMetrix SDK
@property(readonly) NSNumber *timeout;

@property (readonly, nonatomic) NSString *requestID;

/// Profiling example showing some optional features
///
/// The optional settings could include the following (and more, check the SDK docs for the full list)
///
///  - Setting custom attributes. These could vary based on device or login etc In this example they are fixed strings.
///  - Setting a custom session id.
- (void)doProfile;

/// We get an instance of TrustDefenderSDK object here, and set up some initial settings.
///
/// These extra settings are entirely optional, but allow
/// finer grained control over profiling.
/// An incomplete list of things we could do here:
///
///  - Set the connection timeout
///  - Register for loction services
///  - Set a delegate for callbacks
/// @return returns the created LBProfileController object
- (instancetype) init;
- (void)initialiseTMX:(NSDictionary*)options;

@end
