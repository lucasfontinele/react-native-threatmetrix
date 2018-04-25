//
//  TMXReactNative.h
//  TMXReactNative
//
//

#import <React/RCTBridgeModule.h>
#import "TMXProfileController.h"

@interface TMXReactNative : NSObject<RCTBridgeModule>
@property (strong, nonatomic) TMXProfileController *td;
@end
