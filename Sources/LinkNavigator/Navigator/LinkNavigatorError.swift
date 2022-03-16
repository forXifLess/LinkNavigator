import Foundation

public enum LinkNavigatorError: Error {
  case notAllowedURL
  case notFound
  case invalidQueryItem(rawValue: String)
}
