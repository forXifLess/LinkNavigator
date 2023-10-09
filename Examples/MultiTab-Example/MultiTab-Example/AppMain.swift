import LinkNavigator
import SwiftUI

// MARK: - AppMain

@main
struct AppMain {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  @StateObject var userManager: UserManager = .init()
}

// MARK: App

extension AppMain {
//  var tabNavigator: TabLinkNavigator<String> {
//    tab
//  }

  var singleNavigator: SingleLinkNavigator<String> {
    NavigationBuilder().singleLinkNavigator(.init(userManager: userManager))
  }
}

// MARK: App

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      LinkNavigationView(linkNavigator: single)
        .ignoresSafeArea()
//      tabNavigator
//        .launch()
//      singleNavigator
//        .launch()
    }
  }
}

//let tab = TabLinkNavigator<String>(
//  linkPath: "tabHome",
//  tabItemList: [
//    .init(
//      navigator: .init(initialLinkItem: .init(path: "tab1-home")),
//      image: .init(systemName: "figure.american.football"),
//      title: "Tab#1",
//      tagMatchPath: "#Tab1"),
//    .init(
//      navigator: .init(initialLinkItem: .init(path: "tab2-home")),
//      image: .init(systemName: "figure.basketball"),
//      title: "Tab#2",
//      tagMatchPath: "#Tab2"),
//    .init(
//      navigator: .init(initialLinkItem: .init(path: "tab3-home")),
//      image: .init(systemName: "figure.climbing"),
//      title: "Tab#3",
//      tagMatchPath: "#Tab3"),
//    .init(
//      navigator: .init(initialLinkItem: .init(path: "tab4-home")),
//      image: .init(systemName: "figure.skiing.crosscountry"),
//      title: "Tab#4",
//      tagMatchPath: "#Tab4"),
//  ],
//  routeBuilderItemList: [
//    .init(
//      matchPath: "home",
//      routeBuild: { navigator, _, _ in
//        WrappingController(matchPath: "home") {
//          VStack {
//            Spacer()
//            Text("home")
//            Button(action: { print("111") }) {
//              Text("push")
//            }
//            Button(action: {
//              navigator.back(isAnimated: true)
//            }) {
//              Text("back")
//            }
//            Spacer()
//          }
//        }
//      }),
//    .init(
//      matchPath: "page1",
//      routeBuild: { navigator, _, _ in
//        WrappingController(matchPath: "page1") {
//          VStack {
//            Spacer()
//            Text("page1")
//            Button(action: {
//              navigator.sheet(linkItem: .init(path: "page3"), isAnimated: true)
//            }) {
//              Text("sheet page3")
//            }
//            Button(action: {
//              navigator.back(isAnimated: true)
//            }) {
//              Text("back")
//            }
//            Button(action: {
//              navigator.moveToTab(tagPath: "#Tab1")
//            }) {
//              Text("Move Tab 1")
//            }
//            Spacer()
//          }
//        }
//      }),
//    .init(
//      matchPath: "page2",
//      routeBuild: { navigator, _, _ in
//        WrappingController(matchPath: "page2") {
//          VStack {
//            Spacer()
//            Text("page2")
//            Button(action: {
//              navigator.back(isAnimated: true)
//            }) {
//              Text("back")
//            }
//            Spacer()
//          }
//        }
//      }),
//    .init(
//      matchPath: "page3",
//      routeBuild: { navigator, _, _ in
//        WrappingController(matchPath: "page3") {
//          VStack {
//            Spacer()
//            Text("page3")
//            Button(action: {
//              navigator.moveToTab(tagPath: "#Tab3")
//            }) {
//              Text("Move Tab 3")
//            }
//            Button(action: {
//              navigator.backOrNext(linkItem: .init(path: "tab1-home"), isAnimated: true)
//            }) {
//              Text("back")
//            }
//            Spacer()
//          }
//        }
//      }),
//    .init(
//      matchPath: "tab1-home",
//      routeBuild: { navigator, _, _ in
//        WrappingController(matchPath: "tab1-home") {
//          VStack {
//            Spacer()
//            Text("tab1-home")
//            Button(action: {
//              navigator.next(linkItem: .init(path: "page1"), isAnimated: true)
//            }) {
//              Text("next page1")
//            }
//
//            Button(action: {
//              navigator.next(linkItem: .init(path: "page3"), isAnimated: true)
//            }) {
//              Text("next page3")
//            }
//
//            Button(action: {
//              navigator.moveToTab(tagPath: "#Tab3")
//            }) {
//              Text("Move Tab3")
//            }
//            Spacer()
//          }
//        }
//      }),
//    .init(
//      matchPath: "tab2-home",
//      routeBuild: { _, _, _ in
//        WrappingController(matchPath: "tab2-home") {
//          VStack {
//            Spacer()
//            Text("tab2-home")
//            Spacer()
//          }
//        }
//      }),
//    .init(
//      matchPath: "tab3-home",
//      routeBuild: { navigator, _, _ in
//        WrappingController(matchPath: "tab3-home") {
//          VStack {
//            Spacer()
//            Text("tab3-home")
//            Button(action: {
//              navigator.next(linkItem: .init(path: "page1"), isAnimated: true)
//            }) {
//              Text("next page1")
//            }
//            Spacer()
//          }
//        }
//      }),
//    .init(
//      matchPath: "tab4-home",
//      routeBuild: { _, _, _ in
//        WrappingController(matchPath: "tab4-home") {
//          VStack {
//            Spacer()
//            Text("tab4-home")
//            Spacer()
//          }
//        }
//      }),
//  ],
//  dependency: AppDependency(),
//  defaultTagPath: "#Tab1")

