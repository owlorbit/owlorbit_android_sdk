# ImageCropView
### ImageCropView allow you to easily display and crop images

## Features

- [x] Put an UIScrollView at the size you want using Storyboard
- [x] Use ImageCropView's setup() function to init the component
- [x] After the UI is rendered you can call the display() function
- [x] Let the user zoom & move the image as they want
- [x] Get the cropped image by using croppedImage() function
- [x] Get the crop rect by using cropRect() function
- [x] Tap events can be handled using ImageCropViewTapProtocol
- [x] You can use this component to display a read only cropped image too

## Requirements

- iOS 8.0+
- Xcode 7.0+
  
## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.38.2 is required to build ImageCropView. It adds support for Xcode 7, Swift 2.0 and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate ImageCropView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ImageCropView', '~> 1.0'
```

Then, run the following command:

```bash
$ pod install
```


## Usage

###### Setup
```swift
imageCropView.setup(UIImage)
```

###### Display
```swift
imageCropView.display()
```

###### Get the cropped image
```swift
let croppedImage = imageCropView.croppedImage()
```

###### Get the crop Rect
```swift
let cropRect = imageCropView.cropRect()
```

###### Set the crop Rect
```swift
imageCropView.setCrop(rect)
```

## License

ImageCropView is released under the MIT license. See LICENSE for details.
