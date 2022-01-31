import Foundation

protocol GifDetailsViewModelInput {
    func didSelectItem()
}

protocol GifDetailsViewModelOutput {
    var gif: GifObject { get }
    var getSaveItem: [GifSaveModel] { get }
}

protocol GifDetailsViewModel: GifDetailsViewModelInput, GifDetailsViewModelOutput { }

final class DefaultGifDetailsViewModel: GifDetailsViewModel {
    
    // MARK: - OUTPUT
    var gif: GifObject
    var getSaveItem:[GifSaveModel] = GifSaveModel.getSavedGifs() ?? []
    
    init(gif: GifObject) {
        self.gif = gif
    }
    
}

// MARK: - INPUT. View event methods
extension DefaultGifDetailsViewModel {
    func didSelectItem() {
        GifSaveModel.saveGif(self.gif)
    }
}
