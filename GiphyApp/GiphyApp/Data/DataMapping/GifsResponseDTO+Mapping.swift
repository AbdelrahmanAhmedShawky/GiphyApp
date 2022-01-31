import Foundation
// MARK: - Data Transfer Object

struct GifsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case pagination
        case meta
        case gifs = "data"
    }
    let pagination: PaginationDTO
    let meta: MetaDTO
    let gifs: [GifDTO]
}

extension GifsResponseDTO {
    struct GifDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case username
            case import_datetime
            case source_tld
            case rating
            case url
            case images
        }
        let id: String
        let title: String?
        let username: String?
        let import_datetime:String?
        let source_tld: String?
        let rating: String?
        let url: URL?
        let images: ImagesDTO?
    }
}

extension GifsResponseDTO {
    struct ImagesDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case fixed_height
        }
        let fixed_height : ImageDTO?
    }
}
extension GifsResponseDTO {
    struct ImageDTO :Decodable {
        private enum CodingKeys: String, CodingKey {
            case url
            case width
            case height
        }
        let url    : URL?
        let width  : String?
        let height : String?
    }
}

extension GifsResponseDTO {
    struct MetaDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case status
            case msg
        }
        let status : Int?
        let msg : String?
    }
}

extension GifsResponseDTO {
    struct PaginationDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case count
            case offset
            case total_count
        }
            let count     : Int?
            let offset    :Int?
            let total_count: Int?
    }
}

// MARK: - Mappings to Domain

extension GifsResponseDTO {
    func toDomain() -> GifsPage {
        return .init(gif: gifs.map{ $0.toDomain() }, pagination: pagination.toDomain(), meta: meta.toDomain())
    }
}

extension GifsResponseDTO.GifDTO {
    func toDomain() -> GifObject {
        return .init(id: GifObject.Identifier(id),
                     title: title,
                     username:username,
                     source_tld: source_tld,
                     import_datetime:import_datetime,
                     rating: rating,
                     url: url,
                     images: images?.toDomain())
    }
}

extension GifsResponseDTO.ImagesDTO {
    func toDomain() -> Images {
        return .init(fixed_height: fixed_height?.toDomain())
    }
}
extension GifsResponseDTO.ImageDTO {
    func toDomain() -> Image {
        return .init(url: url, width: width, height: height)
    }
}
extension GifsResponseDTO.PaginationDTO {
    func toDomain() -> Pagination {
        return .init(count: count, offset: offset, total_count: total_count)
    }
}
extension GifsResponseDTO.MetaDTO {
    func toDomain() -> Meta {
        return .init(status: status, msg: msg)
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
