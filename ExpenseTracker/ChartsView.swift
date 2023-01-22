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
        
    
    @State var selectedYearEnd = currentYear()
    @State var selectedMonthEnd = currentMonthMMMM()
    @State var endMonthAndYear: String = String(currentMonthMM()) + "-" + String(currentYear())
    
    @State var temp_data: [MonthlyData] = []
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
                    RoundedRectangle(cornerRadius: 15)
                        .fill(SECONDARY_ACCENT)
                        .overlay{
                            VStack{
                                Text("Choose date range")
                                
                                //Beginning Date
                                HStack{
                                    Text("Start")
                                    Picker("select year", selection: $selectedYearBeginning){
                                        ForEach(years, id: \.self) { year in
                                            Text("\(String(year))")
                                        }
                                    }
                                        .clipped()
                                    Picker("select month", selection: $selectedMonthBeginning) {
                                        ForEach(months, id: \.self) { month in
                                            Text(month).tag(month)
                                        }
                                    }
                                        .onReceive([selectedMonthBeginning].publisher.first()) { (value) in
                                                    selectedMonthBeginning = value
                                                }
                                        .clipped()
                                }
                                
                                //End Date
                                HStack{
                                    Text("End")
                                    Picker("select year", selection: $selectedYearEnd){
                                        ForEach(years, id: \.self) { year in
                                            Text("\(String(year))")
                                        }
                                    }
                                        .clipped()
                                    Picker("select month", selection: $selectedMonthEnd) {
                                        ForEach(months, id: \.self) { month in
                                            Text(month).tag(month)
                                        }
                                    }
                                        .onReceive([selectedMonthEnd].publisher.first()) { (value) in
                                                    selectedMonthEnd = value
                                                }
                                        .clipped()
                                }
                                
                                
                                //TEST
                                
                                Button{
  
                                    updateChart()
                                    showChartSettings.toggle()
                                    
                                }
                                label:{
                                    Text("GO")
                                }
                                 
                                //TEST2
                                Button{
                                    temp_data = []
                                }
                                label:{
                                    Text("RESET")
                                }
                                
                                .sheet(isPresented: $showChartSettings){
                                    DisplayChartView(temp_data: temp_data)
                                }
                            }
                        }
                }
            }
            
        }
        
    }
    func updateChart() {
        
        beginningMonthAndYear = String(getMonthNumber(from: selectedMonthBeginning) + "-" + String(selectedYearBeginning))
        
        endMonthAndYear = String(getMonthNumber(from: selectedMonthEnd) + "-" + String(selectedYearEnd))
        
        
        vm.fillImportantData(beginningMonthAndYear: beginningMonthAndYear, endMonthAndYear: endMonthAndYear)
         
        temp_data = vm.monthlyDataPointsChart
        
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(vm: .constant(CloudKitViewModel()))
    }
}

struct DisplayChartView: View {
    let temp_data: [MonthlyData]
    
    
    init(temp_data: [MonthlyData]) {
        self.temp_data = temp_data
        print("//////////////////////")
        print(temp_data)
    }
    var body: some View {
        VStack{
            Text("Monthly Expenses for the past n months")
                .font(.title3)
                .padding([.top], 20)
                .foregroundColor(TEXT_COLOR)
            
            Chart(temp_data) { item in
                BarMark(
                    x: .value("Month&Year", item.monthAndYear),
                    y: .value("TotalExpenses", item.totalCosts)
                )
                .foregroundStyle(Color.black.gradient)
                .cornerRadius(5)
            }
            .onAppear()
            .frame(height: 400)
            .padding(10)
            
            Button{
                print("--------------------------")
                print(temp_data)
            }
                label: {Text("asdf")
            }
                      
            Spacer()
        }
        
    }
}
