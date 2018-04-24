//
//  BlinkIDReactNative.m
//  BlinkIDReactNative
//
//  Created by Jura Skrlec on 12/04/2017.
//  Copyright © 2017 Microblink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlinkIDReactNative.h"
#import <React/RCTConvert.h>
#import <MicroBlink/MicroBlink.h>

@interface BlinkIDReactNative () <PPScanningDelegate>

@property (nonatomic, assign) BOOL enableBeep;

@property (nonatomic) PPCameraType cameraType;

@property (nonatomic, strong) NSDictionary* options;

@property (nonatomic, strong) RCTPromiseResolveBlock promiseResolve;

@property (nonatomic, strong) RCTPromiseRejectBlock promiseReject;

@property (nonatomic, strong) NSString* licenseKey;

@property (nonatomic) UIImage *scannedImageDewarped;

@property (nonatomic) UIImage *scannedImageSuccesful;

@property (nonatomic) UIImage *scannedImageFace;

@property (nonatomic, strong) NSArray *recognizers;

@property (nonatomic) BOOL shouldReturnCroppedImage;

@property (nonatomic) BOOL shouldReturnSuccessfulImage;

@property (nonatomic) BOOL shouldReturnFaceImage;

@end

// promise reject message codes
static NSString* const kErrorLicenseKeyDoesNotExists = @"ERROR_LICENSE_KEY_DOES_NOT_EXISTS";
static NSString* const kErrorCoordniatorDoesNotExists = @"COORDINATOR_DOES_NOT_EXISTS";
static NSString* const kStatusScanCanceled = @"STATUS_SCAN_CANCELED";

// js keys for scanning options
static NSString* const kOptionEnableBeepKey = @"enableBeep";
static NSString* const kOptionUseFrontCameraJsKey = @"useFrontCamera";
static NSString* const kOptionReturnCroppedImageJsKey = @"shouldReturnCroppedImage";
static NSString* const kOptionShouldReturnSuccessfulImageJsKey = @"shouldReturnSuccessfulImage";
static NSString* const kOptionReturnFaceImageJsKey = @"shouldReturnFaceImage";
static NSString* const kRecognizersArrayJsKey = @"recognizers";

// js keys for recognizer types
static NSString* const kRecognizerMRTDJsKey = @"RECOGNIZER_MRTD";
static NSString* const kRecognizerUSDLJsKey = @"RECOGNIZER_USDL";
static NSString* const kRecognizerEUDLJsKey = @"RECOGNIZER_EUDL";
static NSString* const kRecognizerMyKadJsKey = @"RECOGNIZER_MYKAD";
static NSString* const kRecognizerDocumentFaceJsKey = @"RECOGNIZER_DOCUMENT_FACE";
static NSString* const kRecognizerPDF417JsKey = @"RECOGNIZER_PDF417";

// js result keys
static NSString* const kResultList = @"resultList";
static NSString* const kResultImageCropped = @"resultImageCropped";
static NSString* const kResultImageSuccessful = @"resultImageSuccessful";
static NSString* const kResultImageFace = @"resultImageFace";
static NSString* const kResultType = @"resultType";
static NSString* const kFields = @"fields";

static NSString* const kSessionId = @"sessionId";

// result values for resultType
static NSString* const kMRTDResultType = @"MRTD result";
static NSString* const kUSDLResultType = @"USDL result";
static NSString* const kEUDLResultType = @"EUDL result";
static NSString* const kMyKadResultType = @"MyKad result";
static NSString* const kDocumentFaceResultType = @"DocumentFace result";
static NSString* const kPDF417ResultType = @"PDF417 result";

// recognizer result keys
static NSString* const kRaw = @"raw";
static NSString* const kMRTDDateOfBirth = @"DateOfBirth";
static NSString* const kMRTDDateOExpiry = @"DateOfExpiry";
static NSString* const kMyKadBirthDate = @"ownerBirthDate";

// NSError Domain
static NSString* const MBErrorDomain = @"microblink.error";

@implementation BlinkIDReactNative

