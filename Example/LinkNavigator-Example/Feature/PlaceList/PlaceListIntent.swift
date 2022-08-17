import Combine
import Foundation

// MARK: - PlaceListIntentType

protocol PlaceListIntentType {
  var state: PlaceListModel.State { get }

  func send(action: PlaceListModel.ViewAction)
}

// MARK: - PlaceListIntent

final class PlaceListIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State) {
    state = initialState
  }

  // MARK: Internal

  typealias State = PlaceListModel.State
  typealias ViewAction = PlaceListModel.ViewAction

  @Published var state: State = .init(places: [])
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, PlaceListIntentType

extension PlaceListIntent: IntentType, PlaceListIntentType {
  func mutate(action: PlaceListModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .getPlaceList:
      (1..<1000)
        .forEach {
          state = state.mutate(places: state.places + [$0])
        }

    case let .onTapPlace(id):
      break

    case .onTapBack:
      break
    }
  }
}

// MARK: - PlaceViewModel

struct PlaceViewModel {
  struct DomainInfo: Equatable, Codable {
    let imageURL: String
    let size: Size
    let name: String
    let address: String
    let detailAddress: String
    let coordinateUnit: CoordinateUnit
    let link: String?
    let qrImageURL: String?
    let status: DomainStatus
    let isLinkAccessable: Bool
  }

  struct CoordinateUnit: Equatable, Codable {
    let longtitude: Double
    let latitude: Double

    var isValid: Bool {
      !(longtitude.isZero
        && latitude.isZero)
    }
  }

  struct Size: Equatable, Codable {
    let width: Double
    let height: Double

    static var zero: Self {
      .init(width: .zero, height: .zero)
    }
  }

  enum DomainStatus: Equatable, Codable {
    case expired
    case posted(expireDate: String)
    case none
  }
}
