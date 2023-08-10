import Foundation
import LinkNavigator
import SwiftUI

//let test = WithTabNavigator(
//  rootNavigator: .init(defaultPath: ""),
//  tabItemList: [
//    .init(
//      navigator: .init(defaultPath: "tab1-home"),
//      image: .init(systemName: "figure.american.football"),
//      title: "Tab#1"),
//    .init(
//      navigator: .init(defaultPath: "tab2-home"),
//      image: .init(systemName: "figure.basketball"),
//      title: "Tab#2"),
//    .init(
//      navigator: .init(defaultPath: "tab3-home"),
//      image: .init(systemName: "figure.climbing"),
//      title: "Tab#3"),
//    .init(
//      navigator: .init(defaultPath: "tab4-home"),
//      image: .init(systemName: "figure.skiing.crosscountry"),
//      title: "Tab#4")
//  ],
//  routeBuilderItemList: [
//    RouteBuilderOf<WithTabNavigator>(
//      matchPath: "tab1-home",
//      routeBuild: { navigator, items, env in
//        WrappingController(matchPath: "tab1-home") {
//          VStack {
//            Spacer()
//            Text("tab1-home")
//            Spacer()
//          }
//        }
//      }),
//    RouteBuilderOf<WithTabNavigator>(
//      matchPath: "tab2-home",
//      routeBuild: { navigator, items, env in
//        WrappingController(matchPath: "tab2-home") {
//          VStack {
//            Spacer()
//            Text("tab2-home")
//            Spacer()
//          }
//        }
//      }),
//    RouteBuilderOf<WithTabNavigator>(
//      matchPath: "tab3-home",
//      routeBuild: { navigator, items, env in
//        WrappingController(matchPath: "tab3-home") {
//          VStack {
//            Spacer()
//            Text("tab3-home")
//            Spacer()
//          }
//        }
//      }),
//    RouteBuilderOf<WithTabNavigator>(
//      matchPath: "tab4-home",
//      routeBuild: { navigator, items, env in
//        WrappingController(matchPath: "tab4-home") {
//          VStack {
//            Spacer()
//            Text("tab4-home")
//            Spacer()
//          }
//        }
//      }),
//  ],
//  dependency: AppDependency())
