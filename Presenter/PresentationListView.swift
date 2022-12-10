//
//  PresentationListView.swift
//  Presenter
//
//  Created by Brian Holderness on 11/16/22.
//

import SwiftUI

enum SortMethod {
    case ascend
    case descend
    case custom
}

final class Router: ObservableObject {
    @Published var path = NavigationPath()
}

struct PresentationListView: View {
    @StateObject var model = DataModel()
    @State private var sortMethod: SortMethod = .custom
    @State private var isCreatingPresentation: Bool = false
    @State private var newPresentationTitle: String = ""
    @StateObject  var router: Router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(model.presentations.sorted(by: sort(first:second:))) { presentation in
                    NavigationLink(presentation.title, value: presentation)
                }
                .onDelete { indexSet in
                    model.presentations.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Presentations")
            .navigationDestination(for: Presentation.self) { presentation in
                PresentationView(presentation: presentation)
            }
            .toolbar(content: myToolBarContent)
        }
        .environmentObject(router)
    }
    
    @ToolbarContentBuilder
    func myToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Reset", action: onResetPressed)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker(selection: $sortMethod, label: Text("Sort by")) {
                    Text("Creation Date").tag(SortMethod.custom)
                    Text("Title Descending").tag(SortMethod.descend)
                    Text("Title Ascending").tag(SortMethod.ascend)
                }
            } label: {
                Label("Options", systemImage: "line.3.horizontal.decrease.circle")
            }
        }
        ToolbarItemGroup(placement: .bottomBar) {
            Button { isCreatingPresentation = true } label: {
                Label("New Presentation", systemImage: "plus.circle.fill")
                    .labelStyle(.titleAndIcon)
                    .fontWeight(.semibold)
            }
            .alert("New Presentation", isPresented: $isCreatingPresentation) {
                TextField("Title", text: $newPresentationTitle)
                Button("Create", action: onCreatePresentation)
                Button("Cancel", role: .cancel) { newPresentationTitle = "" }
            }
            Spacer()
        }
    }
    
    func onResetPressed() {
        model.reset()
    }
    
    func onCreatePresentation() {
        let presentation: Presentation = .init(title: newPresentationTitle, customOrder: DataModel.getNewCustomOrder(), slides: [])
        model.presentations.append(presentation)
        newPresentationTitle = ""
    }
    
    func sort(first: Presentation, second: Presentation) -> Bool {
        switch sortMethod {
        case .ascend:
            return first.title > second.title
        case .descend:
            return first.title < second.title
        case .custom:
            return first.customOrder < second.customOrder
        }
    }
}

struct PresentationListView_Previews: PreviewProvider {
    static var previews: some View {
        PresentationListView(model: DataModel())
    }
}
