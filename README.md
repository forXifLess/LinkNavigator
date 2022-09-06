# 🚤 LinkNavigator

## Concept

LinkNavigator 는 SwiftUI 에서 화면을 자유롭게 이동할 수 있도록 도와주는 라이브러리입니다.<br>

- URL path 형식의 표현 방법을 통해, 화면 이동에 대한 직관적인 syntax 를 제공합니다.
- 딥링크 처리 방식으로 어떤 화면이든 간편하게 이동할 수 있습니다.
- 화면 이동과 함께 매개변수를 주입할 수 있습니다.
- pointfreeco 의 [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) 와 함께 사용하는 목적으로 디자인 되었지만, 그 외의 프레임워크에서도 사용할 수 있습니다.

## Basic Usage

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

## Advanced Usage

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

## Getting Started

- 설정 방법, Step by Step 으로 구성

## Example

- 프로젝트 타겟에 있는 Example 에 대한 설명, 사용법

## License
This library is released under the MIT license. See [LICENSE](link) for details.
