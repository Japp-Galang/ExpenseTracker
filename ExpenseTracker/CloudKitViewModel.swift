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
    @Published var monthlyDataPoints: [String:MonthlyData] = [:]
    @Published var monthlyDataPointsChart: [MonthlyData] = []

 
    
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
                    
                    var expenseCostFetch = String(describing: record["ExpenseCost"])
                    expenseCostFetch = takeSubstring(word: expenseCostFetch, beginning: 9, end: -1)
                    
                    var expenseDateFetch =  String(describing: record["Date"])
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
            DispatchQueue.main.async{
                self?.expenses = returnedItems
            }
        }
        addOperations(operation: queryOperation)
        
    }
    
    func addOperations(operation: CKDatabaseOperation) {
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    
//--------------------------------//
    /*
     Outputs the data to show. The input format is "mm-yyyy"
     */
    func fillImportantData(beginningMonthAndYear: String, endMonthAndYear: String){
        
        var importantDataPoints: [String:MonthlyData] = [:]                                        //initialize output
        
        let calendar = Calendar.current
        
        //Prepares beginning of query
        var firstOfBeginningMonthAndYear = DateComponents()
        firstOfBeginningMonthAndYear.day = 1                                                         // Set the first day of the current month
        firstOfBeginningMonthAndYear.month = Int(takeSubstring(word: beginningMonthAndYear, beginning: 0, end: -5))
        firstOfBeginningMonthAndYear.year = Int(takeSubstring(word: beginningMonthAndYear, beginning: 3, end: 0))
        
        var beginning = calendar.date(from: firstOfBeginningMonthAndYear)
        let beginningNSDate = beginning! as NSDate
        
        
        
        //Prepares end of query
        var lastOfEndMonthAndYear = DateComponents()
        lastOfEndMonthAndYear.day = 1                                                         // Set the first day of the current month
        lastOfEndMonthAndYear.month = Int(takeSubstring(word: endMonthAndYear, beginning: 0, end: -5))
        lastOfEndMonthAndYear.year = Int(takeSubstring(word: endMonthAndYear, beginning: 3, end: 0))
        
        let end = calendar.date(from: lastOfEndMonthAndYear)
        let endNSDate = end! as NSDate
    
        
        //Querying the data to get data points of the last n months
        let predicate = NSPredicate(format: "Date > %@", beginningNSDate)
        let query = CKQuery(recordType: "Expense", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
    //----------------------------------------
        //Prefill output with the needed MM-YYYY
        let calendar2 = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-YYYY"

        
        
        while beginning! <= end! {
            let monthAndYear = dateFormatter.string(from: beginning!)
            importantDataPoints[monthAndYear] = MonthlyData(monthAndYear: monthAndYear, totalCosts: 0, categoryTransportation: 0, categoryRestaurant: 0, categoryClothes: 0, categoryEntertainment: 0, categoryGroceries: 0, categoryOther: 0)
            beginning = calendar2.date(byAdding: .month, value: 1, to: beginning!)!
            
        }
        
        
    //----------------------------------------
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
                case .success(let record):
                    
                    //gets the month and year of the record in this format: MM-YYYY
                    let expenseDateFetch =  String(describing: record["Date"])
                    let expenseDateYear = takeSubstring(word: expenseDateFetch, beginning: 9, end: -22)
                    let expenseDateMonth = takeSubstring(word: expenseDateFetch, beginning: 14, end: -19)
                    let monthAndYear = expenseDateMonth + "-" + expenseDateYear
                    
                    let expenseCostValue = (record["ExpenseCost"] as? Double) ?? 0
                    
                    guard let genreFetch = record["Genre"] as? String else { return }
                    
                    //Updates the values in importantDataPoints
                
                    
                importantDataPoints[monthAndYear]?.totalCosts += expenseCostValue
                    
                    switch genreFetch {
                        case "Transportation/gas":
                            importantDataPoints[monthAndYear]?.categoryTransportation += expenseCostValue
                        case "Clothes":
                            importantDataPoints[monthAndYear]?.categoryClothes += expenseCostValue
                        case "Entertainment/Leisure":
                            importantDataPoints[monthAndYear]?.categoryEntertainment += expenseCostValue
                        case "Restaurants/Cafe":
                            importantDataPoints[monthAndYear]?.categoryRestaurant += expenseCostValue
                        case "Groceries":
                            importantDataPoints[monthAndYear]?.categoryGroceries += expenseCostValue
                        case "Other":
                            importantDataPoints[monthAndYear]?.categoryOther += expenseCostValue
                        default:
                            print("default")
                    }
                
                
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
            }
            
        }
        
        
      
        
        queryOperation.queryResultBlock = {[weak self] returnedResult in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-yyyy"
            
            let dashboardMonthlydata = Array(importantDataPoints.values)
            let sortedDashboardMonthlyData = dashboardMonthlydata.sorted { item1, item2 in
                let date1 = dateFormatter.date(from:item1.monthAndYear)!
                let date2 = dateFormatter.date(from: item2.monthAndYear)!
                return date1 < date2
            }
            
            DispatchQueue.main.async{
                self?.monthlyDataPoints = importantDataPoints
                self?.monthlyDataPointsChart = sortedDashboardMonthlyData
            }
            
            
            
            
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
    let monthAndYear: String
    var totalCosts: Double
    var categoryTransportation: Double
    var categoryRestaurant: Double
    var categoryClothes: Double
    var categoryEntertainment: Double
    var categoryGroceries: Double
    var categoryOther: Double
}


