import Foundation

enum PlaceListModel {
  struct State: Equatable {
    let places: [Int]

    func mutate(places: [Int]) -> Self {
      .init(places: places)
    }
  }

  enum ViewAction: Equatable {
    case getPlaceList
    case onTapBack
    case onTapPlace(Int)
  }

}
