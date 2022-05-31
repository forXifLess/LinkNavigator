import Foundation
import LinkNavigator

struct AppDependency: DependencyType {
  var appEnvironment: EnvironmentType {
    Environment()
  }

  var appRouteBuildGroup: RouterBuildGroupType {
    RouteBuildGroup()
  }
}
