import Foundation
import UIKit

class OnBordingViewController:UIViewController,StoryboardInstantiable,Alertable {
    
    @IBOutlet weak var txtBirthdayPicker: UITextField!
    @IBOutlet weak var txtlanguagePicker: UITextField!
    
    let thePicker = UIPickerView()
    
    private var viewModel: OnBordingViewModel!
    
    static func create(with viewModel: OnBordingViewModel) -> OnBordingViewController {
        let view = OnBordingViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        txtBirthdayPicker.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        txtlanguagePicker.inputView = thePicker
        self.bind(to: viewModel)
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        txtBirthdayPicker.text = dateFormatter.string(from: sender.date)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func StartBtnAction(_ sender: Any) {
        if(txtBirthdayPicker.text?.isEmpty ?? false || txtlanguagePicker.text?.isEmpty ?? false) {
            showAlert(title: "Error", message: "Please File Mandatory fields")
            return
        }
        viewModel.didClickStart(date: txtBirthdayPicker.text ?? "", country: txtlanguagePicker.text ?? "")
    }
    
    private func bind(to viewModel: OnBordingViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    private func updateItems() {
        self.thePicker.dataSource = self
        self.thePicker.delegate = self
        self.thePicker.reloadAllComponents()
    }
    
}

// MARK: - UIPickerView Delegation

extension OnBordingViewController:UIPickerViewDelegate,UIPickerViewDataSource {
   

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.items.value[row].name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtlanguagePicker.text = viewModel.items.value[row].language?.code
    }
}
