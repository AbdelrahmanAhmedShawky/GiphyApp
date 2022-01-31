import Foundation
import RealmSwift
import UIKit

// MARK: - Element
final class GifSaveModel: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var imageData: NSData = NSData()
}

//MARK: - Aciton
extension GifSaveModel {
    static func getGifs() -> [GifSaveModel] {
        var all: [GifSaveModel] = []
        do{
            let realm = try Realm()
            try realm.write {
                all = Array(realm.objects(GifSaveModel.self))
            }
        }catch {
            print("Error in access list of addresses")
        }
        return all
    }
    
    static func clearAll() {
        let realm = try! Realm()
        try! realm.write {
            let gifs = realm.objects(GifSaveModel.self)
            
            realm.delete(gifs)
        }
    }
    
    static func getSavedGifs() -> [GifSaveModel]? {
        return Array(GifSaveModel.getGifs())
    }
    
    static func saveGif(_ item: GifObject) {
        let selectedGif = GifSaveModel()
         selectedGif.title = item.title ?? ""
         selectedGif.imageURL = item.images?.fixed_height?.url?.absoluteString ?? ""
        if let imageURL = UIImage.gifImageWithURL(item.images?.fixed_height?.url?.absoluteString ?? "") {
            let data = NSData(data: imageURL.jpegData(compressionQuality: 0.9)!)
            selectedGif.imageData = data
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(selectedGif)
        }
    }
    
}

