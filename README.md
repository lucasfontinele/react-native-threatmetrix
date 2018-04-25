
# react-native-threatmetrix

## Getting started

`$ npm install react-native-threatmetrix --save`

### Mostly automatic installation

`$ react-native link react-native-threatmetrix`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-threatmetrix` and add `TMXReactNative.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libTMXReactNative.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNThreatMetrixPackage;` to the imports at the top of the file
  - Add `new RNThreatMetrixPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-threat-metrix'
  	project(':react-native-threat-metrix').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-threat-metrix/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-threat-metrix')
  	```

## Usage
```javascript
import RNThreatMetrix from 'react-native-threatmetrix';

// TODO: What to do with the module?
RNThreatMetrix;
```