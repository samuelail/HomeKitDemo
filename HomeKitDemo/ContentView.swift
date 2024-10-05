//
//  ContentView.swift
//  HomeKitDemo
//
//  Created by samuel Ailemen on 10/5/24.
//

import SwiftUI
import HomeKit

struct ContentView: View {
    
     @State private var path = NavigationPath()
     @ObservedObject var model: HomeStore
     
     var body: some View {
//         NavigationStack(path: $path) {
//
//         }
         List {
             Section(header: HStack {
                 Text("My Homes")
             }) {
                 ForEach(model.homes, id: \.uniqueIdentifier) { home in
                     NavigationLink(destination: {
                         AccessoriesView(homeId: home.uniqueIdentifier, model: model)
//                            Text("Details screen")
                     }, label: {
                         Text("\(home.name)")
                     })
//                         NavigationLink({
//                             AccessoriesView(homeId: home.uniqueIdentifier, model: model)
//                         } {
//                             Text("\(home.name)")
//                         })
                 }
             }
         }
     }
}

#Preview {
    ContentView(model: HomeStore())
}
