//
//  TMXReactNative.h
//  TMXReactNative
//
//

#import <React/RCTBridgeModule.h>
#import "TMXProfileController.h"

extern NSString* const kOptionOrgIDJsKey;
extern NSString* const kOptionFingerprintServerJsKey;

@interface TMXReactNative : NSObject<RCTBridgeModule>
@property (strong, nonatomic) TMXProfileController *td;
@end