let single = SingleLinkNavigator<String>(
  rootNavigator: .init(initialLinkItem: .init(path: "login")),
  routeBuilderItemList: [
    .init(
      matchPath: "tabbar",
      routeBuild: { navigator, items, env in
        guard let appEnv = env as? AppDependency else { return .none }
        return WrappingController(matchPath: "tabbar") {
          TabBarPage(navigator: navigator, items: items, eventObserver: appEnv.eventObserver)
        }
      }),
    .init(matchPath: "login", routeBuild: { navigator, _, _ in
      WrappingController(matchPath: "login") {
        VStack {
          Text("Required Login")
          Button(action: {
            navigator.replace(linkItem: .init(path: "tabbar", items: ""), isAnimated: true)
          }) {
            Text("Login")
          }
        }
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
      routeBuild: { navigator, _, _ in
        WrappingController(matchPath: "page1") {
          VStack {
            Spacer()
            Text("page1")
            Button(action: {
              navigator.sheet(linkItem: .init(path: "page3"), isAnimated: true)
            }) {
              Text("sheet page3")
            }
            Button(action: {
              navigator.backOrNext(linkItem: .init(path: "tabbar"), isAnimated: true)
            }) {
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
            Button(action: {
              navigator.backOrNext(linkItem: .init(path: "login", items: ""), isAnimated: true)
            }) {
              Text("LogOut")
            }
            Spacer()
          }
        }
      }),
  ],
  dependency: AppDependency())

// MARK: - TabBarPage

struct TabBarPage: View {
  let navigator: LinkNavigatorURLEncodedItemProtocol
  let items: String
  @ObservedObject var eventObserver: EventObserver<EventState>

  var body: some View {
    TabView(selection: .init(
      get: { eventObserver.state.currentTabID },
      set: { eventObserver.state.currentTabID = $0 }))
    {
      ScrollView {
        VStack {
          Text("Tab1")
          Button(action: {
            navigator.backOrNext(linkItem: .init(path: "page1", items: ""), isAnimated: true)
          }) {
            Text("go to page1")
          }
          Spacer()
          Button(action: {
            navigator.backOrNext(linkItem: .init(path: "page2"), isAnimated: true)
          }) {
            Text("go to page2")
          }
          Spacer()
          Button(action: {
            navigator.replace(linkItem: .init(path: "login", items: ""), isAnimated: false)
          }) {
            Text("Log out")
          }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 3000)
      }
    }
  }
}
