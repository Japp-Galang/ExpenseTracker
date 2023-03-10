//
//  ShowExpensesView.swift
//  BudgetTracker
//
//  Created by Japp Galang on 12/16/22.
//

import SwiftUI
import Charts
/*
 View for the menu to show all of the user's expenses
 */

struct ShowExpensesView: View {
    
    @Binding var vm: CloudKitViewModel
    @State private var selectedYear = currentYear()
    @State private var selectedMonth = currentMonthMMMM()
    
    
    let months = ["January"
                  ,"February"
                  ,"March"
                  ,"April"
                  ,"May"
                  ,"June"
                  ,"July"
                  ,"August"
                  ,"September"
                  ,"October"
                  ,"November"
                  ,"December"]
    
    let years = Array(2000...2500)

    @State var yearAndMonth: String = currentMonthMMMM() + "-" + String(currentYear())
    
    @State var selectedQuery: [[String]] = []
    
    var body: some View {
        NavigationView{
        
            ZStack{
                backdrop
                ScrollView{
                    VStack{
                        
                        Text("Expenses")
                            .underline()
                            .font(.title)
                            .padding([.bottom], 15)
                       
                        HStack{
                            Picker("select year", selection: $selectedYear){
                                ForEach(years, id: \.self) { year in
                                    Text("\(String(year))")
                                }
                            }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 200, height: 200)
                                .clipped()
                            Picker("select month", selection: $selectedMonth) {
                                ForEach(months, id: \.self) { month in
                                    Text(month).tag(month)
                                }
                            }
                                .pickerStyle(WheelPickerStyle())
                                .onReceive([selectedMonth].publisher.first()) { (value) in
                                            selectedMonth = value
                                        }
                                .frame(width: 200, height: 200)
                                .clipped()
                        }
                        
                            
                        //TEST
                        Button{
                            refreshExpensesList()
                            print(yearAndMonth)
                            
                        } label: {
                            Text("TEST")
                        }
                        
                        columnNames
                        
                        ForEach(selectedQuery, id:\.self) {item in
                            HStack{
                                VStack{
                                    Text("\(item[0])") //Name
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    Text("\(item[2])") //Date
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                .offset(CGSize(width: 20, height: 0))

                                VStack{
                                    Text("\(formatToCurrency(price:(item[1])))") //Cost
                                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                                    Text("\(item[3])") //Genre
                                        .italic()
                                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                                }
                                .offset(CGSize(width: -20, height: 0))
                            }
                            
                            .padding(.vertical, 5)
                            
                        }
                        Spacer()
                    }
                }
                
                
            }
        }
        
        
    }
    
    func refreshExpensesList() {
        yearAndMonth = selectedMonth + "-" + String(selectedYear)
        var result: [[String]] = []
        
        for item in vm.expenses {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateOfRecord = dateFormatter.date(from: item[2])!
            dateFormatter.dateFormat = "MMMM-yyyy"
            
            let formattedDateRecord = dateFormatter.string(from: dateOfRecord)
            
            if(String(formattedDateRecord) == yearAndMonth){
                result.append(item)
            }
        }
         selectedQuery = result
       
    }
}



extension ShowExpensesView {

    public var backdrop: some View {
        LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
    
    private var columnNames: some View{
        HStack{
            Text("Expense")
                .underline()
                .font(.title)
                .offset(CGSize(width: 20, height: 0))
                
            Text("Cost")
                .underline()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.title)
                .offset(CGSize(width: -20, height: 0))
        }
    }
    
    
}




func formatToCurrency(price: String) -> String{
    let formatThis = Double(price) ?? 0
    return String(format: "$%.02f", formatThis)
    
}



func currentYear() -> Int {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return Int(dateFormatter.string(from: date))!
}



func currentMonthMMMM() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    return dateFormatter.string(from: date)
}



func currentMonthMM() -> String {
    let calendar = Calendar.current
    let month = calendar.component(.month, from: Date())
    return String(format: "%02d", month)
}



func fiveMonthsAgo() -> String {
    let date = Calendar.current.date(byAdding: .month, value: -5, to: Date())!
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-yyyy"
    return formatter.string(from: date)
}



func monthName(_ month: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM"
    guard let date = dateFormatter.date(from: month) else {
        return "Invalid Month"
    }
    dateFormatter.dateFormat = "MMMM"
    return dateFormatter.string(from: date)
}



func getMonthNumber(from month: String) -> String {
    let months = ["January": "01", "February": "02", "March": "03", "April": "04", "May": "05", "June": "06", "July": "07", "August": "08", "September": "09", "October": "10", "November": "11", "December": "12"]
    return months[month] ?? ""
}



struct ShowExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowExpensesView(vm: .constant(CloudKitViewModel()))
    }
}


