import Foundation
import UIKit

public final class SingleLinkNavigatorMock {

  public var value: Value
  public var event: Event

  public init(value: Value = .init(), event: Event = .init()) {
    self.value = value
    self.event = event
  }

  public func resetEvent() {
    event = .init()
  }

  public func resetValue() {
    value = .init()
  }

  public func resetAll() {
    resetEvent()
    resetValue()
  }

}

extension SingleLinkNavigatorMock {

  public struct Value: Equatable, Sendable {
    public var currentPaths: [String] = []
    public var currentRootPaths: [String] = []
    public var rangePaths: [String] = []
    
    public init() {}
  }

  public struct Event: Equatable, Sendable {
    public var getCurrentPaths: Int = .zero
    public var getCurrentRootPaths: Int = .zero
    public var next: Int = .zero
    public var rootNext: Int = .zero
    public var sheet: Int = .zero
    public var fullSheet: Int = .zero
    public var customSheet: Int = .zero
    public var replace: Int = .zero
    public var backOrNext: Int = .zero
    public var rootBackOrNext: Int = .zero
    public var back: Int = .zero
    public var remove: Int = .zero
    public var rootRemove: Int = .zero
    public var backToLast: Int = .zero
    public var close: Int = .zero
    public var range: Int = .zero
    public var rootReloadLast: Int = .zero
    public var alert: Int = .zero
    public var send: Int = .zero
    public var mainSend: Int = .zero
    public var allSend: Int = .zero
    public var rootBackToLast: Int = .zero
    public var rootSend: Int = .zero
    public var allRootSend: Int = .zero

    public init() {}
  }
}

extension SingleLinkNavigatorMock: LinkNavigatorFindLocationUsable {
  public func getCurrentPaths() -> [String] {
    event.getCurrentPaths += 1
    return value.currentPaths
  }

  public func getCurrentRootPaths() -> [String] {
    event.getCurrentRootPaths += 1
    return value.currentRootPaths
  }
}

extension SingleLinkNavigatorMock: LinkNavigatorProtocol {
  public func rootBackToLast(path: String, isAnimated: Bool) {
    event.rootBackToLast += 1
  }
  
  public func rootSend(item: LinkItem) {
    event.rootSend += 1
  }
  
  public func allRootSend(item: LinkItem) {
    event.allRootSend += 1
  }
  
  public func next(linkItem: LinkItem, isAnimated: Bool) {
    event.next += 1
  }

  public func rootNext(linkItem: LinkItem, isAnimated: Bool) {
    event.rootNext += 1
  }

  public func sheet(linkItem: LinkItem, isAnimated: Bool) {
    event.sheet += 1
  }

  public func fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool?) {
    event.fullSheet += 1
  }

  public func customSheet(
    linkItem: LinkItem,
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)
  {
    event.customSheet += 1
  }

  public func replace(linkItem: LinkItem, isAnimated: Bool) {
    event.replace += 1
  }

  public func backOrNext(linkItem: LinkItem, isAnimated: Bool) {
    event.backOrNext += 1
  }

  public func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool) {
    event.rootBackOrNext += 1
  }

  public func back(isAnimated: Bool) {
    event.back += 1
  }

  public func remove(pathList: [String]) {
    event.remove += 1
  }

  public func rootRemove(pathList: [String]) {
    event.rootRemove += 1
  }

  public func backToLast(path: String, isAnimated: Bool) {
    event.backToLast += 1
  }

  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    event.close += 1
  }

  public func range(path: String) -> [String] {
    event.range += 1
    return value.rangePaths
  }

  public func rootReloadLast(items: LinkItem, isAnimated: Bool) {
    event.rootReloadLast += 1
  }

  public func alert(target: NavigationTarget, model: Alert) {
    event.rootReloadLast += 1
  }

  public func send(item: LinkItem) {
    event.send += 1
  }

  public func mainSend(item: LinkItem) {
    event.mainSend += 1
  }

  public func allSend(item: LinkItem) {
    event.allSend += 1
  }

}
