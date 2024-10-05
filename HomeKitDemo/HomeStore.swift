//
//  HomeStore.swift
//  HomeKitDemo
//
//  Created by samuel Ailemen on 10/5/24.
//

import Foundation
import HomeKit
import Combine
import SwiftUI

class HomeStore: NSObject, ObservableObject, HMHomeManagerDelegate {
    
    
    @Published var homes: [HMHome] = []
    @Published var accessories: [HMAccessory] = []
    @Published var services: [HMService] = []
    @Published var characteristics: [HMCharacteristic] = []
    @Published var readingData: Bool = false

    private var manager: HMHomeManager!

    @Published var powerState: Bool?
    @Published var hueValue: Int?
    @Published var brightnessValue: Int?
    
    override init(){
        super.init()
        load()
    }
    
    func load() {
        if manager == nil {
            manager = .init()
            manager.delegate = self
        }
    }
    
    func readCharacteristicValues(serviceId: UUID){
        guard let characteristicsToRead = services.first(where: {$0.uniqueIdentifier == serviceId})?.characteristics else {
            print("ERROR: Characteristic not found!")
            return
        }
       readingData = true
        for characteristic in characteristicsToRead {
            characteristic.readValue(completionHandler: {_ in
                if characteristic.localizedDescription == "Power State" {
                    self.powerState = characteristic.value as? Bool
                }
                if characteristic.localizedDescription == "Hue" {
                    self.hueValue = characteristic.value as? Int
                }
                if characteristic.localizedDescription == "Brightness" {
                    self.brightnessValue = characteristic.value as? Int
                }
                self.readingData = false
            })
        }
    }
    
    func setCharacteristicValue(characteristicID: UUID?, value: Any) {
        guard let characteristicToWrite = characteristics.first(where: {$0.uniqueIdentifier == characteristicID}) else {
            print("ERROR: Characteristic not found!")
            return
        }
        characteristicToWrite.writeValue(value, completionHandler: {_ in
            self.readCharacteristicValue(characteristicID: characteristicToWrite.uniqueIdentifier)
        })
   
    }
    
    func readCharacteristicValue(characteristicID: UUID?){
        guard let characteristicToRead = characteristics.first(where: {$0.uniqueIdentifier == characteristicID}) else {
            print("ERROR: Characteristic not found!")
            return
        }
        readingData = true
        characteristicToRead.readValue(completionHandler: {_ in
            if characteristicToRead.localizedDescription == "Power State" {
                self.powerState = characteristicToRead.value as? Bool
            }
            if characteristicToRead.localizedDescription == "Hue" {
                self.hueValue = characteristicToRead.value as? Int
            }
            if characteristicToRead.localizedDescription == "Brightness" {
                self.brightnessValue = characteristicToRead.value as? Int
            }
            self.readingData = false
        })
    }

    func findCharacteristics(serviceId: UUID, accessoryId: UUID, homeId: UUID){
        guard let serviceCharacteristics = homes.first(where: {$0.uniqueIdentifier == homeId})?.accessories.first(where: {$0.uniqueIdentifier == accessoryId})?.services.first(where: {$0.uniqueIdentifier == serviceId})?.characteristics else {
            print("ERROR: No Services found!")
            return
        }
        characteristics = serviceCharacteristics
    }
    
    func findServices(accessoryId: UUID, homeId: UUID){
        guard let accessoryServices = homes.first(where: {$0.uniqueIdentifier == homeId})?.accessories.first(where: {$0.uniqueIdentifier == accessoryId})?.services else {
            print("ERROR: No Services found!")
            return
        }
        services = accessoryServices
    }
    
    func findAccessories(homeId: UUID) {
        guard let devices = homes.first(where: {$0.uniqueIdentifier == homeId})?.accessories else {
            print("ERROR: No Accessory not found!")
            return
        }
        accessories = devices
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("DEBUG: Updated Homes!")
        self.homes = self.manager.homes
    }
}
