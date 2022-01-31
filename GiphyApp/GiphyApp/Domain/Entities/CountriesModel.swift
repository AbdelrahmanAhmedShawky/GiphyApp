import Foundation

struct CountriesModel: Codable, Equatable {
    let countries: [Country]?
}

struct Country: Codable,Equatable {
    let name: String?
    let language: Language?
}

struct Language: Codable,Equatable {
    let code: String?
    let name: String?
}
