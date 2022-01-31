import Foundation

final class GifListDataRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension GifListDataRepository: GifListRepository {
    public func fetchGifTrendingList(limit: Int, rating:String,completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable? {
        let requestDTO = GifsTrendingRequestDTO(limit: limit, rating: rating)
        let task = RepositoryTask()

        guard !task.isCancelled else { return nil }

        let endpoint = APIEndpoints.getTrending(with: requestDTO)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    public func fetchGifSearchList(limit: Int, rating: String, query: GifQuery,lang:String ,completion: @escaping (Result<GifsPage, Error>) -> Void) -> Cancellable? {
        let requestDTO = GifsSearchingRequestDTO(q: query.q, limit: limit, lang: lang, rating: rating)
        let task = RepositoryTask()

        guard !task.isCancelled else { return nil }

        let endpoint = APIEndpoints.getSearching(with: requestDTO)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
}
