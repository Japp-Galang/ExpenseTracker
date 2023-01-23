//
//  ChartsView.swift
//  ExpenseTracker
//
//  Created by Japp Galang on 1/18/23.
//

import SwiftUI
import Charts

struct ChartsView: View {
    
    @Binding var vm: CloudKitViewModel
    
    @State var selectedYearBeginning = Int(takeSubstring(word: fiveMonthsAgo(), beginning: 3, end: 0))!
    @State var selectedMonthBeginning = monthName(takeSubstring(word: fiveMonthsAgo(), beginning: 0, end: -5))
    @State var beginningMonthAndYear: String = String(takeSubstring(word: fiveMonthsAgo(), beginning: 0, end: -5)) + "-" + String(takeSubstring(word: fiveMonthsAgo(), beginning: 3, end: 0))
        
    @State var TEMPORARY: Date = Date()
    
    @State var selectedYearEnd = currentYear()
    @State var selectedMonthEnd = currentMonthMMMM()
    @State var endMonthAndYear: String = String(currentMonthMM()) + "-" + String(currentYear())
    
   
    @State var showChartSettings: Bool = false
    
    
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
    
    var body: some View {
        
        NavigationView{
            ZStack{
                VStack{
                    
                    VStack{
                        Text("Choose date range")
                        
                        //Beginning Date
                        HStack{
                            Text("Start")
                                .padding(.leading, 15)
                            Spacer()
                            Picker("select year", selection: $selectedYearBeginning){
                                ForEach(years, id: \.self) { year in
                                    Text("\(String(year))")
                                }
                            }
                            .frame(width: 100, height: 50)
                            
                            
                                
                            Picker("select month", selection: $selectedMonthBeginning) {
                                ForEach(months, id: \.self) { month in
                                    Text(month).tag(month)
                                }
                            }
                            
                        }
                        
                        //End Date
                        HStack{
                            Text("End")
                                .padding(.leading, 15)
                            Spacer()
                            Picker("select year", selection: $selectedYearEnd){
                                ForEach(years, id: \.self) { year in
                                    Text("\(String(year))")
                                }
                            }
                                
                            Picker("select month", selection: $selectedMonthEnd) {
                                ForEach(months, id: \.self) { month in
                                    Text(month).tag(month)
                                }
                            }
                        }
                        
                        
                        //Go button to confirm choices to view chart
                        Button{
                            updateBeginningAndEnd()
                            showChartSettings.toggle()
                        }
                        label:{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue)
                                .overlay{
                                    Text("Show Chart")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 200, height: 100)
                        }

                        .sheet(isPresented: $showChartSettings){
                            DisplayChartView(beginningMonthAndYear: beginningMonthAndYear, endMonthAndYear: endMonthAndYear)
                                .presentationDetents([.large, .medium])
                        }
                    }
                        
                }
            }
            
        }
        
    }
    func updateBeginningAndEnd() {
        beginningMonthAndYear = String(getMonthNumber(from: selectedMonthBeginning) + "-" + String(selectedYearBeginning))
        endMonthAndYear = String(getMonthNumber(from: selectedMonthEnd) + "-" + String(selectedYearEnd))
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(vm: .constant(CloudKitViewModel()))
    }
}

struct DisplayChartView: View {
    let beginningMonthAndYear: String
    let endMonthAndYear: String
    
    @StateObject var vm = CloudKitViewModel()
    
    
      
    var body: some View {
        VStack{
            Text("Monthly Expenses for the past n months")
                .font(.title3)
                .padding([.top], 20)
                .foregroundColor(TEXT_COLOR)
            
            Chart(vm.monthlyDataPointsChart) { item in
                BarMark(
                    x: .value("Month&Year", item.monthAndYear),
                    y: .value("TotalExpenses", item.totalCosts)
                )
                .foregroundStyle(Color.black.gradient)
                .cornerRadius(5)
            }
            .frame(height: 400)
            .padding(10)
            
            Button{
                print("--------------------------")
                print(vm.monthlyDataPointsChart)
                
            }
                label: {Text("asdf")
            }
                      
            Spacer()
        }
        .onAppear{
            print("beginning Month and Year: \(beginningMonthAndYear)")
            print("end Month and Year: \(endMonthAndYear)")
            vm.fillImportantData(beginningMonthAndYear: beginningMonthAndYear, endMonthAndYear: endMonthAndYear)
        }
        
        
    }
}
