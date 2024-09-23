import UIKit

@available(iOS 15.0, *)
public struct DetentConfiguration {

  // MARK: Lifecycle

  /// Initializes a new DetentConfiguration.
  ///
  /// - Parameters:
  ///   - detents: An array of `UISheetPresentationController.Detent` defining the sizes of the sheet.
  ///   - cornerRadius: An optional `CGFloat` specifying the corner radius of the sheet.
  ///   - largestUndimmedDetentIdentifier: An optional detent identifier specifying the largest undimmed size.
  ///   - prefersScrollingExpandsWhenScrolledToEdge: A Boolean value indicating if scrolling should expand the sheet.
  ///   - prefersGrabberVisible: A Boolean value indicating if the grabber should be visible.
  ///   - prefersEdgeAttachedInCompactHeight: A Boolean value indicating if the sheet should be edge-attached in compact height.
  ///   - widthFollowsPreferredContentSizeWhenEdgeAttached: A Boolean value indicating if the sheet's width should follow the preferred content size when edge-attached.
  ///   - selectedDetentIdentifier: An optional detent identifier specifying the currently selected detent.
  public init(
    detents: [UISheetPresentationController.Detent],
    cornerRadius: CGFloat? = nil,
    largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
    prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
    prefersGrabberVisible: Bool = false,
    prefersEdgeAttachedInCompactHeight: Bool = false,
    widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
    selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil)
  {
    self.detents = detents
    self.cornerRadius = cornerRadius
    self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
    self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
    self.prefersGrabberVisible = prefersGrabberVisible
    self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
    self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
    self.selectedDetentIdentifier = selectedDetentIdentifier
  }

  // MARK: Public

  public static let `default` = DetentConfiguration(detents: [.medium(), .large()])

  public let detents: [UISheetPresentationController.Detent]
  public let cornerRadius: CGFloat?
  public let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
  public let prefersScrollingExpandsWhenScrolledToEdge: Bool
  public let prefersGrabberVisible: Bool
  public let prefersEdgeAttachedInCompactHeight: Bool
  public let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
  public let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
}
