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
    
    lazy var fileService: FileManagerServiceProtocol = FileManagerService()
    // MARK: - DIContainers of scenes
    func makeGifsSceneDIContainer() -> GifsSceneDIContainer {
        let dependencies = GifsSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService, fileManagerService: fileService)
        return GifsSceneDIContainer(dependencies: dependencies)
    }
}
