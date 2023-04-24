<p align="center"><img src="https://user-images.githubusercontent.com/107832509/195552226-d07368d3-4968-44f5-b9d6-70f61c2814c0.png" width="100%"></p> 

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]

[swift-url]: https://swift.org/
[swift-image]:https://img.shields.io/badge/swift-5.5-orange.svg
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

## - Concept

**✨ LinkNavigator is a library that helps you easily navigate between pages in SwiftUI.**<br>

- LinkNavigator provides an intuitive syntax for navigating pages via URL path-like expressions.
- You can easily go to any page with the deep-link processing style.
- You can inject parameters with page transition.
- LinkNavigator is designed for use in Uni-directional Architecture such as MVI design pattern or [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) from pointfreeco, but it can be used in other architectures as well.

<br>

## - Translations

The following translations of this README have been contributed by members of the community:

- [한국어(Korean)](https://gist.github.com/Jager-yoo/572c1735cf2560299a22c6f6065914b5)

If you'd like to contribute a translation, please [open a PR](https://github.com/interactord/LinkNavigator/edit/main/README.md) with a link to a [Gist](https://gist.github.com/)!

<br>

## - Basic Usage

- push one or many pages.

  ```swift
  navigator.next(paths: ["page1", "page2"], items: [:], isAnimated: true)
  ```

- pop one or many pages.

  ```swift
  navigator.remove(paths: ["pageToRemove"])
  ```

- back to the prior page or dismiss modal simply.

  ```swift
  navigator.back(isAnimated: true)
  ```

- go to the page you want. If that page is already within navigation stack, go back to that page. Else if that page is not within stack, push new one.

  ```swift
  navigator.backOrNext(path: "targetPage", items: [:], isAnimated: true)
  ```

- replace current navigation stack with new one.

  ```swift
  navigator.replace(paths: ["main", "depth1", "depth2"], items: [:], isAnimated: true)
  ```

- open page as sheet or full screen cover.

  ```swift
  navigator.sheet(paths: ["sheetPage"], items: [:], isAnimated: true)

  navigator.fullSheet(paths: ["page1", "page2"], items: [:], isAnimated: true, prefersLargeTitles: false)
  ```

- close a modal and call completion closure.

  ```swift
  navigator.close(isAnimated: true) { print("modal dismissed!") }
  ```

- show a system alert.

  ```swift
  let alertModel = Alert(
    title: "Title",
    message: "message",
    buttons: [.init(title: "OK", style: .default, action: { print("OK tapped") })],
    flagType: .default)
  navigator.alert(target: .default, model: alertModel)
  ```

<br>

## - Advanced Usage

- edit complicated paths and use it.

  ```swift
  // current navigation stack == ["home", "depth1", "depth2", "depth3"]
  // target stack == ["home", "depth1", "newDepth"]

  var new = navigator.range(path: "depth1") + ["newDepth"]
  navigator.replace(paths: new, items: [:], isAnimated: true)
  ```

- control pages behind modal.

  ```swift
  navigator.rootNext(paths: ["targetPage"], items: [:], isAnimated: true)

  navigator.rootBackOrNext(path: "targetPage", items: [:], isAnimated: true)
  ```

- you can choose modal presentation styles for iPhone and iPad respectively.

  ```swift
  navigator.customSheet(
    paths: ["sheetPage"],
    items: [:],
    isAnimated: true,
    iPhonePresentationStyle: .fullScreen,
    iPadPresentationStyle: .pageSheet,
    prefersLargeTitles: .none)
  ```
  
- forcely reload the last page behind the modal. This is useful when you need to call the [onAppear(perform:)](https://developer.apple.com/documentation/swiftui/view/onappear(perform:)) again.

  ```swift
  navigator.rootReloadLast(items: [:], isAnimated: false)
  ```

<br>

## - Example

LinkNavigator provides 2 Example Apps.

- [`MVI` based example](https://github.com/interactord/LinkNavigator/tree/main/Examples/MVI-Example)
- [`TCA` based example](https://github.com/interactord/LinkNavigator/tree/main/Examples/TCA-Example) - with [0.50.1 release](https://github.com/pointfreeco/swift-composable-architecture/releases/tag/0.50.1)

<p align="leading"><img src="https://user-images.githubusercontent.com/107832509/198525187-7d524e7f-7ad6-48c0-886a-805ad3a4e6a2.gif" width="25%"></p> 

<br>

## - Getting Started

### Step 1

- To install LinkNavigator in your SwiftUI project, you need to implement 4 files.
- You can freely edit the type names. In the following examples, simple names are used for clarity.
- Describe in order: AppDependency -> AppRouterGroup -> AppDelegate -> AppMain

  ```swift
  // AppDependency.swift
  // A type that manages external dependencies.
  
  import LinkNavigator

  struct AppDependency: DependencyType { } // you need to adopt DependencyType protocol here.
  ```

  ```swift
  // AppRouterGroup.swift
  // A type that manages the pages you want to go with LinkNavigator.

  import LinkNavigator

  struct AppRouterGroup {
    var routers: [RouteBuilder] {
      [
        HomeRouteBuilder(), // to be implemented in Step 3
        Page1RouteBuilder(),
        Page2RouteBuilder(),
        Page3RouteBuilder(),
        Page4RouteBuilder(),
      ]
    }
  }
  ```

  ```swift
  // AppDelegate.swift
  // A type that manages the navigator injected with external dependencies and pages.

  import SwiftUI
  import LinkNavigator

  final class AppDelegate: NSObject {
    var navigator: LinkNavigator {
      LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
    }
  }

  extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      true
    }
  }
  ```

  ```swift
  // AppMain.swift
  // A type that sets the starting page of the Application.

  import SwiftUI
  import LinkNavigator

  @main
  struct AppMain: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var navigator: LinkNavigator {
      appDelegate.navigator
    }

    var body: some Scene {
      WindowGroup {
        navigator
          .launch(paths: ["home"], items: [:]) // the argument of 'paths' becomes starting pages.
          .onOpenURL { url in
          // in case you need deep link navigation,
          // deep links should be processed here.
          }
      }
    }
  }
  ```

### Step 2

- Add a `navigator` property inside the page struct type, so that it is injected when initialized.
- Depending on the characteristics of the architecture, freely change the position of the navigator property and use it.
For example, you can put it in `ViewModel` or `Environment`.

  ```swift
  struct HomePage: View {
    let navigator: LinkNavigatorType

    var body: some View {
      ...
    }
  }
  ```

### Step 3

- Create a struct type adopting the `RouteBuilder` protocol for every page.
- RouteBuilder structs created in this way are collected and managed in the AppRouterGroup type.

  ```swift
  import LinkNavigator
  import SwiftUI

  struct HomeRouteBuilder: RouteBuilder {
    var matchPath: String { "home" }

    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
      { navigator, items, dependency in
        return WrappingController(matchPath: matchPath) {
          HomePage(navigator: navigator)
        }
      }
    }
  }
  ```

<br>

## - Installation

LinkNavigator supports [Swift Package Manager](https://www.swift.org/package-manager/).

- `File` menu at the top of Xcode -> Select `Add Packages...`.
- Enter "https://github.com/interactord/LinkNavigator.git" in the Package URL field to install it.
- or, add the following in the `Package.swift`.

```swift
let package = Package(
  name: "MyPackage",
  products: [
    .library(
      name: "MyPackage",
      targets: ["MyPackage"]),
  ],
  dependencies: [
    .package(url: "https://github.com/interactord/LinkNavigator.git", .upToNextMajor(from: "0.6.1"))
  ],
  targets: [
    .target(
      name: "MyPackage",
      dependencies: ["LinkNavigator"])
  ]
)
```

<br>

## - Extra

- Q: **How can I use large titles in SwiftUI?**
```swift
  /// in AppMain.swift (MVI)
  /// To use for route navigation, set the prefersLargeTitles parameter to true in the launch method.
  
  navigator
    .launch(paths: ["home"], items: [:], prefersLargeTitles: true)
    
    
  /// in HomeView.swift (MVI)
  /// To specify the display mode of the navigation bar title, use the navigationBarTitleDisplayMode (.line, .large, .automatic) in the SwiftUI screen of each screen.
  ScrollView {
    ....
  }
  .navigationBarTitleDisplayMode(.large)
  .navigationTitle("Home")
  
  
  ///  If you want to use it in fullSheet or customSheet,
  /// Home.intent (MVI)
  /// To enable large titles, set the prefersLargeTitles variable to true. To maintain the current settings, use .none.
  navigator.fullSheet(paths: ["page1", "page2"], items: [:], isAnimated: true, prefersLargeTitles: true)
```

- Q: I'm wondering how to apply **IgnoringSafeArea** to a specific part or the entire screen if I want to?

  1. Add the following code to the screen where LinkNavigator is first started (example: AppMain.swift).
  2. Then, add the following example code. (Refer to the AppMain.swift example.)
```swift

 navigator
    .launch(paths: ["home"], items: [:], prefersLargeTitles: true)
    /// - Note:
    ///   If you are using the ignoresSafeArea property to ignore the safe area on an internal screen,
    ///   please add the corresponding code to the part where you first execute the LinkNavigator.
    .ignoresSafeArea()

```

## - License

This library is released under the MIT license. See [LICENSE](https://github.com/interactord/LinkNavigator/blob/main/LICENSE.md) for details.
