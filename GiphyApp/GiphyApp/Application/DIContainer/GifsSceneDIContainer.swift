import UIKit

final class GifsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
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
    
    // MARK: - Repositories
    func makeGifsRepository() -> GifListRepository {
        return GifListDataRepository(dataTransferService: dependencies.apiDataTransferService)
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
}

extension GifsSceneDIContainer: GifsSearchFlowCoordinatorDependencies {}
