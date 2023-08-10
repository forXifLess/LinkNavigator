import SwiftUI
import LinkNavigator

// MARK: - AppMain

@main
struct AppMain {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
}

// MARK: App

extension AppMain {
  var tabNavigator: TabNavigator {
    tab
  }

  var singleNavigator: SingleNavigator {
    single
  }
}

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      tabNavigator
        .launch(isTabBarHidden: false)
    }
  }
}

let tab = TabNavigator(
  linkPath: "tabHome",
  rootNavigator: .init(initialLinkItem: .init(paths: [])),
  tabItemList: [
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab1-home" ])),
      image: .init(systemName: "figure.american.football"),
      title: "Tab#1",
      tagName: "#Tab1"),
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab2-home" ])),
      image: .init(systemName: "figure.basketball"),
      title: "Tab#2",
      tagName: "#Tab2"),
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab3-home" ])),
      image: .init(systemName: "figure.climbing"),
      title: "Tab#3",
      tagName: "#Tab3"),
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab4-home" ])),
      image: .init(systemName: "figure.skiing.crosscountry"),
      title: "Tab#4",
      tagName: "#Tab4"),
  ],
  routeBuilderItemList: generateBuilderList(),
  dependency: AppDependency(),
  defaultTagPath: "#Tab55")

let single = SingleNavigator(
  linkPath: "",
  rootNavigator: .init(initialLinkItem: .init(paths: ["page2"])),
  routeBuilderList: generateBuilderList(),
  dependency: AppDependency())


func generateBuilderList<T>() -> [RouteBuilderOf<T>] {
  [
    .init(
      matchPath: "home",
      routeBuild: { navigator, items, env in
        WrappingController(matchPath: "home") {
          VStack {
            Spacer()
            Text("home")
            Button(action: { print("111")}) {
              Text("push")
            }
            if let navi = navigator as? TabNavigator {
              Button(action: {
                navi.back(isAnimated: true)
              }) {
                Text("back")
              }
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page1",
      routeBuild: { navigator, items, env in
        return WrappingController(matchPath: "page1") {
          VStack {
            Spacer()
            Text("page1")
            if let navi = navigator as? TabNavigator {
              Button(action: {
                navi.sheet(item: .init(paths: ["page3"]), isAnimated: true)
              }) {
                Text("sheet page3")
              }
            }
            if let navi = navigator as? TabNavigator {
              Button(action: {
                navi.back(isAnimated: true)
              }) {
                Text("back")
              }
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page2",
      routeBuild: { navigator, items, env in
        WrappingController(matchPath: "page2") {
          VStack {
            Spacer()
            Text("page2")
            if let navi = navigator as? TabNavigator {
              Button(action: {
                navi.back(isAnimated: true)
              }) {
                Text("back")
              }
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page3",
      routeBuild: { navigator, items, env in
        WrappingController(matchPath: "page3") {
          VStack {
            Spacer()
            Text("page3")
            if let navi = navigator as? TabNavigator {
              Button(action: {
                navi.back(isAnimated: true)
              }) {
                Text("back")
              }
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "tab1-home",
      routeBuild: { navigator, items, env in
        WrappingController(matchPath: "tab1-home") {
          VStack {
            Spacer()
            Text("tab1-home")
            if let navi = navigator as? TabNavigator {
              Button(action: {
                navi.push(item: .init(paths: ["page1"]), isAnimated: true)
              }) {
                Text("next page1")
              }

              Button(action: {
                navi.moveToTab(tagPath: "#Tab3")
              }) {
                Text("Move Tab3")
              }
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "tab2-home",
      routeBuild: { navigator, items, env in
        WrappingController(matchPath: "tab2-home") {
          VStack {
            Spacer()
            Text("tab2-home")
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "tab3-home",
      routeBuild: { navigator, items, env in
        WrappingController(matchPath: "tab3-home") {
          VStack {
            Spacer()
            Text("tab3-home")
            if let navi = navigator as? TabNavigator {
              Button(action: {
                navi.push(item: .init(paths: ["page1"]), isAnimated: true)
              }) {
                Text("next page2")
              }
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "tab4-home",
      routeBuild: { navigator, items, env in
        WrappingController(matchPath: "tab4-home") {
          VStack {
            Spacer()
            Text("tab4-home")
            Spacer()
          }
        }
      }),
  ]
}
