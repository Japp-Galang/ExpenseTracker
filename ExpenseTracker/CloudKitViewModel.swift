//
//  CloudKitViewModel.swift
//  BudgetTracker
//
//  Created by Japp Galang on 12/17/22.
//

import Foundation
import CloudKit

class CloudKitViewModel: ObservableObject{
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    
    @Published var expenseNameText: String = ""
    @Published var dateBought = Date()
    @Published var expenseCostValue: Double? = nil
    @Published var selection = "Genre Select"
    @Published var expenses: [[String]] = []
    @Published var monthlyTotalCosts: [MonthlyExpense] = []
    
    init(){
        fetchItems()
    }
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in DispatchQueue.main.async{
            switch returnedStatus{
            case .available:
                self?.isSignedInToiCloud = true
            case .noAccount:
                self?.error = CloudKitError.iCloudAccountNotFound.rawValue
            case .couldNotDetermine:
                self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
            case .restricted:
                self?.error = CloudKitError.iCloudAccountRestricted.rawValue
            default:
                self?.error = CloudKitError.iCloudAccountUnknown.rawValue
            }
            }
        }
    }
    
    enum CloudKitError: String, LocalizedError{
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func saveFormPressed(){
        guard !expenseNameText.isEmpty else {return}
        guard !(expenseCostValue == nil) else {return}
        guard !(selection == "Genre Select") else {return}
        
        addItem(name: expenseNameText, date: dateBought, expenseCost: expenseCostValue)
    }
    
    private func addItem(name: String, date: Date, expenseCost: Double?){
        let newExpense = CKRecord(recordType: "Expense")
        newExpense["Name"] = name
        newExpense["ExpenseCost"] = expenseCostValue
        newExpense["Date"] = date
        newExpense["Genre"] = selection
        
        saveItem(record: newExpense)
    }
    
    private func saveItem(record: CKRecord){
        CKContainer.default().privateCloudDatabase.save(record) {[weak self] returnedRecord, returnedError in
            print("Record: " + String(describing:returnedRecord))
            print("Error: " + String(describing:returnedError))
            
            // resets the form(empty fields)
            DispatchQueue.main.async{
                self?.expenseNameText       = ""
                self?.expenseCostValue      = nil               //doesn't work
                self?.selection             = "Genre Select"
            }
        }
    }
    
    func fetchItems(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Expense", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "Date", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedItems: [[String]] = []
        
        //Key data points to return
        var monthlyTotalCostsTemp: [MonthlyExpense] = []
        var temp: Double = 0
        var monthlyCounter: String = "0000-01"
        
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
                case .success(let record):
                    guard let nameFetch = record["Name"] as? String else { return }
                    
                    guard var expenseCostFetch = "\(record["ExpenseCost"])" as? String else { return }
                    expenseCostFetch = takeSubstring(word: expenseCostFetch, beginning: 9, end: -1)
                    
                    guard var expenseDateFetch = "\(record["Date"])" as? String else { return }
                    expenseDateFetch = takeSubstring(word: expenseDateFetch, beginning: 9, end: -16)
                    var currentMonthIteration = takeSubstring(word: expenseDateFetch, beginning: 0, end: -3)
                    
                    guard let genreFetch = record["Genre"] as? String else { return }
        
                    let addThis: [String] = [nameFetch, expenseCostFetch, expenseDateFetch, genreFetch]
                    returnedItems.append(addThis)
                    
                    //handling key data points
                    if(monthlyCounter != currentMonthIteration){
                        let tempMonthlyExpense = MonthlyExpense(totalCosts: temp, monthAndYear: monthlyCounter)
                        monthlyTotalCostsTemp.append(tempMonthlyExpense)
                        monthlyCounter = currentMonthIteration
                        temp = 0
                        
                    }
                    temp += Double(expenseCostFetch) ?? 0
                
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
            }
            let monthlyExpenseFinalMonth = MonthlyExpense(totalCosts: temp, monthAndYear: monthlyCounter)
            monthlyTotalCostsTemp.append(monthlyExpenseFinalMonth)
            monthlyTotalCostsTemp.removeFirst()
        }
        
        
        queryOperation.queryResultBlock = {[weak self] returnedResult in
            print("RETURNED RESULT: \(returnedResult)")
            returnedItems = returnedItems.reversed() //This is so that the ShowExpensesView shows the expenses from the latest to oldest
            self?.expenses = returnedItems
            self?.monthlyTotalCosts = monthlyTotalCostsTemp
            for i in monthlyTotalCostsTemp {
                print(i.monthAndYear)
            }
            
        }
        addOperations(operation: queryOperation)
        
    }
    
    func addOperations(operation: CKDatabaseOperation) {
        CKContainer.default().privateCloudDatabase.add(operation)
    }
}


/*
 Function to return a substring given the beginning index and end index (end index coming from the end)
 */
func takeSubstring(word: String, beginning: Int, end:Int) -> String{
    let start0 = word.index(word.startIndex, offsetBy: beginning)
    let end0 = word.index(word.endIndex, offsetBy: end)
    let range0 = start0..<end0
    
    return String(word[range0])
}


struct MonthlyExpense: Identifiable {
    let id = UUID()
    let totalCosts: Double
    let monthAndYear: String
    
}

