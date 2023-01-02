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
    @Published var monthlyDataPoints: [MonthlyData] = []
    

    
    init(){
        fetchItems()
        fillImportantData()
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
    
//--------------------------------//
    func fetchItems(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Expense", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "Date", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedItems: [[String]] = []
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
                case .success(let record):
                    
                    guard let nameFetch = record["Name"] as? String else { return }
                    
                    guard var expenseCostFetch = "\(record["ExpenseCost"])" as? String else { return }
                    expenseCostFetch = takeSubstring(word: expenseCostFetch, beginning: 9, end: -1)
                    
                    guard var expenseDateFetch = "\(record["Date"])" as? String else { return }
                    expenseDateFetch = takeSubstring(word: expenseDateFetch, beginning: 9, end: -16)
                    
                
                    guard let genreFetch = record["Genre"] as? String else { return }
        
                    let addThis: [String] = [nameFetch, expenseCostFetch, expenseDateFetch, genreFetch]
                    returnedItems.append(addThis)
                
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
            }
            
        }
        
        
        queryOperation.queryResultBlock = {[weak self] returnedResult in
            //print("RETURNED RESULT: \(returnedResult)")
            returnedItems = returnedItems.reversed() //This is so that the ShowExpensesView shows the expenses from the latest to oldest
            self?.expenses = returnedItems
        }
        addOperations(operation: queryOperation)
        
    }
    
    func addOperations(operation: CKDatabaseOperation) {
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    
//--------------------------------//
    func fillImportantData(){
        var importantDataPoints: [String:MonthlyData] = [:]
        
        let calendar = Calendar.current
        
        // Get the current date and month
        var firstOfThisMonthComponents = calendar.dateComponents([.year, .month], from: Date())
        firstOfThisMonthComponents.day = 1                                                         // Set the first day of the current month

        // Get the date for the first day of the current month
        let firstOfMonth = calendar.date(from: firstOfThisMonthComponents)!
        let firstOfMonthNMonthsAgo = calendar.date(byAdding: .month, value: -12, to: firstOfMonth)
        let firstOfMonthNMonthsAgoNSDate = firstOfMonthNMonthsAgo as! NSDate
    
        // get the last day of current month
        var lastofMonthComponents = calendar.dateComponents([.year, .month], from: Date())          // Get the current date and month
        lastofMonthComponents.day = calendar.range(of: .day, in: .month, for: Date())!.count        // Set the day to the last day of the month
        let lastOfMonth = calendar.date(from: lastofMonthComponents)!                               // Get the date for the last day of the current month
        let lastOfMonthNSDate = lastOfMonth as NSDate
        
        //Querying the data to get data points of the last n months
        let predicate = NSPredicate(format: "Date > %@ AND Date < %@", firstOfMonthNMonthsAgoNSDate, lastOfMonthNSDate)
        let query = CKQuery(recordType: "Expense", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
    //----------------------------------------
        //Prefill output with the needed YYYY-MM
        let calendar2 = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"

        let startDate = Date()
        let endDate = calendar2.date(byAdding: .year, value: 1, to: startDate)!

        var date = startDate
        while date <= endDate {
            let month = dateFormatter.string(from: date)
            print(month)
            date = calendar.date(byAdding: .month, value: 1, to: date)!
        }
    //----------------------------------------
        
        queryOperation.recordFetchedBlock = { (record) in
            print(record)
        }
        addOperations(operation: queryOperation)
        
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



struct MonthlyData: Identifiable {
    let id = UUID()
    var totalCosts: Double
    var categoryTransportation: Double
    var categoryRestaurant: Double
    var categoryClothes: Double
    var categoryEntertainment: Double
    var categoryGroceries: Double
}

