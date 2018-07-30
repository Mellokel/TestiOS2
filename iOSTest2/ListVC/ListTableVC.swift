//
//  ListTableVC.swift
//  iOSTest2
//
//  Created by Admin on 22.07.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ListTableVC: UIViewController {
   
    enum enumTypeEmployee: String {
        case Accountant = "Accountant"
        case Manager = "Manager"
        case Worker = "Worker"
       
        
    }
    
    private var groupedEmployees: [String:[Employee]] = [:] {
        didSet {
            employeeTypes = groupedEmployees.keys.sorted()
        }
    }
    private var employeeTypes:[String] = []
    private let listCoreData = ListCoreData()
    private let cellIdentifire = "cell"
    private let cellSegueIdentifire = "EditEmloyee"
    
    private let timeManager = ListTimeManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {
        listCoreData.sortEmployees()
        groupedEmployees = listCoreData.getGroupedEmployes()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupedEmployees = listCoreData.getGroupedEmployes()
        tableView.reloadData()
    }
    
    
    
   
    
    // переход
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cellSegueIdentifire, let destination = segue.destination as? EditListVC {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let sectiion = groupedEmployees[employeeTypes[indexPath.section]] else { return }
            destination.employee = sectiion[indexPath.row]
        }
    }
    
}

extension ListTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (groupedEmployees[employeeTypes[section]]?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedEmployees.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire)
        cell?.textLabel?.numberOfLines = 0
        if let section = groupedEmployees[employeeTypes[indexPath.section]] { // вынести?
            let employee = section[indexPath.row]
            let stringValue = """
            Full Name - \(String(describing: employee.fullName!))\n
            Salary - \(String(employee.salary))\n
            """
            switch employee.type! {
            case enumTypeEmployee.Accountant.rawValue:
                let info = employee.info as! Accountant
                cell?.textLabel?.text = stringValue + """
                Work Place - \(String(describing: info.workPlace))
                Lunch Time - \(timeManager.getTime(timeIntervalFrom: info.lunchTimeFrom,
                                                    timeIntervalTo: info.lunchTimeTo))
                Type - \(String(describing: info.type!))
                """
                break
            case enumTypeEmployee.Worker.rawValue:
                let info = employee.info as! Worker
                cell?.textLabel?.text = stringValue + """
                Work Place- \(String(describing: info.workPlace))
                Lunch Time - \(timeManager.getTime(timeIntervalFrom: info.lunchTimeFrom,
                                                    timeIntervalTo: info.lunchTimeTo))
                """
                break
            case enumTypeEmployee.Manager.rawValue:
                let info = employee.info as! Manager
                cell?.textLabel?.text = stringValue + """
                Lunch Time - \(timeManager.getTime(timeIntervalFrom: info.businessTimeFrom,
                                                    timeIntervalTo: info.businessTimeTo))
                """
                break
            default:
                break
            }
        }
        
        return cell!
    }
    
    //MARK: - Edit in table(move, delete)
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section { // перенос только в пределах секции
            tableView.reloadData()
            return
        }
        guard let section = groupedEmployees[employeeTypes[sourceIndexPath.section]] else { return }
        let destinationOrder = Int32(section[destinationIndexPath.row].order)
        listCoreData.replace(employee: section[sourceIndexPath.row], toOrder: destinationOrder)
        groupedEmployees = listCoreData.getGroupedEmployes()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let sectiion = groupedEmployees[employeeTypes[indexPath.section]] else { return }
            listCoreData.deleteEmployee(employee: sectiion[indexPath.row])
            groupedEmployees = listCoreData.getGroupedEmployes()
            tableView.reloadData()
        }
    }
}

extension ListTableVC : UITableViewDelegate{
    //MARK: section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let image = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        image.backgroundColor = .white
        view.addSubview(image)
        
        let label = UILabel(frame: CGRect(x: 50, y: 5, width: Int(tableView.frame.width) - 55, height: 40))
        label.text = employeeTypes[section]
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}


