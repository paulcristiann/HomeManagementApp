//
//  MenuRowView.swift
//  Home Management
//
//  Created by Paul Vasile on 03/11/2020.
//

import SwiftUI

struct MenuRowView: View {
    
       var image = "creditcard"
       var text = "My Account"

       var body: some View {
          HStack {
             Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(Color("icons"))
                .frame(width: 32, height: 32)

             Text(text)
                .font(.headline)
                .foregroundColor(.primary)

             Spacer()
          }
       }
}

struct MenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        MenuRowView()
    }
}
