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
    @State var animatePieChart = false
    
    //Current Month and Year
    @State var selectedMonthAndYear = formatToFullMonthAndYear(formatDate: firstDayOfMonth(date: Date()))
    
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
    
    //Legend data
    @State var transportationPercentage: Double = 0
    @State var restaurantPercentage: Double = 0
    @State var entertainmentPercentage: Double = 0
    @State var clothesPercentage: Double = 0
    @State var groceriesPercentage: Double = 0
    @State var otherPercentage: Double = 0
    
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
                Button(action: {
                    print(selectedMonthAndYear)
                }) {
                    Text("tap me")
                }
            }
            .navigationBarTitle("Category Details")
                .font(.title)
                .padding([.top, .bottom], 12.0)
                .foregroundColor(TEXT_COLOR)
        }
    }
    
    func getPieChartData() {
        var transportationTotal: Double = (((vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.categoryTransportation) ?? 0) / (vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.totalCosts ?? 1)) * 360
        if(transportationTotal.isNaN){
            transportationTotal = 0
        }
        //print("transportationTotal: \(transportationTotal)")
        
        var restaurantTotal: Double = (((vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.categoryRestaurant) ?? 0) / (vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.totalCosts ?? 1)) * 360
        if(restaurantTotal.isNaN){
            restaurantTotal = 0
        }
        //print("restaurantTotal: \(restaurantTotal)")
        
        var entertainmentTotal: Double = (((vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.categoryEntertainment) ?? 0) / (vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.totalCosts ?? 1)) * 360
        if(entertainmentTotal.isNaN){
            entertainmentTotal = 0
        }
        //print("entertainmentTotal: \(entertainmentTotal)")
        
        var clothesTotal: Double = (((vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.categoryClothes) ?? 0) / (vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.totalCosts ?? 1)) * 360
        if(clothesTotal.isNaN){
            clothesTotal = 0
        }
        //print("clothesTotal: \(clothesTotal)")
        
        var groceriesTotal: Double = (((vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.categoryGroceries) ?? 0) / (vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.totalCosts ?? 1)) * 360
        if(groceriesTotal.isNaN){
            groceriesTotal = 0
        }
        //print("groceriesTotal: \(groceriesTotal)")
        
        var otherTotal: Double = (((vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.categoryOther) ?? 0) / (vm.monthlyDataPointsChart.first(where: { $0.monthAndYear == formatToMonthAndYear(formateDate: selectedMonthAndYear)})?.totalCosts ?? 1)) * 360
        if(otherTotal.isNaN){
            otherTotal = 0
        }
        //print("otherTotal: \(otherTotal)")
        
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
        
        transportationPercentage = transportationTotal/360*100
        restaurantPercentage = restaurantTotal/360*100
        entertainmentPercentage = entertainmentTotal/360*100
        clothesPercentage = clothesTotal/360*100
        groceriesPercentage = groceriesTotal/360*100
        otherPercentage = otherTotal/360*100
    }
    
    func incrementMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM-yyyy"

        var date = formatter.date(from: selectedMonthAndYear)!
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EST")!
        
       
        date = calendar.date(byAdding: .month, value: 1, to: date)!
        

        selectedMonthAndYear = formatter.string(from: date)
        print("\(date) converted to \(selectedMonthAndYear)")
        getPieChartData()
    }
    
    func decrementMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM-yyyy"

        var date = formatter.date(from: selectedMonthAndYear)!
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EST")!
        
        date = calendar.date(byAdding: .month, value: -1, to: date)!
        selectedMonthAndYear = formatter.string(from: date)
        print("\(date) converted to \(selectedMonthAndYear)")
        getPieChartData()
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
                decrementMonth()
            }){
                RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40)
                    .foregroundColor(SECONDARY_ACCENT)
                    .overlay(
                        Image(systemName: "arrowshape.left")
                    )
            }
            
            Text(selectedMonthAndYear)
            
            Button(action: {
                incrementMonth()
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
                            Text("Transportation: \(formatDoubleToPercentage(transportationPercentage))").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                        
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(restaurantsColor)
                            Text("Restaurant/Cafe: \(formatDoubleToPercentage(restaurantPercentage))").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                        
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(entertainmentColor)
                            Text("Entertainment: \(formatDoubleToPercentage(entertainmentPercentage))").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                    }.frame(width: 150, alignment: .leading)
                    
                    //Second Column
                    VStack{
                       
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(clothesColor)
                            Text("Clothes: \(formatDoubleToPercentage(clothesPercentage))").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                        
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(groceriesColor)
                            Text("Groceries: \(formatDoubleToPercentage(groceriesPercentage))").font(.system(size: 14))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                       
                        HStack{
                            Rectangle().frame(width: 10, height: 10)
                                .foregroundColor(otherColor)
                            Text("Other: \(formatDoubleToPercentage(otherPercentage))").font(.system(size: 14))
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
func formatToFullMonthAndYear(formatDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM-yyyy"
    let monthName = dateFormatter.string(from: formatDate)
    
    return monthName
}

/*
 Function to format a date from the format MMMM to mm-yyyy
 */
func formatToMonthAndYear(formateDate: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM-yyyy"
    let date = formatter.date(from: formateDate)!

    formatter.dateFormat = "MM-yyyy"
    return formatter.string(from: date)
    
}

/*
 Function to format a double (.56) to a percentage (56%)
 */
func formatDoubleToPercentage(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 2
    formatter.minimumIntegerDigits = 1
    formatter.multiplier = 1
    let formattedValue = formatter.string(from: NSNumber(value: value))
    return formattedValue!
}


/*
 Function to return the first day of a month
 */
func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = calendar.date(from: components)
    return firstDayOfMonth!
}



struct ShowDetailedCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDetailedCategoriesView(vm: .constant(CloudKitViewModel()))
    }
}
