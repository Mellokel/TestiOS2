import CoreData
import UIKit

class ListCoreData {
    
    private let employeeTypes = ["Accountant", "Manager", "Worker"]
    
    private func getContext () -> NSManagedObjectContext {
        let mainCD = MainCoreData()
        return mainCD.persistentContainer.viewContext
    }
    
    private func saveContext() {
        do {
            try getContext().save()
        } catch {
            print("can't save")
        }
    }
    
    func getEmployees(closure: ((_ fetchRequest: NSFetchRequest<NSFetchRequestResult>)->Void)?) -> [Employee] {
        let context = getContext()
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        let sortOrder = NSSortDescriptor(key: "order", ascending: true)
        fetchedRequest.sortDescriptors = [sortOrder]
        if closure != nil {
            closure!(fetchedRequest)
        }
        do {
            return try context.fetch(fetchedRequest) as! [Employee]
        } catch {
            return []
        }
    }
    // группировка по типу сотрудников
    func getGroupedEmployes() -> [String:[Employee]] {
        var gropedEmployees: [String:[Employee]] = [:]
        for type in employeeTypes {
            let employees = getEmployees { (fetchReq) in
                let predicate = NSPredicate(format: "type == %@", type)
                fetchReq.predicate = predicate
            }
            gropedEmployees[type] = employees
        }
        return gropedEmployees
    }
    //добавление сотрудников
    func createEmployee(employeeInfo: EmployeeInfo) -> Employee {
        let context = getContext()
        let newEmployee = Employee(context: context)
        newEmployee.fullName = employeeInfo.fullName
        newEmployee.salary = employeeInfo.salary
        newEmployee.order = getMaxOrder()
        return newEmployee
    }
    
    
    func addAccountant(employeeInfo main: EmployeeInfo, accountantInfo accountant: AccountantInfo) {
        let newEmployee = createEmployee(employeeInfo: main)
        newEmployee.type = employeeTypes[0]//"Accountant"
        
        let context = getContext()
        let info = Accountant(context: context)
        info.lunchTimeFrom = accountant.luchTimeFrom
        info.lunchTimeTo = accountant.luchTimeTo
        info.type = accountant.type
        info.workPlace = accountant.workPlace
        newEmployee.info = info
        saveContext()
    }
    
    func addManager(employeeInfo main: EmployeeInfo, accountantInfo manager: ManagerInfo) {
        let currentEmployee = createEmployee(employeeInfo: main)
        currentEmployee.type = employeeTypes[1]//"Manager"
        
        let context = getContext()
        let info = Manager(context: context)
        info.businessTimeFrom = manager.businessTimeFrom
        info.businessTimeTo = manager.businessTimeTo
        currentEmployee.info = info
        saveContext()
    }
    
    func addWorker(employeeInfo main: EmployeeInfo, accountantInfo worker: WorkerInfo) {
        let newEmployee = createEmployee(employeeInfo: main)
        newEmployee.type = employeeTypes[2]//"Worker"
        
        let context = getContext()
        let info = Worker(context: context)
        info.lunchTimeFrom = worker.luchTimeFrom
        info.lunchTimeTo = worker.luchTimeTo
        info.workPlace = worker.workPlace
        newEmployee.info = info
        saveContext()
    }
    
    func getMaxOrder() -> Int32 {
        let employeeWithMaxOrder = getEmployees { (fetchReq) in
            let sortOrder = NSSortDescriptor(key: "order", ascending: false)
            fetchReq.sortDescriptors = [sortOrder]
            fetchReq.fetchLimit = 1
        }
        return employeeWithMaxOrder.isEmpty ? 0 : employeeWithMaxOrder[0].order + 1
    }
    
    
    
    func deleteEmployee(employee: Employee) {
        let context = getContext()
        context.delete(employee)
        saveContext()
    }
    
    //смещение с текущего номера на другой
    func replace(employee: Employee,toOrder to: Int32 ) {
        let from = employee.order
        let employees = getEmployees(closure: nil)
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
        let employees = getEmployees { (fetchRequest) in
            let sort = NSSortDescriptor(key: "fullName", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            fetchRequest.sortDescriptors = [sort]
        }
        for (index,element) in employees.enumerated() {
            element.order = Int32(index)
        }
        saveContext()
    }
    
    
    
    
}
