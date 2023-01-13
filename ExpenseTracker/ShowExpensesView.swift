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
    
    var body: some View {
        NavigationView{
        
            ZStack{
                backdrop
                VStack{
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



extension ShowExpensesView {

    public var backdrop: some View {
        LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
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

struct ShowExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowExpensesView(vm: .constant(CloudKitViewModel()))
    }
}

func formatToCurrency(price: String) -> String{
    var formatThis = Double(price) ?? 0
    
    return String(format: "$%.02f", formatThis)
    
}
