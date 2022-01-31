import Foundation

struct APIEndpoints {
    
    static func getTrending(with trendRequestDTO: GifsTrendingRequestDTO) -> Endpoint<GifsResponseDTO> {

        return Endpoint(path: "v1/gifs/trending",
                        method: .get,
                        queryParametersEncodable: trendRequestDTO)
    }
    
    static func getSearching(with searchRequestDTO: GifsSearchingRequestDTO) -> Endpoint<GifsResponseDTO> {

        return Endpoint(path: "v1/gifs/search",
                        method: .get,
                        queryParametersEncodable: searchRequestDTO)
    }
    
}
