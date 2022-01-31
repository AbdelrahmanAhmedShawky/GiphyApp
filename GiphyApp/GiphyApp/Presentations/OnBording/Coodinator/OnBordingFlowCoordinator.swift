import Foundation
import UIKit

protocol OnBordingFlowCoordinatorDependencies  {
    func makeOnBordingViewController(actions: OnBordingActions) -> OnBordingViewController
    func makeGifsListViewController(actions: GifsListViewModelActions) -> GifsListViewController
}

final class OnBordingFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: OnBordingFlowCoordinatorDependencies
    private let appDIContainer: AppDIContainer
    private weak var onBordingVC: OnBordingViewController?

    init(navigationController: UINavigationController,
         dependencies: OnBordingFlowCoordinatorDependencies,
         appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let actions = OnBordingActions(showGifList: showGifList)
        let vc = dependencies.makeOnBordingViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        onBordingVC = vc
    }

    private func showGifList() {
        let gifsSceneDIContainer = appDIContainer.makeGifsSceneDIContainer()
        let flow = gifsSceneDIContainer.makeGifsSearchFlowCoordinator(navigationController: navigationController!)
        flow.start()
    }

}
