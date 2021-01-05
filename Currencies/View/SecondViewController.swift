//
//  secondViewController.swift
//  Currencies
//
//  Created by Anton Levin on 27.11.2020.
//

import UIKit

final class SecondViewController: UIViewController {
    
    @IBOutlet var lable: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var currency: [Currency] = []
    
    let pickerView = UIPickerView()
    var actualCurrancy: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        do {
            let course = try UserDefaultsStorage.fetchObjectWith([Currency].self, key: "course")
            guard
                let usd = course?.first(where: { $0.txt == "Долар США"}),
                let eur = course?.first(where: { $0.txt == "Євро"})
            else { return }
            currency.append(usd)
            currency.append(eur)
            debugPrint("course: \(currency)")
        } catch {
            debugPrint("error fetch course")
        }
        
        createPickerView()
    }
    
    @IBAction func fromButton(_ sender: Any) {
        guard let text = textField.text,
              text != "",
              let currency = actualCurrancy,
              let numberedText = Double(text) else { return }
        let value = numberedText / currency
        lable.text = "\((value*100).rounded()/100)"
    }
    
    @IBAction func toButton(_ sender: AnyObject) {
        guard let text = textField.text,
              text != "",
              let currency = actualCurrancy,
              let numberedText = Double(text) else { return }
        let value = numberedText * currency
        lable.text = "\((value*100).rounded()/100)"
    }
    
    private func createPickerView() {
        pickerView.center = view.center
        pickerView.delegate = self
        pickerView.dataSource = self
        actualCurrancy = currency[0].rate
        view.addSubview(pickerView)
    }
}

extension SecondViewController: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row].cc
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        actualCurrancy = currency[row].rate
        print(currency[row].rate)
        return
    }
    
}
