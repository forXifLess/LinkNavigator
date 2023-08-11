import LinkNavigator
import SwiftUI

// MARK: - AppMain

@main
struct AppMain {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
}

// MARK: App

extension AppMain {
  var tabNavigator: TabLinkNavigator {
    tab
  }

  var singleNavigator: SingleLinkNavigator {
    single
  }
}

// MARK: App

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
//      tabNavigator
//        .launch()
      singleNavigator
        .launch()
    }
  }
}

let tab = TabLinkNavigator(
  linkPath: "tabHome",
  tabItemList: [
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab1-home" ])),
      image: .init(systemName: "figure.american.football"),
      title: "Tab#1",
      tagMatchPath: "#Tab1"),
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab2-home" ])),
      image: .init(systemName: "figure.basketball"),
      title: "Tab#2",
      tagMatchPath: "#Tab2"),
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab3-home" ])),
      image: .init(systemName: "figure.climbing"),
      title: "Tab#3",
      tagMatchPath: "#Tab3"),
    .init(
      navigator: .init(initialLinkItem: .init(paths: [ "tab4-home" ])),
      image: .init(systemName: "figure.skiing.crosscountry"),
      title: "Tab#4",
      tagMatchPath: "#Tab4"),
  ],
  routeBuilderItemList: [
    .init(
      matchPath: "home",
      routeBuild: { navigator, _, _ in
        WrappingController(matchPath: "home") {
          VStack {
            Spacer()
            Text("home")
            Button(action: { print("111") }) {
              Text("push")
            }
            Button(action: {
              navigator.back(isAnimated: true)
            }) {
              Text("back")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page1",
      routeBuild: { navigator, items, _ in
        WrappingController(matchPath: "page1") {
          VStack {
            Spacer()
            Text("page1")
            Button(action: {
              navigator.sheet(paths: ["page3"], items: [:], isAnimated: true)
            }) {
              Text("sheet page3")
            }
            Button(action: {
              navigator.back(isAnimated: true)
            }) {
              Text("back")
            }
            Button(action: {
              navigator.moveToTab(tagPath: "#Tab1")
            }) {
              Text("Move Tab 1")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page2",
      routeBuild: { navigator, _, _ in
        WrappingController(matchPath: "page2") {
          VStack {
            Spacer()
            Text("page2")
            Button(action: {
              navigator.back(isAnimated: true)
            }) {
              Text("back")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page3",
      routeBuild: { navigator, items, _ in
        WrappingController(matchPath: "page3") {
          VStack {
            Spacer()
            Text("page3")
            Button(action: {
              navigator.moveToTab(tagPath: "#Tab3")
            }) {
              Text("Move Tab 3")
            }
            Button(action: {
              navigator.backOrNext(path: "tab1-home", items: [:], isAnimated: true)
            }) {
              Text("back")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "tab1-home",
      routeBuild: { navigator, items, _ in
        WrappingController(matchPath: "tab1-home") {
          VStack {
            Spacer()
            Text("tab1-home")
            Button(action: {
              navigator.next(paths: ["page1"], items: [:], isAnimated: true)
            }) {
              Text("next page1")
            }

            Button(action: {
              navigator.next(paths: ["page3"], items: [:], isAnimated: true)
            }) {
              Text("next page3")
            }

            Button(action: {
              navigator.moveToTab(tagPath: "#Tab3")
            }) {
              Text("Move Tab3")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "tab2-home",
      routeBuild: { _, _, _ in
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
      routeBuild: { navigator, items, _ in
        WrappingController(matchPath: "tab3-home") {
          VStack {
            Spacer()
            Text("tab3-home")
            Button(action: {
              navigator.next(paths: ["page1"], items: [:], isAnimated: true)
            }) {
              Text("next page1")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "tab4-home",
      routeBuild: { _, _, _ in
        WrappingController(matchPath: "tab4-home") {
          VStack {
            Spacer()
            Text("tab4-home")
            Spacer()
          }
        }
      }),
  ],
  dependency: AppDependency(),
  defaultTagPath: "#Tab1")

let single = SingleLinkNavigator(
  rootNavigator: .init(initialLinkItem: .init(paths: ["tabbar"])),
  routeBuilderItemList: [
    .init(
      matchPath: "tabbar",
      routeBuild: { navigator, items, _ in
        WrappingController(matchPath: "tabbar") {
          TabView {
            ScrollView {
              VStack {
                Text("Tab1")
                Button(action: { navigator.backOrNext(path: "page1", items: [:], isAnimated: true) }) {
                  Text("go to page1")
                }
                Spacer()
                Button(action: { navigator.backOrNext(path: "page2", items: [:], isAnimated: true) }) {
                  Text("go to page2")
                }
                Text("End")
              }
              .frame(maxWidth: .infinity)
              .frame(height: 3000)
            }
            .tabItem {
              Image(systemName: "1.square.fill")
              Text("First")
            }
            VStack {
              Spacer()
              Text("Tab2")
              Button(action: { navigator.backOrNext(path: "page1", items: [:], isAnimated: true) }) {
                Text("go to page1")
              }
              Button(action: {
                navigator.sheet(paths: ["page3"], items: [:], isAnimated: true)
              }) {
                Text("sheet page3")
              }
              Spacer()
            }
            .tabItem {
              Image(systemName: "2.square.fill")
              Text("Second")
            }
            VStack {
              Spacer()
              Text("Tab3")
              Button(action: { navigator.backOrNext(path: "page1", items: [:], isAnimated: true) }) {
                Text("go to page1")
              }
              Spacer()
            }
            .tabItem {
              Image(systemName: "3.square.fill")
              Text("Third")
            }
            .badge(10)
          }
          .font(.headline)

        }
      }),
    .init(
      matchPath: "home",
      routeBuild: { navigator, _, _ in
        WrappingController(matchPath: "home") {
          VStack {
            Spacer()
            Text("home")
            Button(action: { print("111") }) {
              Text("push")
            }
            Button(action: {
              navigator.back(isAnimated: true)
            }) {
              Text("back")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page1",
      routeBuild: { navigator, items, _ in
        WrappingController(matchPath: "page1") {
          VStack {
            Spacer()
            Text("page1")
            Button(action: {
              navigator.sheet(paths: ["page3"], items: [:], isAnimated: true)
            }) {
              Text("sheet page3")
            }
            Button(action: { navigator.backOrNext(path: "tabbar", items: [:], isAnimated: true) }) {
              Text("go to tabbar")
            }
            Button(action: {
              navigator.back(isAnimated: true)
            }) {
              Text("back")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page2",
      routeBuild: { navigator, _, _ in
        WrappingController(matchPath: "page2") {
          VStack {
            Spacer()
            Text("page2")
            Button(action: {
              navigator.back(isAnimated: true)
            }) {
              Text("back")
            }
            Spacer()
          }
        }
      }),
    .init(
      matchPath: "page3",
      routeBuild: { navigator, _, _ in
        WrappingController(matchPath: "page3") {
          VStack {
            Spacer()
            Text("page3")
            Button(action: {
              navigator.back(isAnimated: true)
            }) {
              Text("back")
            }
            Spacer()
          }
        }
      }),
  ],
  dependency: AppDependency())
