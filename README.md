# 🚤 LinkNavigator

## - Concept

**✨ LinkNavigator 는 SwiftUI 에서 화면을 자유롭게 이동할 수 있도록 도와주는 라이브러리입니다.**<br>

- URL path 형식의 표현 방법을 통해, 화면 이동에 대한 직관적인 syntax 를 제공합니다.
- 딥링크 처리 방식으로 어떤 화면이든 간편하게 이동할 수 있습니다.
- 화면 이동과 함께 매개변수를 주입할 수 있습니다.
- MVI 디자인 패턴, 혹은 pointfreeco 의 [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) 와 같은 Uni-directional Architecture 에서 사용할 목적으로 디자인 되었지만, 그 외의 Architecture 에서도 사용하기 좋습니다.

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

- go to the page you want, regardless the page is in navigation stack or not.

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

  navigator.fullSheet(paths: ["page1", "page2"], items: [:], isAnimated: true)
  ```

- close a modal and call completion closure.

  ```swift
  navigator.close { print("modal dismissed!") }
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
    iPadPresentationStyle: .pageSheet)
  ```

<br>

## - Example

[Example App](https://github.com/interactord/LinkNavigator/tree/main/Example) 에서 LinkNavigator 의 기능을 체험해볼 수 있습니다.

<br>

## - Getting Started

### Step 1

- SwiftUI 프로젝트에 LinkNavigator 를 설치하기 위해서, 총 4개의 파일을 설정해야 합니다.
- 파일, 타입의 이름은 자유롭게 수정해도 됩니다. 다음 예시에서는 이해를 돕기 위해 단순한 이름을 사용했습니다.
- AppDependency -> AppRouterGroup -> AppDelegate -> AppMain 순서로 설명합니다.

  ```swift
  // AppDependency.swift
  // 외부 의존성을 관리하는 타입입니다.
  
  import LinkNavigator

  struct AppDependency: DependencyType { } // you need to adopt DependencyType protocol here.
  ```

  ```swift
  // AppRouterGroup.swift
  // LinkNavigator 를 통해 이동하고 싶은 화면들을 관리하는 타입입니다.

  import LinkNavigator

  struct AppRouterGroup {
    var routers: [RouteBuilder] {
      [
        HomeRouteBuilder(), // Step 3 에서 구현
        Page1RouteBuilder(),
        Page2RouteBuilder(),
        Page3RouteBuilder(),
      ]
    }
  }
  ```

  ```swift
  // AppDelegate.swift
  // 외부 의존성과 화면을 주입받은 navigator 를 관리하는 타입입니다.

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
  // Application 의 시작 화면을 설정하는 타입입니다.

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
      }
    }
  }
  ```

### Step 2

- 화면에 해당하는 구조체 내부에 `navigator` 프로퍼티를 추가하여, 이니셜라이징 될 때 주입되도록 합니다.
- Architecture 특징에 따라, navigator 프로퍼티의 위치를 자유롭게 변경해서 사용하세요.
예를 들어, `ViewModel` 또는 `Environment` 에 넣어서 사용해도 좋습니다.

  ```swift
  struct HomePage: View {
    let navigator: LinkNavigatorType

    var body: some View {
      ...
    }
  }
  ```

### Step 3

- 모든 화면에 각각에 대해 `RouteBuilder` 프로토콜을 채택한 구조체를 만듭니다.
- 이렇게 만든 RouteBuilder 구조체들은 AppRouterGroup 타입에서 모아두고 관리합니다.

  ```swift
  import LinkNavigator
  import SwiftUI

  struct HomeRouteBuilder: RouteBuilder {
    var matchPath: String { "home" }

    var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
      { navigator, items, dependency in
        return WrappingController(matchingKey: matchPath) {
          AnyView(HomePage(navigator: navigator))
        }
      }
    }
  }
  ```

<br>

## - Installation

LinkNavigator 는 [Swift Package Manager](https://www.swift.org/package-manager/) 를 지원합니다.

- Xcode 상단의 `File` 메뉴 -> `Add Packages...` 를 선택합니다.
- Package URL 입력창에 "https://github.com/interactord/LinkNavigator.git" 를 입력해서 설치합니다.
- 혹은 `Package.swift` 파일에 아래와 같이 입력합니다.

```swift
let package = Package(
  name: "MyPackage",
  products: [
    .library(
      name: "MyPackage",
      targets: ["MyPackage"]),
  ],
  dependencies: [
    .package(url: "https://github.com/interactord/LinkNavigator.git", .upToNextMajor(from: "0.2.3"))
  ],
  targets: [
    .target(
      name: "MyPackage",
      dependencies: ["LinkNavigator"])
  ]
)
```

<br>

## - License
This library is released under the MIT license.
