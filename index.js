'use strict';

import { Platform, NativeModules } from 'react-native';

export const RNThreatMetrix = Platform.select({
      ios: NativeModules.TMXReactNative,
      android: NativeModules.BlinkIDAndroid
})
