import Foundation

final class LanguageRepository {

    private let fileService: FileManagerServiceProtocol

    init(fileService: FileManagerServiceProtocol = FileManagerService()) {
        self.fileService = fileService
    }
}

extension LanguageRepository: LanguageListRepository {
    
    func fetchLanguageList(completion: @escaping (Result<CountriesModel, NetworkError>) -> Void) {
        let resource: FileManagerResource<CountriesModel> = {
            FileManagerResource(fileName: "Countries")

        }()
        
        self.fileService.load(resource: resource) { result in
            completion(result)
        }
    }
    
}
