import Foundation

protocol LanguageListRepository {
    func fetchLanguageList(completion: @escaping (Result<CountriesModel, NetworkError>) -> Void)
}
