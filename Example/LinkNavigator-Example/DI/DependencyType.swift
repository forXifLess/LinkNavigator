import Foundation
import LinkNavigator

protocol DependencyType {
  var appEnvironment: EnvironmentType { get }
  var appRouteBuildGroup: RouterBuildGroupType { get }
}
