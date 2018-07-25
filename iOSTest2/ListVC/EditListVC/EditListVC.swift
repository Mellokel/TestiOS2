import UIKit

class EditListVC: UIViewController {
    
    let pickerValues = ["Accourant","Manager","Worker"]
    let accourantValues = ["Payroll","Material Accounting"]
    private let coreData = ListCoreData()
    
    var employee: Employee?
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var accourantTypePicker: UIPickerView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var workPlace: UITextField!
    
    @IBOutlet weak var lunchOrBusinessTimePickerFrom: UIDatePicker!
    @IBOutlet weak var lunchOrBusinessTimePickerTo: UIDatePicker!
   
    
    
    override func viewDidLoad() {
        setValues()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonAction))
    }
    
    @objc fileprivate func saveButtonAction() {
        
        if employee != nil {
            coreData.deleteEmployee(employee: employee!)
        }
        
        guard let salary = Double(salary.text!) else { return }
        let timeFrom = getHourFromDatePicker(datePicker: lunchOrBusinessTimePickerFrom)
        let timeTo = getHourFromDatePicker(datePicker: lunchOrBusinessTimePickerTo)
        
        switch pickerValues[typePicker.selectedRow(inComponent: 0)] {
        case "Accourant":
            guard let place = Double(workPlace.text!) else { return }
            coreData.addAccourant(fullName: fullName.text!, salary: salary, luchTimeFrom: timeFrom, luchTimeTo: timeTo, workPlace: place, type: accourantValues[typePicker.selectedRow(inComponent: 0)])
            break
        case "Manager":
            coreData.addManager(fullName: fullName.text!, salary: salary, BusinessTimeFrom: timeFrom, BusinessTimeTo: timeTo)
            break
        case "Worker":
            guard let place = Double(workPlace.text!) else { return }
            coreData.addWorker(fullName: fullName.text!, salary: salary, luchTimeFrom: timeFrom, luchTimeTo: timeTo, workPlace: place)
            break
        default:
            break
        }
        
        // уведомление о сохранении/ошибке
    }
    
    func setValues() {
        guard let unwwappedEmployee = employee else { return }
        guard let type = unwwappedEmployee.type else { return }
        
        typePicker.selectRow(pickerValues.index(of: type)!, inComponent: 0, animated: true)
        fullName.text = unwwappedEmployee.fullName!
        salary.text = String(describing: unwwappedEmployee.salary)
        
        switch type {
        case "Accourant":
            let info = unwwappedEmployee.info as! Accourant
            workPlace.text = String(info.workPlace)
            setTime(fromString: info.lunchTime!)
            if let typeAccourant = info.type {
                typePicker.selectRow(accourantValues.index(of: typeAccourant)!, inComponent: 0, animated: true)
            }
            break
        case "Manager":
            let info = unwwappedEmployee.info as! Manager
            setTime(fromString: info.businessTime!)
            break
        case "Worker":
            let info = unwwappedEmployee.info as! Worker
            workPlace.text = String(info.workPlace)
            setTime(fromString: info.lunchTime!)
            break
        default:
            break
        }
    }
    
    // вынести все в другой класс?
    func setTime(fromString str: String) {
        let splitTime = str.split(separator: " ")
        let splitHM = splitTime[1].split(separator: ":")
        if let h = Int(splitHM[0]), let m = Int(splitHM[1]) {
            setHourToDatePicker(datePicker: lunchOrBusinessTimePickerFrom, hours: h, minutes: m)
            setHourToDatePicker(datePicker: lunchOrBusinessTimePickerTo, hours: h, minutes: m)
        }
    }
    
    func getHourFromDatePicker(datePicker:UIDatePicker) -> String
    {
        let componentHour = NSCalendar.current.component(.hour, from:  datePicker.date)
        let componentMinute = NSCalendar.current.component(.minute, from:  datePicker.date)
        return "\(componentHour):\(componentMinute)"
    }
    func setHourToDatePicker(datePicker:UIDatePicker, hours: Int, minutes: Int)
    {
        let date = NSCalendar.current.date(from: DateComponents(hour: 5, minute: 5))
        datePicker.setDate(date!, animated: true)
    }
}

// убрать клаву
// изменить/доделать время

