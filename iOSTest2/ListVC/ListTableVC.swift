//
//  ListTableVC.swift
//  iOSTest2
//
//  Created by Admin on 22.07.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ListTableVC: UITableViewController {
    
    private var groupedEmployees: [String:[Employee]] = [:] {
        didSet {
            employeeTypes = groupedEmployees.keys.sorted()
        }
    }
    private var employeeTypes:[String] = []
    private let listCoreData = ListCoreData()
    private let cellIdentifire = "cell"
    private let cellSegueIdentifire = "EditEmloyee"
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire)
        cell?.textLabel?.numberOfLines = 0
        if let section = groupedEmployees[employeeTypes[indexPath.section]] { // вынести?
            let employee = section[indexPath.row]
            let stringValue = """
            Full Name - \(String(describing: employee.fullName!))\n
            Salary - \(String(employee.salary))\n
            """
            switch employee.type! {
            case "Accourant":
                let info = employee.info as! Accourant
                cell?.textLabel?.text = stringValue + """
                Work Place - \(String(describing: info.workPlace))
                Lunch Time - \(String(describing: info.lunchTime!))
                Type - \(String(describing: info.type!))
                """
                break
            case "Worker":
                let info = employee.info as! Worker
                cell?.textLabel?.text = stringValue + """
                Work Place- \(String(describing: info.workPlace))
                Lunch Time - \(String(describing: info.lunchTime!))
                """
                break
            case "Manager":
                let info = employee.info as! Manager
                cell?.textLabel?.text = stringValue + """
                Lunch Time - \(String(describing: info.businessTime!))
                """
                break
            default:
                break
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (groupedEmployees[employeeTypes[section]]?.count)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedEmployees.count
    }
    //MARK: section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //view.backgroundColor = .black
        let image = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        image.backgroundColor = .white
        view.addSubview(image)
        
        let label = UILabel(frame: CGRect(x: 50, y: 5, width: Int(tableView.frame.width) - 55, height: 40))
        label.text = employeeTypes[section]
        view.addSubview(label)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //MARK: - Edit in table(move, delete)
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let section = groupedEmployees[employeeTypes[sourceIndexPath.section]] else { return }
        let destinationOrder = Int32(section[destinationIndexPath.row].order)
        listCoreData.replace(employee: section[sourceIndexPath.row], toOrder: destinationOrder)
        groupedEmployees = listCoreData.getGroupedEmployes()
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let sectiion = groupedEmployees[employeeTypes[indexPath.section]] else { return }
            listCoreData.deleteEmployee(employee: sectiion[indexPath.row])
            groupedEmployees = listCoreData.getGroupedEmployes()
            tableView.reloadData()
        }
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

// запретить перенос в другую секции вручную 
