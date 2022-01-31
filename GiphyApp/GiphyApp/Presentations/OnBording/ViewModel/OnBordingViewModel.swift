import Foundation

struct OnBordingActions {
    let showGifList: () -> Void
}

protocol OnBordingViewModelInput {
    func didClickStart(date: String,country:String)
}

protocol OnBordingViewModelOutput {
    var items: Observable<[Country]> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var errorTitle: String { get }
}

protocol OnBordingViewModel: OnBordingViewModelInput, OnBordingViewModelOutput { }

class DefaultOnBordingViewModel:OnBordingViewModel {
    
    var items: Observable<[Country]> = Observable([])
    
    var error: Observable<String> = Observable("")
    
    var isEmpty: Bool { return items.value.isEmpty }
    
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    private let actions: OnBordingActions?
    private let fetchingLanguageListUseCase: FetchingLanguageListUseCase
    init(actions: OnBordingActions? = nil,fetchingLanguageListUseCase:FetchingLanguageListUseCase) {
        self.actions = actions
        self.fetchingLanguageListUseCase = fetchingLanguageListUseCase
        self.fetchLanguage()
    }
    
    func didClickStart(date: String, country: String) {
        let defaults = UserDefaults.standard
        let age = calcAge(birthday: date)
        if(age > 18) {
            defaults.set("pg", forKey: "rating")
        }else {
            defaults.set("g", forKey: "rating")
        }
        defaults.set(country, forKey: "lang")
        if (!(defaults.string(forKey: "rating")?.isEmpty ?? false)  && !(defaults.string(forKey: "lang")?.isEmpty ?? false)) {
            actions?.showGifList()
        }
    }
    
    private func fetchLanguage() {
        fetchingLanguageListUseCase.languageListExecute  {[weak self] result in
            switch result {
            case .success(let language):
                self?.items.value = language.countries ?? []
            case .failure(let error):
                self?.handle(error: error)
            }
    }
    }
    
    
    private func handle(error: Error) {
        self.error.value = NSLocalizedString("Failed loading Language", comment: "")
    }
    
    private func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMM yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
}
