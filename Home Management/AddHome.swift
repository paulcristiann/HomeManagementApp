//
//  AddHome.swift
//  Home Management
//
//  Created by Paul Vasile on 28.11.2020.
//

import SwiftUI

struct AddHome: View {
    @ObservedObject public var AddHomeVM = AddHomeViewModel()
    @State private var HouseName = ""
    @Environment(\.presentationMode) var presentationMode
    @Binding var valueFromParent: Bool
    
    var body: some View {
        ScrollView{
            VStack() {
                Text("Create a new household")
                    .font(.largeTitle).foregroundColor(Color.white)
                    .padding([.top, .bottom], 10)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Household name", text: self.$HouseName)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .autocapitalization(.none)
                    
                }.padding([.leading, .trailing], 27.5)
                
                Button(action: {
                    self.AddHomeVM.setupDataPublisher(name: HouseName)
                }) {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }
                .padding(.top, 20)
                .onChange(of: AddHomeVM.DismissAdd, perform: { value in
                    self.valueFromParent.toggle()
                    self.presentationMode.wrappedValue.dismiss()
                })
            }.padding(.top, 20)
                
            Spacer()
                
            }
            .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))}
    
}
