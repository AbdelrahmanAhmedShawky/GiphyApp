import Foundation
import UIKit
import WebKit

final class GifsListItemCell: UITableViewCell {

    static let reuseIdentifier = String(describing: GifsListItemCell.self)
    static let height = CGFloat(130)

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var posterGifView: WKWebView!

    private var viewModel: GifsListItemViewModel!
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    func fill(with viewModel: GifsListItemViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        userNameLabel.text = viewModel.username
        DispatchQueue.main.async {
            guard let url = viewModel.images?.fixed_height?.url else {
                return
            }
            let html = "<img src=\"\(url)\" width=\"100%\">"
          self.posterGifView.loadHTMLString(html, baseURL: nil)
        }
    }
}
