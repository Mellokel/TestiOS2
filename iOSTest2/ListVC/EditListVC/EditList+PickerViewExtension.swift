import UIKit

extension EditListVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePicker {
            return pickerValues.count
        } else {
            return accountantValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            return pickerValues[row]
        } else {
            return accountantValues[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerValues[typePicker.selectedRow(inComponent: 0)] {
        case "Accountant":
            accountantTypePicker.isHidden = false
            workPlace.isEnabled = true
            break
        case "Manager":
            accountantTypePicker.isHidden = true
            workPlace.isEnabled = false
            break
        case "Worker":
            accountantTypePicker.isHidden = true
            workPlace.isEnabled = true
            break
        default:
            break
        }
    }
}
