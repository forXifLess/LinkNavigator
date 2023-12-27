import Foundation

public enum TabbarEventNotification: Equatable {
  public static let onMoved = Notification.Name("onMoved")
  public static let onSelectedTab = Notification.Name("onSelectedTab")
}
