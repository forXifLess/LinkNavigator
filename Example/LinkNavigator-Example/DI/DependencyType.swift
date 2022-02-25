import Foundation
import LinkNavigator

protocol DependencyType {
  var appEnviroment: EnviromentType { get }
  var appRouteBuildGroup: RouterBuildGroupType { get }
}
