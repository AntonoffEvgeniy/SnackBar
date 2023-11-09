# SnackBar
#### Simple way to show alerts, warnings etc.

![video_example](https://github.com/AntonoffEvgeniy/SnackBar/blob/example-resources/Resources/video_example.mov)

## Installation

#### Swift Package Manager

##### Add the dependency to Package.swift:
```swift
dependencies: [
    ...
    .package(url: "https://github.com/AntonoffEvgeniy/SnackBar.git", from: "1.0.0")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "SnackBar", package: "SnackBar"),
    ]),
```

## Usage

```swift
import SnackBar

SnackBar.show(
    "Your message",
    position: .top
)
```

## Customization

##### Use global settings
```swift
SnackBar.settings.interval = 10
SnackBar.settings.backgroundColor = .white
```

##### Or pass parameters for a specific case
```swift
SnackBar.show(
    "Your message",
    position: .bottom,
    font: .systemFont(ofSize: 25)
)
```

##### Parameters
- **position: Position** - one of cases: `.top`, `.bottom`
- **interval: TimeInterval** - `3` by default
- **maxNumberOfLines: Int** - `3` by default
- **backgroundColor: UIColor** - `.red` by default
- **font: UIFont** - `.systemFont(ofSize: 12)` by default
- **textColor: UIColor** - `.black` by default
- **textAlignment: NSTextAlignment** - `.left` by default


> [!NOTE]
> Priority: passed parameters -> global settings -> default settings
