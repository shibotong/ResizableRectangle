# ResizableRectangle

![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-blue)
![License](https://img.shields.io/badge/license-MIT-green.svg)


https://github.com/shibotong/ResizableRectangle/assets/44807628/a535c3ba-d26d-4bc3-90bd-0f685b3be221


## Features

- Create resizable rectangles with adjustable width and height.
- Customize the rectangle's appearance, including stroke color, fill color, and corner radius.
- Seamlessly integrate the resizable rectangle into your SwiftUI views.

## Installation

You can install ResizableRectangle using Swift Package Manager:

1. In Xcode, go to "File" > "Swift Packages" > "Add Package Dependency..."
2. Paste the URL of this repository: `https://github.com/shibotong/ResizableRectangle.git`
3. Follow the prompts to complete the installation.

## Usage

```swift
import ResizableRectangle
struct ContentView: View {

    @State var rectSize: CGRect = .zero
    var body: some View {
        ResizableRectangle(rect: $rectSize)
    }
}
```
