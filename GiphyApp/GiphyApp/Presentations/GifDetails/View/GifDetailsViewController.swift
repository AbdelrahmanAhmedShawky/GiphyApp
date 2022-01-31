import UIKit
import WebKit

final class GifDetailsViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private var gifImageView: WKWebView!
    @IBOutlet private var overviewTextView: UITextView!

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
        bind(to: viewModel)
    }

    private func bind(to viewModel: GifDetailsViewModel) {

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - Private

    private func setupViews() {
        title = viewModel.gif.title
        overviewTextView.text = viewModel.gif.title
        DispatchQueue.main.async {
            guard let url = self.viewModel.gif.images?.fixed_height?.url else {
                return
            }
            let html = "<img src=\"\(url)\" width=\"100%\">"
          self.gifImageView.loadHTMLString(html, baseURL: nil)
        }
//        posterImageView.isHidden = viewModel.isPosterImageHidden
        view.accessibilityIdentifier = AccessibilityIdentifier.gifDetailsView
    }
}
