import Foundation

struct FileManagerResource<T> {
    let fileName: String
}

protocol FileManagerServiceProtocol {
    func load<T: Decodable>(resource: FileManagerResource<T>,completion: @escaping (Result<T, NetworkError>) -> Void)
}

struct FileManagerService: FileManagerServiceProtocol {
    
    func load<T: Decodable>(resource: FileManagerResource<T>, completion: @escaping (Result<T, NetworkError>) -> Void){
        guard let url =  Bundle.main.path(forResource: resource.fileName, ofType: "json") else {
            completion(.failure(NetworkError.notConnected))
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: url))
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: data)
            completion(.success(jsonData))
        } catch {
            print("error:\(error)")
            completion(.failure(NetworkError.notConnected))
        }
    }
    
}
