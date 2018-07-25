import CoreData
import UIKit

class ListCoreData {
    
    private let entityName = "Employee"
    
    private func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveContext() {
        do {
            try getContext().save()
        } catch {
            print("can't save")
        }
    }
    
    func getEmployees() -> [Employee] {
        let context = getContext()
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            var employeeFetch = try context.fetch(fetchedRequest) as! [Employee]
            employeeFetch.sort(by: { (first, second) -> Bool in
                return first.order < second.order
            })
            return employeeFetch
        } catch {
            return []
        }
    }
    // группировка по типу сотрудников
    func getGroupedEmployes() -> [String:[Employee]] {
        let employees = getEmployees()
        var gropedEmployees: [String:[Employee]] = [:]
        employees.forEach { (element) in
            if gropedEmployees[element.type!] != nil {
                gropedEmployees[element.type!]?.append(element)
            } else {
                gropedEmployees.updateValue([element], forKey: element.type!)
            }
        }
        return gropedEmployees
    }
    
    
    func addAccourant(fullName: String, salary: Double, luchTimeFrom timeFrom: String, luchTimeTo timeTo: String , workPlace: Double, type: String ) {
        let context = getContext() // попробовать сократить повторяющееся
        
        let currentEmployee = Employee(context: context)
        currentEmployee.fullName = fullName
        currentEmployee.salary = salary
        currentEmployee.order = Int32(getEmployees().count)
        currentEmployee.type = "Accourant"
        
        let info = Accourant(context: context)
        info.lunchTime = "from \(timeFrom) - to \(timeTo)"
        info.type = type
        info.workPlace = workPlace
        currentEmployee.info = info
        saveContext()
    }
    func addWorker(fullName: String, salary: Double, luchTimeFrom timeFrom: String, luchTimeTo timeTo: String, workPlace: Double) {
        let context = getContext()
        
        let currentEmployee = Employee(context: context)
        currentEmployee.fullName = fullName
        currentEmployee.salary = salary
        currentEmployee.order = Int32(getEmployees().count)
        currentEmployee.type = "Worker"
        let info = Worker(context: context)
        info.lunchTime = "from \(timeFrom) - to \(timeTo)"
        info.workPlace = workPlace
        currentEmployee.info = info
        
        saveContext()
    }
    func addManager(fullName: String, salary: Double, BusinessTimeFrom timeFrom: String, BusinessTimeTo timeTo: String) {
        let context = getContext()
        
        let currentEmployee = Employee(context: context)
        currentEmployee.fullName = fullName
        currentEmployee.salary = salary
        currentEmployee.order = Int32(getEmployees().count)
       
        currentEmployee.type = "Manager"
        let info = Manager(context: context)
        info.businessTime = "from \(timeFrom) - to \(timeTo)"
        currentEmployee.info = info
        
        
        saveContext()
    }
    
    func deleteEmployee(employee: Employee) {
        let employees = getEmployees()
        employees.forEach { (element) in
            if element.order > employee.order {
                element.order -= 1
            }
        }
        let context = getContext()
        context.delete(employee)
        saveContext()
    }
    
    //смещение с текущего номера на другой
    func replace(employee: Employee,toOrder to: Int32 ) {
        let from = employee.order
        
        let employees = getEmployees()
        employees.forEach { (element) in
            if element.order > from && element.order <= to && to > from {
                element.order -= 1
            } else {
                if element.order < from && element.order >= to && to < from {
                    element.order += 1
                }
            }
        }
        employee.order = to
        saveContext()
    }
    
    
    //сортировка по алфавиту
    func sortEmployees() {
        var employees:[Employee] = getEmployees()
        employees.sort { (first, second) -> Bool in
            return first.fullName! < second.fullName!
        }
        for (index,element) in employees.enumerated() {
            element.order = Int32(index)
        }
        saveContext()
    }
    
    
    
    
}
