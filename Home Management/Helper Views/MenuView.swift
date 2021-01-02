//
//  MenuView.swift
//  Home Management
//
//  Created by Paul Vasile on 03/11/2020.
//

import SwiftUI

struct Menu: Identifiable {
   var id = UUID()
   var title: String
   var icon: String
}

let menuData = [
   Menu(title: "My Account", icon: "person.crop.circle"),
   Menu(title: "Settings", icon: "gear"),
   Menu(title: "Billing", icon: "creditcard"),
   Menu(title: "Team", icon: "person.2"),
   Menu(title: "Sign out", icon: "arrow.uturn.down")
]

struct MenuView: View {
    
    var menu = menuData
    @Binding var show: Bool
    @State var showSettings = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(menu) { item in
                    
                    if item.title == "Settings" {
                        
                        Button(action: { self.showSettings.toggle() }) {
                            MenuRowView(image: item.icon, text: item.title)
                        }
                        
                    }else {
                        MenuRowView(image: item.icon, text: item.title)
                    }
                    
                Spacer()
             }
             .padding(.top, 20)
             .padding(30)
             .frame(minWidth: 0, maxWidth: 360)
             .background(Color("button"))
             .cornerRadius(30)
             .padding(.trailing, 60)
             .shadow(radius: 20)
             .rotation3DEffect(Angle(degrees: show ? 0 : 60), axis: (x: 0, y: 10.0, z: 0))
             .animation(.default)
             .offset(x: show ? 0 : -UIScreen.main.bounds.width)
             .onTapGesture {
                self.show.toggle()
             }
             Spacer()
          }
        //.padding(.top, statusBarHeight)
       }
    }
}
