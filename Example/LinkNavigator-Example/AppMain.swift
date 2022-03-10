import SwiftUI

// MARK: - AppMain

@main
struct AppMain {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDeletate
}

// MARK: App

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      appDeletate.linkRouter
        .replace(url: "link-navigator://home", target: .root, animated: true, didOccuredError: .none)
        .onOpenURL { url in
          _ = appDeletate.linkRouter
            .replace(url: url.absoluteString, target: .root, animated: true, didOccuredError: { _, _ in
              appDeletate.linkRouter.alert(model: .init(
                message: "잘못된 주소입니다.",
                buttons: [
                  .init(title: "ok", style: .cancel, action: {}),
                ],
                flagType: .error))
            })
        }
    }
  }
}
