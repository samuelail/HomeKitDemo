//
//  AccessoriesView.swift
//  HomeKitDemo
//
//  Created by samuel Ailemen on 10/5/24.
//

import SwiftUI
import HomeKit

struct AccessoriesView: View {
    
    var homeId: UUID
    @ObservedObject var model: HomeStore

    var body: some View {
        List {
            Section(header: HStack {
                Text("My Accessories")
            }) {
                ForEach(model.accessories, id: \.uniqueIdentifier) { accessory in
                    NavigationLink(destination: {
                        ServicesView(accessoryId: accessory.uniqueIdentifier, homeId: homeId, model: model)
                    }, label: {
                        Text("\(accessory.name)")
                    })
                }
            }
        }.onAppear(){
            model.findAccessories(homeId: homeId)
        }
    }
}
