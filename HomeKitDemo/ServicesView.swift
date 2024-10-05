//
//  ServicesView.swift
//  HomeKitDemo
//
//  Created by samuel Ailemen on 10/5/24.
//

import SwiftUI
import HomeKit

struct ServicesView: View {
    
    var accessoryId: UUID
    var homeId: UUID
    @ObservedObject var model: HomeStore
    
    var body: some View {
        
        List {
            Section(header: HStack {
                Text("\(model.accessories.first(where: {$0.uniqueIdentifier == accessoryId})?.name ?? "No Accessory Name Found") Services")
            }) {
                ForEach(model.services, id: \.uniqueIdentifier) { service in
                    NavigationLink(destination: {
                        CharacteristicsView(serviceId: service.uniqueIdentifier, accessoryId: accessoryId, homeId: homeId, model: model)
                    }, label: {
                        Text("\(service.localizedDescription)")
                    })
                }
            }
        }.onAppear(){
            model.findServices(accessoryId: accessoryId, homeId: homeId)
        }
    }
}
