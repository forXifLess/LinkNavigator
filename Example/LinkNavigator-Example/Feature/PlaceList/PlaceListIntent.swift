import Combine
import Foundation
import LinkNavigator

// MARK: - PlaceListIntentType

protocol PlaceListIntentType {
  var state: PlaceListModel.State { get }
  var enviroment: EnviromentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: PlaceListModel.ViewAction)
}

// MARK: - PlaceListIntent

final class PlaceListIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, enviroment: EnviromentType, navigator: LinkNavigatorType) {
    state = initialState
    self.enviroment = enviroment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = PlaceListModel.State
  typealias ViewAction = PlaceListModel.ViewAction

  @Published var state: State = .init(places: [])
  let enviroment: EnviromentType
  let navigator: LinkNavigatorType
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
      let imgurl = "aHR0cHM6Ly9mbGl0dG90ay5zMy1hY2NlbGVyYXRlLmFtYXpvbmF3cy5jb20vdGVtcC9jNDNhMTMyZi1mZTc0LTRjMDItOTJiZC01ZDVlOWY1NTE4MmFfcGhvdG8uanBnP0FXU0FjY2Vzc0tleUlkPUFTSUE0SEdGRVJXTlZUU1JOTEJQJkV4cGlyZXM9MTY0NzQxMDUzNCZTaWduYXR1cmU9aFptbzlHJTJCZmdFc0g1aXBSclVEWE12elR1d3clM0QmeC1hbXotc2VjdXJpdHktdG9rZW49SVFvSmIzSnBaMmx1WDJWakVBNGFEbUZ3TFc1dmNuUm9aV0Z6ZEMweElrWXdSQUlnU3U2aDJ1M3F4bUU2aURzaDIzZVd0OXhBbklWZDBEOUpBYXQlMkYyS3h5S1lRQ0lDZXpjWFQ5cUNSVEpDa0N3TzhHTUJnYkNVdmlrc1g5M3RuWWVlcW1sdGxKS3FrQ0NJZiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRndFUUFCb01PRFF3TURjNU5UUXpOekEzSWd5ZTk3UjVVYWhEaGlweGVZNHElMkZRRk5qam5SbGdrNkxWJTJCJTJCR3d4TG1sOTdseiUyQjUlMkZNVURBbmNVYUk4Z05pTGMwMHZSbkdWMHVqJTJCSyUyRjd3UVF6cUJ0QnhCODlMdXozTmU4YnRPakpPQXN0QmFDakhpZ2VMZU5Tb0lCb1J0NzV1WndBNEdvJTJGZVhFaUNxQ2ZpZUxuQ3N4cmtYUVA5JTJCY0pYYW9CUFN6cSUyRkZkdFJhRU1JTlJkaWJVbU9sWlZRNFBpSXglMkI4N2h2NkU0bkgwOVpwczQyTFNER0x6UVAwQ0M1d3h0WHBHZEJreUFyJTJCTG04UE5MZjBzZFdRSWJEeDVTeEhjd2d4SVVnWkVaS25sbkd2JTJGbUV0ek9SOEoySDZlUHhNcFlxd1FGbndIdUNodU1IbzVDRFRWMkhPQWZWR2E2UnVYZm9wRGk3d3RoS2tqJTJGUkVlbWkyWEZNdk5NR3pqalozZm4ybmdOMjM1N01PSHp4WkVHT3BzQjAzYTBubkJhWnpkcFc0NkRSRkhKV21rd0V3V2VvaGJhOVpyM2paT3N0a1NYeXozcnB0aDBBciUyQkNvR0FXdTR4aFpuRmhDUXpVVDNDR3dNM25YdWRJNk11SUZad2JqaGE3bVFEa1JySjV0alNFMnJyQkZIWG0ybnY5JTJCTkx1QTZ1aEN4ayUyQlNxeEU1bUQ2REdLc3NBZmtLUG9OV3BtcDV4bTdXOUdnTiUyRjVqRlVjc3VIQ1pSYnVzVU5kMTlmNnVjUGx5YTBqSmRlQmpoRTIycXRvJTNE"
      navigator.href(
        paths: ["place"],
        queryItems: ["placeInfo": PlaceViewModel.DomainInfo(
          imageURL: imgurl,
          size: .init(width: 30, height: 30),
          name: "한글",
          address: "한글 주소",
          detailAddress: "",
          coordinateUnit: .init(longtitude: 30, latitude: 30.222),
          link: .none,
          qrImageURL: .none,
          status: .none,
          isLinkAccessable: true)],
        animated: true,
        didOccuredError: .none)
//      navigator.href(url: "/place?place_id=\(id)", animated: true, didOccuredError: .none)

    case .onTapBack:
//      navigator.back(animated: true)
      navigator.back(path: "setting", animated: true)
    }
  }
}

// MARK: - PlaceViewModel

struct PlaceViewModel {
  struct DomainInfo: Equatable, Codable, QueryItemConvertable {
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
