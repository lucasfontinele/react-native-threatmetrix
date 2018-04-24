//
//  BlinkIDReactNative.h
//  BlinkIDReactNative
//
//  Created by Jura Skrlec on 12/04/2017.
//  Copyright © 2017 Microblink. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import "TMXProfileController.h"

@interface BlinkIDReactNative : NSObject<RCTBridgeModule>
@property (strong, nonatomic) TMXProfileController *td;
@end
