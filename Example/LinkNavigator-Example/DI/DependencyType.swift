import Foundation
import LinkNavigator

protocol DependencyType {
  var appEnviroment: EnvironmentType { get }
  var appRouteBuildGroup: RouterBuildGroupType { get }
}
