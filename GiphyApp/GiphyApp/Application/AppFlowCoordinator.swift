import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let defaults = UserDefaults.standard
        if let rating = defaults.string(forKey: "rating") , let lang = defaults.string(forKey: "lang") {
            if (rating.isEmpty) || (lang.isEmpty) {
                let onBording = appDIContainer.makeGifsSceneDIContainer()
                let flow = onBording.makeOnBordingFlowCoordinator(navigationController: navigationController, appDIContainer: self.appDIContainer)
                flow.start()
            }else {
                let gifsSceneDIContainer = appDIContainer.makeGifsSceneDIContainer()
                let flow = gifsSceneDIContainer.makeGifsSearchFlowCoordinator(navigationController: navigationController)
                flow.start()
            }
        }else {
            let onBording = appDIContainer.makeGifsSceneDIContainer()
            let flow = onBording.makeOnBordingFlowCoordinator(navigationController: navigationController, appDIContainer: self.appDIContainer)
            flow.start()
        }
    }
}
