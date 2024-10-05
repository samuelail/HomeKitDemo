//
//  CharacteristicsView.swift
//  HomeKitDemo
//
//  Created by samuel Ailemen on 10/5/24.
//

import SwiftUI
import HomeKit

struct CharacteristicsView: View {
    
    var serviceId: UUID
    var accessoryId: UUID
    var homeId: UUID
    @ObservedObject var model: HomeStore

    
    var body: some View {
        List {
            Section(header: HStack {
                Text("\(model.services.first(where: {$0.uniqueIdentifier == serviceId})?.name ?? "No Service Name Found") Characteristics")
            }) {
                ForEach(model.characteristics, id: \.uniqueIdentifier) { characteristic in
                    NavigationLink(destination: {
                        Text("\(characteristic.localizedDescription)")
                    }, label: {
                        Text(characteristic.metadata?.description ?? "No metadata found")
                    })
                }
            }
            Section(header: HStack {
                Text("\(model.services.first(where: {$0.uniqueIdentifier == serviceId})?.name ?? "No Service Name Found") Characteristics Values")
            }) {
                if model.services.first(where: {$0.uniqueIdentifier == serviceId})?.characteristics.first(where: {$0.localizedDescription == "Power State"}) != nil {
                    Button("Read Characteristics State") {
                        model.readCharacteristicValues(serviceId: serviceId)
                    }
                    Text("Power state: \(model.powerState?.description ?? "no value found")")
                    Text("Hue value: \(model.hueValue?.description ?? "no value found")")
                    Text("Brightness value: \(model.brightnessValue?.description ?? "no value found")")
                }
            }
        }.onAppear(){
            model.findCharacteristics(serviceId: serviceId, accessoryId: accessoryId, homeId: homeId)
            model.readCharacteristicValues(serviceId: serviceId)
        }
    }
}
