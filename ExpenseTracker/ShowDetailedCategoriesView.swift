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
    
    
    
    
    //Colors of the pie chart and their genre
    let transportationColor = Color.blue
    let clothesColor = Color.red
    let entertainmentColor = Color.green
    let restaurantsColor = Color.yellow
    let groceriesColor = Color.pink
    let otherColor = Color.orange
    
    var body: some View {
        ZStack{
            backdrop
            VStack{
                Text(selectedMonthAndYear)
                
                //chart
                ZStack{
                    PieChart(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 60))
                        .fill(transportationColor)
                    PieChart(startAngle: Angle(degrees: 60), endAngle: Angle(degrees: 120))
                        .fill(clothesColor)
                    PieChart(startAngle: Angle(degrees: 120), endAngle: Angle(degrees: 180))
                        .fill(entertainmentColor)
                    PieChart(startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 240))
                        .fill(restaurantsColor)
                    PieChart(startAngle: Angle(degrees: 240), endAngle: Angle(degrees: 300))
                        .fill(groceriesColor)
                    PieChart(startAngle: Angle(degrees: 300), endAngle: Angle(degrees: 360))
                        .fill(otherColor)
                        
                    
                }
            
                .padding([.trailing, .leading], 15)
                .frame(height: 400)
                .scaleEffect(animatePieChart ? 1.0 : 0.25)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.50)) {
                        self.animatePieChart.toggle()
                    }
                }
                //legend
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
                                }
                                
                                Spacer().frame(height: 15)
                                
                                HStack{
                                    Rectangle().frame(width: 10, height: 10)
                                        .foregroundColor(restaurantsColor)
                                    Text("Restaurant/Cafe: ").font(.system(size: 14))
                                }
                            }.frame(width: 150, alignment: .leading)
                            
                            //Second Column
                            VStack{
                               
                                HStack{
                                    Rectangle().frame(width: 10, height: 10)
                                        .foregroundColor(entertainmentColor)
                                    Text("Entertainment: ").font(.system(size: 14))
                                }
                                
                                Spacer().frame(height: 15)
                               
                                HStack{
                                    Rectangle().frame(width: 10, height: 10)
                                        .foregroundColor(groceriesColor)
                                    Text("Groceries: ").font(.system(size: 14))
                                }
                                
                               
                                
                            }.frame(width: 125, alignment: .trailing)
                            
                            //Third Column
                            VStack{
                                
                                HStack{
                                    Rectangle().frame(width: 10, height: 10)
                                        .foregroundColor(clothesColor)
                                    Text("Clothes: ").font(.system(size: 14))
                                }
                                
                                Spacer().frame(height: 15)
                                
                                HStack{
                                    Rectangle().frame(width: 10, height: 10)
                                        .foregroundColor(otherColor)
                                    Text("Other: ").font(.system(size: 14))
                                }
                                
                            }.frame(width: 115, alignment: .leading)
                        }
                        
                    
                    )
                    .frame(width: 500, height: 100)
                
                    
 
                Spacer()
            }
            .navigationBarTitle("Category Details")
                .font(.title)
                .padding([.top, .bottom], 12.0)
                .foregroundColor(TEXT_COLOR)
        }
    }
}


extension ShowDetailedCategoriesView {
    private var backdrop: some View {
        PRIMARY_ACCENT
            .ignoresSafeArea()
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
