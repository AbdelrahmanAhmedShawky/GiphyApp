import UIKit

final class GifsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let fileManagerService:FileManagerServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    //    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    //    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchGifsUseCase() -> FetchGifsUseCase {
        return DefaultFetchGifsUseCase(gifsRepository: makeGifsRepository())
    }
    
    func makeLanguageUseCase() -> FetchingLanguageListUseCase {
        return DefaultFetchLanguageListUseCase(languageListRepository: makeLanguageRepository())
    }
    
    
    // MARK: - Repositories
    func makeGifsRepository() -> GifListRepository {
        return GifListDataRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeLanguageRepository() -> LanguageListRepository {
        return LanguageRepository(fileService: dependencies.fileManagerService)
    }
    
    // MARK: - Gifs List
    func makeGifsListViewController(actions: GifsListViewModelActions) -> GifsListViewController {
        return GifsListViewController.create(with: makeGifsListViewModel(actions: actions))
    }
    
    func makeGifsListViewModel(actions: GifsListViewModelActions) -> GifsListViewModel {
        return DefaultGifsListViewModel(searchGifsUseCase: makeSearchGifsUseCase(),
                                        actions: actions)
    }
    
    // MARK: - Movie Details
    func makeGifsDetailsViewController(gif: GifObject) -> UIViewController {
        return GifDetailsViewController.create(with: makeGifsDetailsViewModel(gif: gif))
    }
    
    func makeGifsDetailsViewModel(gif: GifObject) -> GifDetailsViewModel {
        return DefaultGifDetailsViewModel(gif: gif)
    }
    
    // MARK: - Flow Coordinators
    func makeGifsSearchFlowCoordinator(navigationController: UINavigationController) -> GifSearchFlowCoordinator {
        return GifSearchFlowCoordinator(navigationController: navigationController,
                                        dependencies: self)
    }
    
    // MARK: - OnBordingViewController
    func makeOnBordingViewController(actions: OnBordingActions) -> OnBordingViewController {
        return OnBordingViewController.create(with: makeOnBordingViewModel(actions: actions))
    }
    
    func makeOnBordingViewModel(actions: OnBordingActions? = nil) -> OnBordingViewModel {
        return DefaultOnBordingViewModel(actions: actions,fetchingLanguageListUseCase: makeLanguageUseCase())
    }
    
    // MARK: - Flow Coordinators
    func makeOnBordingFlowCoordinator(navigationController: UINavigationController,appDIContainer:AppDIContainer) -> OnBordingFlowCoordinator {
        return OnBordingFlowCoordinator(navigationController: navigationController,
                                        dependencies: self,appDIContainer: appDIContainer)
    }
    
    
}

extension GifsSceneDIContainer: OnBordingFlowCoordinatorDependencies {}

extension GifsSceneDIContainer: GifsSearchFlowCoordinatorDependencies {}
