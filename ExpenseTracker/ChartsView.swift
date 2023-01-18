//
//  ChartsView.swift
//  ExpenseTracker
//
//  Created by Japp Galang on 1/18/23.
//

import SwiftUI

struct ChartsView: View {
    
    @Binding var vm: CloudKitViewModel
    
    var body: some View {
        
        NavigationView{
            ZStack{
                VStack{
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
