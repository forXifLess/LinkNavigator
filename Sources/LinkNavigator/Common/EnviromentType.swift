import Foundation

public protocol EnviromentType {
  associatedtype Content
  var content: Content { get }
}
