import Foundation
import LinkNavigator

struct AppDependency: DependencyType {
  var appEnviroment: EnviromentType {
    Enviroment()
  }

  var appRouteBuildGroup: RouterBuildGroupType {
    RouteBuildGroup()
  }
}
