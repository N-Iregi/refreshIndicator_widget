# RefreshIndicator

The RefreshIndicator is a widget that supports the Material "swipe to refresh" idiom. It wraps whatever scrollable widget you have (for my project, `CustomScrollView`). 

## Run instructions
To run this project on your device:
1. move into the project's root directory
```
cd refreshInidcator_widget
```
2. Run:
```
flutter run
```
3. Choose a device to run it on, whether on a browser or an emulator or physical device.

## Properties
One important property of the RefreshIndicator is `onRefresh` → RefreshCallback
- it is afunction that's called when the user has dragged the refresh indicator far enough to demonstrate that they want the app to refresh. The returned Future must complete when the refresh operation is finished.

When the child's Scrollable descendant overscrolls, an animated circular progress indicator is faded into view. When the scroll ends, if the indicator has been dragged far enough for it to become completely opaque, the `onRefresh` callback is called. The callback is expected to update the scrollable's contents and then complete the Future it returns. The refresh indicator disappears after the callback's Future has completed.

3 properties of this widget are:
**1. color → Color?**
- The progress indicator's foreground color. The current theme's ColorScheme.primary by default. Controls the spinning arc inside the indicator circle.
  
**2. backgroundColor → Color?**
- The progress indicator's background color. This is the circle behind the spinner The current theme's ThemeData.canvasColor by default.
  
**3. displacement → double**
- The distance from the child's top or bottom edgeOffset where the refresh indicator will settle. During the drag that exposes the refresh indicator, its actual displacement may significantly exceed this value.

**Screenshots**
<img width="1080" height="2400" alt="Screenshot_1780926597" src="https://github.com/user-attachments/assets/e699f304-c5eb-4f71-a7bc-3c554c567e26" />
<img width="1080" height="2400" alt="Screenshot_1780926625" src="https://github.com/user-attachments/assets/44ab0708-800c-4b03-a4a3-da77fb4c5e75" />
