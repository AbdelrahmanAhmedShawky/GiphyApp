import Foundation

protocol GifDetailsViewModelInput {
//    func updatePosterImage(width: Int)
}

protocol GifDetailsViewModelOutput {
    var gif: GifObject { get }
}

protocol GifDetailsViewModel: GifDetailsViewModelInput, GifDetailsViewModelOutput { }

final class DefaultGifDetailsViewModel: GifDetailsViewModel {
  
    // MARK: - OUTPUT
    var gif: GifObject
    
    init(gif: GifObject) {
        self.gif = gif
    }
}

// MARK: - INPUT. View event methods
extension DefaultGifDetailsViewModel {
    
}
