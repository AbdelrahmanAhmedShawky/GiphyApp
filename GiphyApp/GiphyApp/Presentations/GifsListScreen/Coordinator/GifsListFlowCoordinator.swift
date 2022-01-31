import Foundation
import UIKit

protocol GifsSearchFlowCoordinatorDependencies  {
    func makeGifsListViewController(actions: GifsListViewModelActions) -> GifsListViewController
    func makeGifsDetailsViewController(gif: GifObject) -> UIViewController
}

final class GifSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: GifsSearchFlowCoordinatorDependencies

    private weak var gifsListVC: GifsListViewController?

    init(navigationController: UINavigationController,
         dependencies: GifsSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = GifsListViewModelActions(showGifDetails: showGifDetails)
        let vc = dependencies.makeGifsListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        gifsListVC = vc
    }

    private func showGifDetails(gif: GifObject) {
        let vc = dependencies.makeGifsDetailsViewController(gif: gif)
        navigationController?.pushViewController(vc, animated: true)
    }

}