RCT_EXPORT_MODULE();

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSDictionary *)constantsToExport {
    NSMutableDictionary* constants = [NSMutableDictionary dictionary];
    [constants setObject:@"RECOGNIZER_MRTD" forKey:kRecognizerMRTDJsKey];
    [constants setObject:@"RECOGNIZER_USDL" forKey:kRecognizerUSDLJsKey];
    [constants setObject:@"RECOGNIZER_EUDL" forKey:kRecognizerEUDLJsKey];
    [constants setObject:@"RECOGNIZER_DOCUMENT_FACE" forKey:kRecognizerDocumentFaceJsKey];
    [constants setObject:@"RECOGNIZER_MYKAD" forKey:kRecognizerMyKadJsKey];
    [constants setObject:@"RECOGNIZER_PDF417" forKey:kRecognizerPDF417JsKey];
    [constants setObject:@"MRTD result" forKey:kMRTDResultType];
    [constants setObject:@"USDL result" forKey:kUSDLResultType];
    [constants setObject:@"EUDL result" forKey:kEUDLResultType];
    [constants setObject:@"MyKad result" forKey:kMyKadResultType];
    [constants setObject:@"PDF417 result" forKey:kPDF417ResultType];
    [constants setObject:@"DocumentFace result" forKey:kDocumentFaceResultType];
    return [NSDictionary dictionaryWithDictionary:constants];
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
    
//    RCTLogInfo(@"Pretending to create an event %@ at %@", orgid, fingerprintServer);
}

RCT_EXPORT_METHOD(sendSession:(NSString *)url) {
    
    NSString *session   = self.td.sessionID;
    
}


//RCT_REMAP_METHOD(fooscan, fooscan:(NSString *)key withOptions:(NSDictionary*)scanOptions resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
//    if (key.length == 0) {
//        NSDictionary *userInfo = @{
//                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
//                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"License key missing.", nil),
//                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you checked your license key?", nil)
//                                   };
//        NSError *error = [NSError errorWithDomain:MBErrorDomain
//                                             code:-57
//                                         userInfo:userInfo];
//        reject(kErrorLicenseKeyDoesNotExists, @"License key does not exists", error);
//        return;    }
//    else {
//        self.licenseKey = key;
//    }
//
//    BOOL isFrontCamera = [[scanOptions valueForKey:kOptionUseFrontCameraJsKey] boolValue];
//    if (!isFrontCamera) {
//        self.cameraType = PPCameraTypeBack;
//    } else {
//        self.cameraType = PPCameraTypeFront;
//    }
//
//    self.enableBeep = [[scanOptions valueForKey:kOptionEnableBeepKey] boolValue];
//
//    self.promiseResolve = resolve;
//    self.promiseReject  = reject;
//
//    self.options = scanOptions;
//    self.recognizers = [scanOptions valueForKey:kRecognizersArrayJsKey];
//
//    /** Instantiate the scanning coordinator */
//    NSError *error;
//    PPCameraCoordinator *coordinator = [self coordinatorWithError:&error];
//
//    /** If scanning isn't supported, present an error */
//    if (coordinator == nil) {
//        NSDictionary *userInfo = @{
//                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
//                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Camera coordinator is nil.", nil),
//                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you checked creation of camera coordinator?", nil)
//                                   };
//        NSError *error = [NSError errorWithDomain:MBErrorDomain
//                                             code:-57
//                                         userInfo:userInfo];
//        reject(kErrorCoordniatorDoesNotExists, @"Coordinator does not exists", error);
//
//        return;
//    }
//
//    /** Allocate and present the scanning view controller */
//    UIViewController<PPScanningViewController>* scanningViewController = [PPViewControllerFactory cameraViewControllerWithDelegate:self coordinator:coordinator error:nil];
//
//    // allow rotation if VC is displayed as a modal view controller
//    scanningViewController.autorotate = YES;
//    scanningViewController.supportedOrientations = UIInterfaceOrientationMaskAll;
//
//    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [rootViewController presentViewController:scanningViewController animated:YES completion:nil];
//    });
//
//}

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
