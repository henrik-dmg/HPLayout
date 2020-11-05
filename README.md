# HPLayout
A simple layout DSL to make your Autolayout life a little easier.

## Installation
### Xcode
File -> Swift Packages -> Add Package Dependency -> https://github.com/henrik-dmg/HPLayout
### Package.swift
`.pacakage(url: "https://github.com/henrik-dmg/HPLayout", from: "0.2.0")`

## Usage
```swift
yourAwesomeView.layout {
    $0.leading == someOtherView1.trailingAnchor + 8
    $0.trailing <= someOtherView2.trailingAnchor
    $0.spanHorizontally(.superView, constant: 4)
}
```
