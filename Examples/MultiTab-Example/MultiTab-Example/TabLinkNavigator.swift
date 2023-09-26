import Foundation
import LinkNavigator
import SwiftUI

struct NavigationBuilder {
}

extension NavigationBuilder {
  var tabLinkNavigator: (AppDependency) -> TabLinkNavigator<String> {
    { dependency in
      TabLinkNavigator<String>(
        linkPath: "tabHome",
        tabItemList: [
          .init(
            navigator: .init(initialLinkItem: .init(path: "tab1-home")),
            image: .init(systemName: "figure.american.football"),
            title: "Tab#1",
            tagMatchPath: "#Tab1"),
          .init(
            navigator: .init(initialLinkItem: .init(path: "tab2-home")),
            image: .init(systemName: "figure.basketball"),
            title: "Tab#2",
            tagMatchPath: "#Tab2"),
          .init(
            navigator: .init(initialLinkItem: .init(path: "tab3-home")),
            image: .init(systemName: "figure.climbing"),
            title: "Tab#3",
            tagMatchPath: "#Tab3"),
          .init(
            navigator: .init(initialLinkItem: .init(path: "tab4-home")),
            image: .init(systemName: "figure.skiing.crosscountry"),
            title: "Tab#4",
            tagMatchPath: "#Tab4"),
        ],
        routeBuilderItemList: [
          .init(
            matchPath: "page1",
            routeBuild: { navigator, _, dep in
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
                    navigator.back(isAnimated: true)
                  }) {
                    Text("back")
                  }
                  Button(action: {
                    navigator.moveToTab(tagPath: "#Tab1")
                  }) {
                    Text("Move Tab 1")
                  }
                  Button(action: {
                    guard let appDep: AppDependency = dep.resolve() else { return }
                    appDep.userManager.onChange(isLogin: false)
                  }) {
                    Text("logOut")
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
                    navigator.moveToTab(tagPath: "#Tab3")
                  }) {
                    Text("Move Tab 3")
                  }
                  Button(action: {
                    navigator.backOrNext(linkItem: .init(path: "tab1-home"), isAnimated: true)
                  }) {
                    Text("back")
                  }
                  Spacer()
                }
              }
            }),
          .init(
            matchPath: "tab1-home",
            routeBuild: { navigator, _, _ in
              WrappingController(matchPath: "tab1-home") {
                VStack {
                  Spacer()
                  Text("tab1-home")
                  Button(action: {
                    navigator.next(linkItem: .init(path: "page1"), isAnimated: true)
                  }) {
                    Text("next page1")
                  }

                  Button(action: {
                    navigator.next(linkItem: .init(path: "page3"), isAnimated: true)
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
            routeBuild: { navigator, _, _ in
              WrappingController(matchPath: "tab3-home") {
                VStack {
                  Spacer()
                  Text("tab3-home")
                  Button(action: {
                    navigator.next(linkItem: .init(path: "page1"), isAnimated: true)
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
        dependency: dependency,
        defaultTagPath: "#Tab1")
    }
  }

  var singleLinkNavigator: (AppDependency) -> SingleLinkNavigator<String> {
    { dependency in
      SingleLinkNavigator<String>(
        rootNavigator: .init(initialLinkItem: .init(path: "onBoarding")),
        routeBuilderItemList: [
          .init(
            matchPath: "onBoarding",
            routeBuild: { navigator, _, _ in
              WrappingController(matchPath: "onBoarding") {
                VStack {
                  Spacer()
                  Text("onBoarding")
                  HStack {
                    Spacer()
                    Button(action: {
                      navigator.backOrNext(linkItem: .init(path: "login", items: ""), isAnimated: true)
                    }) {
                      Text("Login")
                    }

                    Text("|")
                      .padding(8)

                    Button(action: {
                      navigator.backOrNext(linkItem: .init(path: "register", items: ""), isAnimated: true)
                    }) {
                      Text("Register")
                    }
                    Spacer()
                  }
                  Spacer()
                }
              }
            }),
          .init(
            matchPath: "login",
            routeBuild: { navigator, _, dep in
              WrappingController(matchPath: "login") {
                VStack {
                  Spacer()
                  Text("Login")

                  Button(action: {
                    navigator.remove(pathList: ["login"])
                    navigator.backOrNext(linkItem: .init(path: "register", items: ""), isAnimated: true)
                  }) {
                    Text("Regster")
                  }

                  Button(action: {
                    guard let appDep: AppDependency = dep.resolve() else { return }
                    appDep.userManager.onChange(isLogin: true)
                  }) {
                    Text("Login Complete")
                  }

                  Spacer()
                }
              }
            }),
          .init(
            matchPath: "register",
            routeBuild: { navigator, _, dep in
              WrappingController(matchPath: "register") {
                VStack {
                  Spacer()
                  Text("Register")
                  Button(action: {
                    navigator.remove(pathList: ["register"])
                    navigator.backOrNext(linkItem: .init(path: "login", items: ""), isAnimated: true)
                  }) {
                    Text("login")
                  }
                  Button(action: {
                    guard let appDep: AppDependency = dep.resolve() else { return }
                    appDep.userManager.onChange(isLogin: true)
                  }) {
                    Text("Register Complete")
                  }
                  Spacer()
                }
              }
            }),
        ],
        dependency: dependency)
    }
  }
}
