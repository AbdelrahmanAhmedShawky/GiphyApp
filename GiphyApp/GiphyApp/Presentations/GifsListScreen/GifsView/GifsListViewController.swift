import Foundation
import UIKit

final class GifsListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var emptyDataLabel: UILabel!
    @IBOutlet private var gifsListTableView:UITableView!
    private var viewModel: GifsListViewModel!
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    private var searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: GifsListViewModel) -> GifsListViewController {
        let view = GifsListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: GifsListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    // MARK: - Private
    
    private func setupViews() {
        title = viewModel.screenTitle
        emptyDataLabel.text = viewModel.emptyDataTitle
        gifsListTableView.estimatedRowHeight = GifsListItemCell.height
        gifsListTableView.rowHeight = UITableView.automaticDimension
        setupSearchController()
        setupRefreshController()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupRefreshController() {
        if #available(iOS 10.0, *) {
            gifsListTableView.refreshControl = refreshControl
        } else {
            gifsListTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.didPullToRefresh()
    }
    
    private func updateItems() {
        self.gifsListTableView.dataSource = self
        self.gifsListTableView.delegate = self
        gifsListTableView?.reloadData()
    }
    
    private func updateLoading(_ loading: GifsListViewModelLoading?) {
        emptyDataLabel.isHidden = true
        gifsListTableView.isHidden = true
        LoadingView.hide()
        self.refreshControl.endRefreshing()
        
        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: gifsListTableView.isHidden = false
        case .none:
            gifsListTableView.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }
        
        self.updateTableLoading(loading)
    }
    
    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    func reload() {
        gifsListTableView.reloadData()
    }
    
    func updateTableLoading(_ loading: GifsListViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: gifsListTableView.frame.width, height: 44))
            gifsListTableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            gifsListTableView.tableFooterView = nil
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GifsListViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GifsListItemCell.reuseIdentifier,
                                                       for: indexPath) as? GifsListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(GifsListItemCell.self) with reuseIdentifier: \(GifsListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}


// MARK: - Search Controller

extension GifsListViewController {
    private func setupSearchController() {
//        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField
        }
    }
}

extension GifsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            guard let searchText = searchBar.text, !searchText.isEmpty else { return }
            if (!searchText.isEmpty) {
                viewModel.didSearch(query: searchText)
            }else {
                viewModel.didCancelSearch()
            }
           
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.viewModel.didCancelSearch()
                searchBar.resignFirstResponder()
            }
        }
    }
}
