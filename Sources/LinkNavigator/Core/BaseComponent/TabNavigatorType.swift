import Foundation

public protocol TabNavigatorType {

  /// This is a function to manually control the position of the tab.
  ///
  /// You can programmatically change the position of the tab.
  /// If you want to change the tab location, use this feature.
  ///
  /// - Note:
  ///   Do not confuse it with LinkPath. This path is the unique path that the tab has.
  ///
  /// ```swift
  /// case .onTapMoveTabPage4:
  ///  navigator.moveToTab(tagPath: "#Tab4")
  ///
  ////// RouteTabItem adding
  ///
  /// TabBarNavigator(
  ///  navigator: .init(initialLinkItem: .init(paths: [ "tab4-home" ])),
  ///  image: .init(systemName: "figure.american.football"),
  ///  title: "Tab4",
  ///  tagMatchPath: "#Tab4")
  ///
  /// ```
  ///
  func moveToTab(tagPath: String)
}
