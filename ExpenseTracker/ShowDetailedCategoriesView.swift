//
//  ShowDetailedCategoriesView.swift
//  ExpenseTracker
//
//  Created by Japp Galang on 1/10/23.
//

import SwiftUI

struct ShowDetailedCategoriesView: View {
    
    @Binding var vm: CloudKitViewModel
    
    //animatinos
    @State private var animatePieChart = false
    
    
    //Current Month and Year
    @State private var selectedMonthAndYear = formatToMonthAndYear(formatDate: Date())
    
    //Pie chart data
    @State var transportationBegininning: Double = 0
    @State var transportationEnd: Double = 60
    @State var restaurantBeginning: Double = 60
    @State var restaurantEnd: Double = 120
    @State var entertainmentBeginning: Double = 120
    @State var entertainmentEnd: Double = 180
    @State var clothesBeginning: Double = 180
    @State var clothesEnd: Double = 240
    @State var groceriesBeginning: Double = 240
    @State var groceriesEnd: Double = 300
    @State var otherBeginning: Double = 300
    @State var otherEnd: Double = 360
    
    
    //Colors of the pie chart and their genre
    let transportationColor = Color(red: 0.04, green: 0.85, blue: 0.84)
    let clothesColor = Color(red: 0.20, green: 0.20, blue: 1.00)
    let entertainmentColor = Color(red: 0.27, green: 0.84, blue: 0.17)
    let restaurantsColor = Color(red: 1.00, green: 1.00, blue: 0.10)
    let groceriesColor = Color(red: 1.0, green: 0.00, blue: 0.00)
    let otherColor = Color(red: 0.67, green: 0.00, blue: 1.00)
    
   
    
    var body: some View {
        ZStack{
            backdrop
            VStack{
                
                //top section
                header
                
                //chart
                pieChart
            
                //legend
                legend
                Spacer()
            }
            .navigationBarTitle("Category Details")
                .font(.title)
                .padding([.top, .bottom], 12.0)
                .foregroundColor(TEXT_COLOR)
        }
    }
    
    func getPieChartData() {
        let transportationTotal: Double = ((vm.monthlyDataPointsChart.last?.categoryTransportation ?? 0) / (vm.monthlyDataPointsChart.last?.totalCosts ?? 1)) * 360
        print("transportationTotal: \(transportationTotal)")
        let restaurantTotal: Double = ((vm.monthlyDataPointsChart.last?.categoryRestaurant ?? 0) / (vm.monthlyDataPointsChart.last?.totalCosts ?? 1)) * 360
        print("restaurantTotal: \(restaurantTotal)")
        let entertainmentTotal: Double = ((vm.monthlyDataPointsChart.last?.categoryEntertainment ?? 0) / (vm.monthlyDataPointsChart.last?.totalCosts ?? 1)) * 360
        print("entertainmentTotal: \(entertainmentTotal)")
        let clothesTotal: Double = ((vm.monthlyDataPointsChart.last?.categoryClothes ?? 0) / (vm.monthlyDataPointsChart.last?.totalCosts ?? 1)) * 360
        print("clothesTotal: \(clothesTotal)")
        let groceriesTotal: Double = ((vm.monthlyDataPointsChart.last?.categoryGroceries ?? 0) / (vm.monthlyDataPointsChart.last?.totalCosts ?? 1)) * 360
        print("groceriesTotal: \(groceriesTotal)")
        let otherTotal: Double = ((vm.monthlyDataPointsChart.last?.categoryOther ?? 0) / (vm.monthlyDataPointsChart.last?.totalCosts ?? 1)) * 360
        print("otherTotal: \(otherTotal)")
        
        transportationEnd = transportationTotal
        restaurantBeginning = transportationEnd
        restaurantEnd = transportationTotal + restaurantTotal
        entertainmentBeginning = restaurantEnd
        entertainmentEnd = entertainmentBeginning + entertainmentTotal
        clothesBeginning = entertainmentEnd
        clothesEnd = clothesBeginning + clothesTotal
        groceriesBeginning = clothesEnd
        groceriesEnd = groceriesBeginning + groceriesTotal
        otherBeginning = groceriesEnd
        otherEnd = otherBeginning + otherTotal
        
        
    }
}


extension ShowDetailedCategoriesView {
    private var backdrop: some View {
        PRIMARY_ACCENT
            .ignoresSafeArea()
    }
    
    private var header: some View {
        HStack{
            Button(action: {
                print("asdf")
            }){
                RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40)
                    .foregroundColor(SECONDARY_ACCENT)
                    .overlay(
                        Image(systemName: "arrowshape.left")
                    )
            }
            Text(selectedMonthAndYear)
            Button(action: {
                print("asdf")
            }){
                RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40)
                    .foregroundColor(SECONDARY_ACCENT)
                    .overlay(
                        Image(systemName: "arrowshape.right")
                    )
            }
                
        }
    }
    
    private var pieChart: some View {
        ZStack{
            PieChart(startAngle: Angle(degrees: transportationBegininning), endAngle: Angle(degrees: transportationEnd))
                .fill(transportationColor)
            PieChart(startAngle: Angle(degrees: clothesBeginning), endAngle: Angle(degrees: clothesEnd))
                .fill(clothesColor)
            PieChart(startAngle: Angle(degrees: entertainmentBeginning), endAngle: Angle(degrees: entertainmentEnd))
                .fill(entertainmentColor)
            PieChart(startAngle: Angle(degrees: restaurantBeginning), endAngle: Angle(degrees: restaurantEnd))
                .fill(restaurantsColor)
            PieChart(startAngle: Angle(degrees: groceriesBeginning), endAngle: Angle(degrees: groceriesEnd))
                .fill(groceriesColor)
            PieChart(startAngle: Angle(degrees: otherBeginning), endAngle: Angle(degrees: otherEnd))
                .fill(otherColor)
        }
        .padding(15)
        .frame(height: 350)
        .scaleEffect(animatePieChart ? 1.0 : 0.5)
        .onAppear {
            
            withAnimation(.easeIn(duration: 0.50)) {
                self.animatePieChart.toggle()
                
                
            }
            getPieChartData()
        }
        
    }
    
    
    
    private var legend: some View {
        Rectangle()
            .stroke(SECONDARY_ACCENT, lineWidth: 3)
            .overlay(
                HStack{
                    //First Column
                    VStack{
            
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(transportationColor)
                            Text("Transportation: ").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                        
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(restaurantsColor)
                            Text("Restaurant/Cafe: ").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                        
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(entertainmentColor)
                            Text("Entertainment: ").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                    }.frame(width: 150, alignment: .leading)
                    
                    //Second Column
                    VStack{
                       
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(clothesColor)
                            Text("Clothes: ").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                        
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(groceriesColor)
                            Text("Groceries: ").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                       
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(otherColor)
                            Text("Other: ").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                       
                        
                    }.frame(width: 150, alignment: .trailing)
                        
                    
                   
                }
                
            
            )
            .frame(width: 450, height: 100)
            
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

/*
 Function to format a date from the format mm-yyyy to MMMM yyyy
 */
func formatToMonthAndYear(formatDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    let monthName = dateFormatter.string(from: formatDate)
    
    return monthName
}


struct ShowDetailedCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDetailedCategoriesView(vm: .constant(CloudKitViewModel()))
    }
}
