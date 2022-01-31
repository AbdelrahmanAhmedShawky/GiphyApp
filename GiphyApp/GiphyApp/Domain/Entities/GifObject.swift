import Foundation

struct Pagination:Equatable {
    let count     : Int?
    let offset    :Int?
    let total_count: Int?
}
struct Meta:Equatable {
    let status : Int?
    let msg    : String?
}
struct Image : Equatable {
    let url    : URL?
    let width  : String?
    let height : String?
}

struct Images  : Equatable {
    let fixed_height : Image?
}

struct GifObject : Equatable, Identifiable {
    typealias Identifier = String
    let id         : Identifier
    let title      : String?
    let username   : String?
    let source_tld : String?
    let import_datetime : String?
    let rating     : String?
    let url        : URL?
    let images     : Images?
}

struct GifsPage: Equatable {
    let gif        : [GifObject]
    let pagination :Pagination
    let meta       : Meta
}
