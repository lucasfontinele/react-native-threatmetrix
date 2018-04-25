'use strict';

import { Platform, NativeModules } from 'react-native';

export const RNThreatMetrix = Platform.select({
      ios: NativeModules.TMXReactNative,
      android: NativeModules.BlinkIDAndroid
})

/**
 * Following exports expose the keys (string constants) for obtaining result values for
 * corresponding result types.
 */
export const MRTDKeys = require('./keys/mrtd_keys')
export const USDLKeys = require('./keys/usdl_keys')
export const EUDLKeys = require('./keys/eudl_keys')
export const MYKADKeys = require('./keys/mykad_keys')
export const PDF417Keys = require('./keys/pdf417_keys')