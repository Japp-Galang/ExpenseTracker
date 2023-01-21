import SwiftUI
import Charts

let PRIMARY_ACCENT = Color(red: 0.0 , green: 0.0, blue: 0.0)
let SECONDARY_ACCENT = Color(red: 0.22, green: 0.24, blue: 0.27)
//Color(red: 0.15, green: 0.29, blue: 0.43)
let TEXT_COLOR =  Color(red: 1.0, green: 1.0, blue: 1.0)



struct DashboardView: View {
   
    
    @StateObject var vm = CloudKitViewModel()
    
    @State var showingCategories = false
    
    var value = 0.0
    var body: some View{
        
        NavigationView{
            ZStack{
                backdrop
                VStack{
                    
                        //top section
                        header
                        Spacer()
                        //Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
                        //Text(vm.error)
                        featuredData
                        monthlyExpensesPastMonths
                        
                        Spacer().frame(height: 15)
                        //mid section
                        HStack{
                            VStack{
                                showAllExpenses
                            }
                            showCategories
                        }
                        
                        Spacer().frame(height: 25)
                    
                        
                     
                    //bottom section
                    addNewExpense
                    }
                    
                
                
            }
            .navigationBarHidden(true)
        }
        
    }
    
    
}

extension DashboardView {
    
    private var backdrop: some View {
        /*
        LinearGradient(colors: [.blue, .black, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
         */
        PRIMARY_ACCENT
            .ignoresSafeArea()
         
    }
    
    
    private var featuredData: some View {
        VStack{
            Text(formatToCurrency(price: String(vm.monthlyDataPointsChart.last?.totalCosts ?? 0)))
                .font(.system(size: 27))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading], 15)
                .foregroundColor(TEXT_COLOR)
            
            Text("Money spent this month")
                .italic()
                .font(.system(size:12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading], 15)
                .foregroundColor(TEXT_COLOR)
        }
    }
    
    
    private var header: some View {
        Text("Budget Tracker")
            .font(.title)
            .padding(.top, 12.0)
            .foregroundColor(TEXT_COLOR)
    }
    
    private var monthlyExpensesPastMonths: some View{
        NavigationLink(destination: ChartsView(vm: .constant(CloudKitViewModel())), label: {
            
            Rectangle()
                .fill(SECONDARY_ACCENT)
                .overlay(
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
                        .padding(10)
                    }
                )
                .onAppear{
                    vm.fillImportantData(beginningMonthAndYear: fiveMonthsAgo(), endMonthAndYear: currentMonthMM() + "-" + String(currentYear()))
                }
                .cornerRadius(15)
                .padding([.leading, .trailing], 15)
        })
    }

    private var showAllExpenses: some View{
        
        NavigationLink(destination: ShowExpensesView(vm: .constant(CloudKitViewModel())), label: {
            Rectangle()
                .fill(SECONDARY_ACCENT)
                .overlay(
                    Text("Expenses")
                        .foregroundColor(TEXT_COLOR)
                
                )
                
                
                .cornerRadius(15)
                .padding([.leading], 17)
                .padding([.trailing], 5)
        
                .frame(maxWidth: 130, maxHeight: .infinity, alignment: .topLeading)
        })
    }
    
    private var showCategories: some View{
        NavigationLink(destination: ShowDetailedCategoriesView(vm: .constant(CloudKitViewModel())), label: {
            Rectangle()
                .fill(SECONDARY_ACCENT)
                .overlay(
                    
                    VStack{
                        Text("Categories")
                            .padding(12)
                            .foregroundColor(TEXT_COLOR)
                        
                        formatCategorySpending(category: "Transportation", costs: vm.monthlyDataPointsChart.last?.categoryTransportation ?? 0.0)
                        
                        formatCategorySpending(category: "Clothes", costs: vm.monthlyDataPointsChart.last?.categoryClothes ?? 0.0)
                        
                        formatCategorySpending(category: "Entertainment", costs: vm.monthlyDataPointsChart.last?.categoryEntertainment ?? 0.0)
                        
                        formatCategorySpending(category: "Restaurants", costs: vm.monthlyDataPointsChart.last?.categoryRestaurant ?? 0.0)
                        
                        formatCategorySpending(category: "Groceries", costs: vm.monthlyDataPointsChart.last?.categoryGroceries ?? 0.0)
                        
                        formatCategorySpending(category: "Other", costs: vm.monthlyDataPointsChart.last?.categoryOther ?? 0.0)
                        
                        
                        Spacer()
                    }
                    
                )
                .cornerRadius(15)
                .frame(maxWidth: 390)
                .padding(.trailing, 17)
        })
        
    }
        
        
    
    
    private var addNewExpense: some View{
        NavigationLink(destination: AddExpenseView(), label: {
            Text("Add New Expense")
                .foregroundColor(.white)
                .padding([.top, .bottom], 20)
                .padding([.leading, .trailing], 120)
                .background(
                Capsule()
            )
        })
    }
    
    
}





struct formatCategorySpending: View{
    let category: String
    let costs: Double
    
    var body: some View{
        return
        HStack{
            Text("\(category): ")
                    .foregroundColor(TEXT_COLOR)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top], 5)
                    .padding([.leading], 7)
            
            Text("\(formatToCurrency(price: String(costs)))")
                .foregroundColor(TEXT_COLOR)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding([.top], 5)
                .padding([.trailing], 10)
        }
    }
}



struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
