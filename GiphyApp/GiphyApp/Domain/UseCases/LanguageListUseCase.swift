import Foundation

protocol FetchingLanguageListUseCase {
    func languageListExecute(completion: @escaping (Result<CountriesModel, NetworkError>) -> Void)
}

final class DefaultFetchLanguageListUseCase: FetchingLanguageListUseCase {
    
    
    private let languageListRepository: LanguageListRepository

    init(languageListRepository: LanguageListRepository) {

        self.languageListRepository = languageListRepository
    }
    
    func languageListExecute(completion: @escaping (Result<CountriesModel, NetworkError>) -> Void) {
        self.languageListRepository.fetchLanguageList { result in
            completion(result)
        }
    }
        
}
