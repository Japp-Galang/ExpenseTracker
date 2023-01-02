import SwiftUI
import Charts

struct DashboardView: View {
    
    @StateObject private var vm = CloudKitViewModel()
    
    init(){
        let calendar = Calendar.current
        let today = Date()
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: today)
    }
    

    

    var body: some View{
        NavigationView{
            ZStack{
                backdrop
                VStack{
                    header
                    //Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
                    //Text(vm.error)
                    
                    ZStack{
                        PieChart(startAngle: .degrees(0), endAngle: .degrees(90))
                            .fill(Color.red)
                        
                        PieChart(startAngle: .degrees(90), endAngle: .degrees(180))
                            .fill(Color.green)
                        
                        PieChart(startAngle: .degrees(180), endAngle: .degrees(270))
                            .fill(Color.blue)
                        PieChart(startAngle: .degrees(270), endAngle: .degrees(360))
                            .fill(Color.yellow)
                    }
                    
                    Text("Monthly Expenses for the past year")
                        .font(.title3)
                        .padding([.top], 20)
                    /*
                    Chart(vm.monthlyDataPoints) { item in
                        BarMark(
                            x: .value("Month&Year", item.monthAndYear),
                            y: .value("TotalExpenses", item.totalCosts)
                        )
                    }
                    */
                    Button(action: {
                        
                        for element in vm.monthlyDataPoints {
                            //print(element.monthAndYear)
                        }
                        
                    }) {Text("SDF")}
                        
                    
                    
                    showAllExpenses
                    addNewExpense
                }
            }
            .navigationBarHidden(true)
        }
        
    }
}

extension DashboardView {
    public var backdrop: some View {
        LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
    
    
    private var header: some View {
        Text("Budget Tracker")
            .font(.title)
            .padding(.top, 12.0)
    }
    
    private var showAllExpenses: some View{
        NavigationLink(destination: ShowExpensesView(vm: .constant(CloudKitViewModel())), label: {
            Text("Show All Expenses")
                .foregroundColor(.white)
                .padding([.top, .bottom], 20)
                .padding([.leading, .trailing], 120)
                .background(
                Capsule()
                )
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



struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
