//
//  ShowDetailedCategoriesView.swift
//  ExpenseTracker
//
//  Created by Japp Galang on 1/10/23.
//

import SwiftUI

struct ShowDetailedCategoriesView: View {
    
    @Binding var vm: CloudKitViewModel
    
    var body: some View {
        ZStack{
            backdrop
            VStack{
                Text("Category Details")
                    .font(.title)
                    .padding([.top, .bottom], 12.0)
                    .foregroundColor(TEXT_COLOR)
                ZStack{
                    PieChart(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90))
                        .fill(Color.red)
                    PieChart(startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180))
                        .fill(Color.blue)
                    PieChart(startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270))
                        .fill(Color.green)
                    PieChart(startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 360))
                        .fill(Color.yellow)
                }
                .padding([.trailing, .leading], 15)
                .frame(height: 400)
                
                
                Spacer()
            }
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


struct ShowDetailedCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDetailedCategoriesView(vm: .constant(CloudKitViewModel()))
    }
}
