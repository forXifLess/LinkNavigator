import Foundation
import UIKit

public struct TabItem<ItemValue: EmptyValueType> {
  public let tag: String
  public let title: String?
  public let icon: UIImage?
  public let linkItem: LinkItem<ItemValue>
}
