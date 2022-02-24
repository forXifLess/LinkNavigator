import Foundation

struct ApplicationDependency: DependencyType {
  var enviroment: EnviromentType {
    Enviroment()
  }
}
