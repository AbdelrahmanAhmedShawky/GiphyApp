import Foundation

protocol GifListRepository {
    @discardableResult
    func fetchGifTrendingList(limit: Int, rating:String,
                         completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable?
    func fetchGifSearchList(limit: Int, rating:String,query: GifQuery,lang:String,
                         completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable?
}
