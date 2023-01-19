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
    
    var body: some View {
        
        NavigationView{
            ZStack{
                VStack{
                    Text("Monthly Expenses for the past 6 months")
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
                    
                    Spacer()
                }
            }
            
        }
        
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(vm: .constant(CloudKitViewModel()))
    }
}
