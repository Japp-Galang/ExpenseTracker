import SwiftUI

/*
 View for adding expenses to private data set of expenses
 asks for:
    - What it is            String
    - Genre                 Categories
    - How much it costs     Double
    - Date Purchased        Date
 */


struct AddExpenseView: View {
    
    @StateObject private var vm = CloudKitViewModel()
    
    let genres = ["Genre Select", "Transportation/gas", "Restaurants/Cafe", "Clothes", "Entertainment/Leisure", "Groceries", "Other"]
   
    var body: some View{
        
        NavigationView{
            Form{
                Section(header: Text("Expense Information")){
                    expenseName
                    expenseCost
                    DatePicker("Expense bought", selection: $vm.dateBought, displayedComponents: .date)
                    
                    Picker("Select a Genre", selection: $vm.selection){ ForEach(genres, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.gray)
                }
                
            }
            .navigationTitle("Add Expense")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button{
                        vm.saveFormPressed()
                    }
                    label: {
                        Text("Save")
                    }
                    
                }
            }
        }
        
                
    }
}



struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}

extension AddExpenseView {
    
    // --text field attributes--
    //expense name
    private var expenseName: some View{
        TextField("Expense Name", text: $vm.expenseNameText)
    }
    
    //expense cost
    private var expenseCost: some View{
        TextField("Expense Cost", value: $vm.expenseCostValue, format: .number)
    }
}
