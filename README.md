# HPLayout

A simple layout DSL to make your Autolayout life a little easier.

## Installation

### Xcode

File -> Swift Packages -> Add Package Dependency -> https://github.com/henrik-dmg/HPLayout

### Package.swift

`.package(url: "https://github.com/henrik-dmg/HPLayout", from: "2.0.0")`

### CocoaPods

Add `pod 'HPLayout'` to your `Podfile`

## Usage

```swift
yourAwesomeView.layout {
    $0.leadingAnchor == someOtherView1.trailingAnchor + 8
    $0.trailingAnchor <= someOtherView2.trailingAnchor
    $0.spanHorizontally(.superView, constant: 4)
}

// or

someOtherView.addSubview(yourAwesomeView) {
    $0.leadingAnchor == someOtherView1.trailingAnchor + 8
    $0.trailingAnchor <= someOtherView2.trailingAnchor
    $0.spanHorizontally(.superView, constant: 4)
}

```
