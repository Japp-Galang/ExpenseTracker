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
    @State private var selectedYear = 2023
    @State private var selectedMonth = "January"
    @State private var date: Date = Date()
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

    var yearAndMonth: String {
        let result = String(selectedMonth) + "-" + String(selectedYear)
        return String(result)
    }
    
    var body: some View {
        NavigationView{
        
            ZStack{
                backdrop
                ScrollView{
                    VStack{
                        
                        Text("Expenses")
                            .underline()
                            .font(.title)
                            .offset(CGSize(width: 20, height: 0))
                            .padding([.top, .bottom], 15)
                       
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
                                    Text(month)
                                }
                            }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 200, height: 200)
                                .clipped()
                        }
                        
                            
                        //TEST
                        Button{
                            print(yearAndMonth)
                        } label: {
                            Text("TEST")
                        }
                        columnNames
                        
                        ForEach(0..<vm.expenses.count){index in
                            HStack{
                                VStack{
                                    Text("\(vm.expenses[index][0])") //Name
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    Text("\(vm.expenses[index][2])") //Date
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                .offset(CGSize(width: 20, height: 0))

                                VStack{
                                    Text("\(formatToCurrency(price:(vm.expenses[index][1])))") //Cost
                                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                                    Text("\(vm.expenses[index][3])") //Genre
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
    var formatThis = Double(price) ?? 0
    return String(format: "$%.02f", formatThis)
    
}


struct ShowExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowExpensesView(vm: .constant(CloudKitViewModel()))
    }
}


