//
//  ContentView.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @EnvironmentObject var vm: ContentViewModel

    var body: some View {
        ZStack {
            if vm.showAddTokenMenu {
                AddTokenMenuView()
            }
            VStack {
                Spacer()
                HStack() {
                    Button("Reset") {
                        vm.resetBoard()
                    }
                    Spacer()
                    Button("+") {
                        vm.toggleAddTokenMenu()
                    }
                }
            }
            HStack(spacing: 30) {
                ForEach($vm.tokens, id:\.self) { model in
                    TokenCardView(model: model)
                        .zIndex(-1)
                }
            }.zIndex(-1)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var myEnv = ContentViewModel()
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewInterfaceOrientation(.landscapeLeft)
                .environmentObject(myEnv)
        } else {
            // Fallback on earlier versions
            ContentView()
        }
    }
}
