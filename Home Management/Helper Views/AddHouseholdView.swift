//
//  AddHouseholdView.swift
//  Home Management
//
//  Created by Paul Vasile on 04/11/2020.
//

import SwiftUI

struct AddHouseholdView: View {
    
    var title = "House hold placeholder"
    var numberOfTasks = 10
    var color = Color(.systemGreen)
    var shadowColor = Color.init(.white)

    var body: some View {
        
        VStack(alignment: .leading) {
            
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 60))
                .padding()
                .foregroundColor(.white)

        }
        .cornerRadius(30)
    }
}

struct AddHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseholdView()
    }
}
