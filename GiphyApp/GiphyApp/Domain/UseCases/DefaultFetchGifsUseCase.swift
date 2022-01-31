import Foundation

protocol FetchGifsUseCase {
    func treandingExecute(limit: Int, rating:String,
                         completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable?

    func searchingExecute(limit: Int, rating: String, query: GifQuery,lang:String ,completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable?
}

final class DefaultFetchGifsUseCase: FetchGifsUseCase {
    
    private let gifsRepository: GifListRepository

    init(gifsRepository: GifListRepository) {

        self.gifsRepository = gifsRepository
    }

    func treandingExecute(limit: Int, rating: String, completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable? {
        return gifsRepository.fetchGifTrendingList(limit: limit, rating: rating) { result in
            completion(result)
        }
    }
    
    func searchingExecute(limit: Int, rating: String, query: GifQuery, lang: String, completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable? {
        return gifsRepository.fetchGifSearchList(limit: limit, rating: rating, query: query, lang: lang) { result in
            completion(result)
        }
    }
        
}
