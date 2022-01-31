import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: ["api_key": appConfiguration.apiKey])
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makeGifsSceneDIContainer() -> GifsSceneDIContainer {
        let dependencies = GifsSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return GifsSceneDIContainer(dependencies: dependencies)
    }
}
