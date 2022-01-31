import Foundation

struct GifsListItemViewModel: Equatable {
    let title: String
    let source_tld : String
    let rating     : String
    let url        : URL?
    let images     : Images?
    
}

extension GifsListItemViewModel {

    init(gif: GifObject) {
        self.title = gif.title ?? ""
        self.source_tld = gif.source_tld ?? ""
        self.rating = gif.rating ?? ""
        self.url = gif.url
        self.images = gif.images ?? Images(fixed_height: Image(url: URL(string: ""), width: "480", height: "480"))
        
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
