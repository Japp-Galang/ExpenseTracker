import SwiftUI
import Charts

let PRIMARY_ACCENT = Color(red: 0.15 , green: 0.16, blue: 0.21)
let SECONDARY_ACCENT = Color(red: 0.22, green: 0.24, blue: 0.27)
//Color(red: 0.15, green: 0.29, blue: 0.43)
let TEXT_COLOR =  Color(red: 1.0, green: 1.0, blue: 1.0)



struct DashboardView: View {
   
    
    @StateObject private var vm = CloudKitViewModel()
    
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
                    
                    Spacer().frame(height: 25)
                    //mid section
                    HStack{
                        showAllExpenses
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
            .cornerRadius(15)
            .padding([.leading, .trailing], 15)
    }

    private var showAllExpenses: some View{
        
        Button(action: {
            
        }){
            Rectangle()
                .fill(SECONDARY_ACCENT)
                .overlay(
                    Text("Expenses")
                        .foregroundColor(.secondary)
                
                )
                .frame(maxWidth: 180)
                .cornerRadius(15)
                .padding([.leading], 15)
                .padding([.trailing], 5)
        }
        
    }
    
    private var showCategories: some View{
        Button(action: {
            showingCategories.toggle()
        }) {
            Rectangle()
                .fill(SECONDARY_ACCENT)
                .overlay(
                    
                    VStack{
                        Text("Categories")
                            .padding(12)
                            .foregroundColor(TEXT_COLOR)
                        
                        formatCategorySpending(category: "Transportation")
                        formatCategorySpending(category: "Clothes")
                        formatCategorySpending(category: "Entertainment")
                        formatCategorySpending(category: "Restaurants")
                        formatCategorySpending(category: "Groceries")
                        formatCategorySpending(category: "Other")
                        Spacer()
                    }
                    
                )
                .cornerRadius(15)
                .frame(maxWidth: 180)
                .padding([.leading, .trailing], 15)
        }
        
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



struct PieChart: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )

        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        p.addLine(to: center)

        return p
    }
}

struct formatCategorySpending: View{
    let category: String
    
    var body: some View{
        return Text("\(category): ")
                .foregroundColor(TEXT_COLOR)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top], 5)
                .padding([.leading], 5)
    }
   
}




struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
