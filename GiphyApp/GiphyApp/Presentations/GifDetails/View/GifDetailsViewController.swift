import UIKit
import WebKit

final class GifDetailsViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private var gifImageView: WKWebView!
    @IBOutlet private var overviewTextView: UITextView!
    @IBOutlet private var btnFavorite:UIButton!
    
    // MARK: - Lifecycle

    private var viewModel: GifDetailsViewModel!
    
    static func create(with viewModel: GifDetailsViewModel) -> GifDetailsViewController {
        let view = GifDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - Private

    private func setupViews() {
        title = viewModel.gif.title
        btnFavorite.setTitle(self.viewModel.getSaveItem.contains(where: {$0.title == viewModel.gif.title }) ? "favorites" :"Add to favorites", for: .normal)
        overviewTextView.text = viewModel.gif.username
        DispatchQueue.main.async {
            guard let url = self.viewModel.gif.images?.fixed_height?.url else {
                return
            }
            let html = "<img src=\"\(url)\" width=\"100%\">"
          self.gifImageView.loadHTMLString(html, baseURL: nil)
        }
        view.accessibilityIdentifier = AccessibilityIdentifier.gifDetailsView
    }
    @IBAction func addToFavorite(_ sender: Any) {
        self.viewModel.getSaveItem.contains(where: {$0.title == viewModel.gif.title })  ? () : viewModel.didSelectItem()
        btnFavorite.setTitle("favorites", for: .normal)
    }
}
