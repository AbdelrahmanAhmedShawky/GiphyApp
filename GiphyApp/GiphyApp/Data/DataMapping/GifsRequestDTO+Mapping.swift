import Foundation

struct GifsTrendingRequestDTO: Encodable {
    let limit: Int
    let rating:String
}

struct GifsSearchingRequestDTO: Encodable {
    let q: String
    let limit: Int
    let lang :String
    let rating:String
}
