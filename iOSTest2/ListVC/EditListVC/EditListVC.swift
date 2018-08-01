import UIKit

class EditListVC: UIViewController {
    
    let typeEmployeeManager = TypeEmployeeManager()
    
    var pickerValues:[TypeEmployeeManager.TypeEmployee] = []
    
    let accountantValues = ["Payroll","Material Accounting"]
    private let coreData = ListCoreData()
    
    var employee: Employee?
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var accountantTypePicker: UIPickerView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var workPlace: UITextField!
    
    @IBOutlet weak var lunchOrBusinessTimePickerFrom: UIDatePicker!
    @IBOutlet weak var lunchOrBusinessTimePickerTo: UIDatePicker!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerValues = typeEmployeeManager.getTypesAsArray()
        setValues()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonAction))
    }
    
    @objc fileprivate func saveButtonAction() {
        
        if employee != nil {
            coreData.deleteEmployee(employee: employee!)
        }
        
        guard let salary = Double(salary.text!) else { return }
        guard let fullName = fullName.text else { return }
        let timeFrom = lunchOrBusinessTimePickerFrom.date.timeIntervalSince1970
        let timeTo = lunchOrBusinessTimePickerTo.date.timeIntervalSince1970
        
        let employeeInfo = EmployeeInfo(fullName: fullName, salary: salary)
        
        let type = pickerValues[typePicker.selectedRow(inComponent: 0)]
        switch type {
        case .Accountant:
            guard let place = Int32(workPlace.text!) else { return }
            let info = AccountantInfo(type: accountantValues[typePicker.selectedRow(inComponent: 0)], workPlace: place, luchTimeFrom: timeFrom, luchTimeTo: timeTo)
            coreData.addAccountant(employeeInfo: employeeInfo, accountantInfo: info)
            break
        case .Manager:
            let info = ManagerInfo(businessTimeFrom: timeFrom, businessTimeTo: timeTo)
            coreData.addManager(employeeInfo: employeeInfo, accountantInfo: info)
            break
        case .Worker:
            guard let place = Int32(workPlace.text!) else { return }
            let info = WorkerInfo(workPlace: place, luchTimeFrom: timeFrom, luchTimeTo: timeTo)
            coreData.addWorker(employeeInfo: employeeInfo, accountantInfo: info)
            break
        }
        // уведомление о сохранении/ошибке
    }
    
    func setValues() {
        guard let unwwappedEmployee = employee else { return }
        guard let typeStr = unwwappedEmployee.type,
            let type = typeEmployeeManager.getTypeFor(rawValue: typeStr),
            let index = pickerValues.index(of: type) else { return }
        
        
        typePicker.selectRow(index, inComponent: 0, animated: true)
        fullName.text = unwwappedEmployee.fullName!
        salary.text = String(describing: unwwappedEmployee.salary)
        
        switch type {
        case .Accountant:
            let info = unwwappedEmployee.info as! Accountant
            workPlace.text = String(info.workPlace)
           
            lunchOrBusinessTimePickerFrom.date = Date(timeIntervalSince1970: info.lunchTimeFrom)
            lunchOrBusinessTimePickerTo.date = Date(timeIntervalSince1970: info.lunchTimeTo)
            if let typeAccountant = info.type {
                typePicker.selectRow(accountantValues.index(of: typeAccountant)!, inComponent: 0, animated: true)
            }
            break
        case .Manager:
            let info = unwwappedEmployee.info as! Manager
            
            lunchOrBusinessTimePickerFrom.date = Date(timeIntervalSince1970: info.businessTimeFrom)
            lunchOrBusinessTimePickerTo.date = Date(timeIntervalSince1970: info.businessTimeTo)
            break
        case .Worker:
            let info = unwwappedEmployee.info as! Worker
            workPlace.text = String(info.workPlace)
            
            lunchOrBusinessTimePickerFrom.date = Date(timeIntervalSince1970: info.lunchTimeFrom)
            lunchOrBusinessTimePickerTo.date = Date(timeIntervalSince1970: info.lunchTimeTo)
            break
        }
    }
    
    // обработка клавиатуры
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            view.addGestureRecognizer(keyboardDismissTapGesture!)
            typePicker.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
 
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if keyboardDismissTapGesture != nil {
            view.removeGestureRecognizer(keyboardDismissTapGesture!)
            typePicker.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
}
