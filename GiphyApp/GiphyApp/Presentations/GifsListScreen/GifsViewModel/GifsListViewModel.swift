import Foundation

struct GifsListViewModelActions {
    let showGifDetails: (GifObject) -> Void
}

enum GifsListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol GifsListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didPullToRefresh()
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectItem(at index: Int)
}

protocol GifsListViewModelOutput {
    var items: Observable<[GifsListItemViewModel]> { get }
    var loading: Observable<GifsListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol GifsListViewModel: GifsListViewModelInput, GifsListViewModelOutput {}

final class DefaultGifsListViewModel: GifsListViewModel {

    private let searchGifsUseCase: FetchGifsUseCase
    private let actions: GifsListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 10
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 10 : currentPage }

    private var pages: [GifsPage] = []
    private var gifsLoadTask: Cancellable? { willSet { gifsLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[GifsListItemViewModel]> = Observable([])
    let loading: Observable<GifsListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Gifs", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Gif", comment: "")

    // MARK: - Init

    init(searchGifsUseCase: FetchGifsUseCase,
         actions: GifsListViewModelActions? = nil) {
        self.searchGifsUseCase = searchGifsUseCase
        self.actions = actions
    }

    // MARK: - Private

    private func appendPage(_ gifsPage: GifsPage) {
        currentPage = gifsPage.pagination.count ?? 0
        totalPageCount = gifsPage.pagination.total_count ?? 0

        pages = pages
            .filter { $0.pagination.count != gifsPage.pagination.count }
            + [gifsPage]

       
        items.value = pages.gifs.map(GifsListItemViewModel.init)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // yyyy-MM-dd HH:mm:ss"

        items.value = items.value.sorted(by: { dateFormatter.date(from:$0.import_datetime)!.compare(dateFormatter.date(from:$1.import_datetime)!) == .orderedDescending })
    }
// title = "Lunar New Year Lol GIF by League of Legends";
    private func resetPages(gifQuery: GifQuery) {
        currentPage = 0
        totalPageCount = 10
        self.query.value = gifQuery.q
        pages.removeAll()
        items.value.removeAll()
    }

    private func load(gifQuery: GifQuery, loading: GifsListViewModelLoading) {
        self.loading.value = loading
        query.value = gifQuery.q
        let defaults = UserDefaults.standard
        if let rating = defaults.string(forKey: "rating") , let lang = defaults.string(forKey: "lang") {
            if (gifQuery.q == "") {
                gifsLoadTask = searchGifsUseCase.treandingExecute(limit: nextPage, rating: rating, completion:  { result in
                        switch result {
                        case .success(let page):
                            self.appendPage(page)
                        case .failure(let error):
                            self.handle(error: error)
                        }
                        self.loading.value = .none
                })
            }else {
                gifsLoadTask = searchGifsUseCase.searchingExecute(limit: nextPage, rating: rating, query: gifQuery, lang: lang, completion: { result in
                        switch result {
                        case .success(let page):
                            self.appendPage(page)
                        case .failure(let error):
                            self.handle(error: error)
                        }
                        self.loading.value = .none
                })
            }
        }
        
        
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading Gifs", comment: "")
    }

    private func update(gifQuery: GifQuery) {
        resetPages(gifQuery: gifQuery)
        load(gifQuery: gifQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods

extension DefaultGifsListViewModel {

    func viewDidLoad() {
        update(gifQuery: GifQuery(q: ""))
    }

    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        if (self.query.value.isEmpty) {
            load(gifQuery: .init(q: ""),
                 loading: .nextPage)
        }else {
            load(gifQuery: .init(q: self.query.value),
                 loading: .nextPage)
        }
      
    }

    func didPullToRefresh() {
        update(gifQuery: GifQuery(q: query.value))
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        self.query.value = query
        update(gifQuery: GifQuery(q: query))
    }

    func didCancelSearch() {
        gifsLoadTask?.cancel()
        update(gifQuery: GifQuery(q: ""))
    }

    func didSelectItem(at index: Int) {
        actions?.showGifDetails(pages.gifs[index])
    }
}

// MARK: - Private

private extension Array where Element == GifsPage {
    var gifs: [GifObject] { flatMap { $0.gif } }
}
