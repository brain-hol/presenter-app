//
//  NewPresentationView.swift
//  Presenter
//
//  Created by Brian Holderness on 11/17/22.
//

import SwiftUI

struct PresentationView: View {
    @ObservedObject var presentation: Presentation
    @Environment(\.editMode) private var editMode
    @State private var renameTitleValue = ""
    @State private var isRenaming = false
    @EnvironmentObject var router: Router
    @State private var isShowingSheet = false
    @State private var isRequestingRoom = true
    @State var currentSlideNum = 0
    
    var body: some View {
        List {
            ForEach(presentation.slides) { slide in
                SlideListItem(slide: slide)
            }
            .onMove { indexSet, offset in
                presentation.slides.move(fromOffsets: indexSet, toOffset: offset)
            }
            .onDelete { indexSet in
                presentation.slides.remove(atOffsets: indexSet)
            }
        }
        .listStyle(.plain)
        .navigationTitle(presentation.title)
        .navigationDestination(for: Slide.self) { slide in
            SlideView(slide: slide)
        }
        .toolbar(content: myToolBarContent)
    }
    
    @ToolbarContentBuilder
    func myToolBarContent() -> some ToolbarContent {
        if editMode?.wrappedValue.isEditing == true {
            ToolbarItem {
                EditButton()
            }
        } else {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Rename Presentation") {
                        renameTitleValue = presentation.title
                        isRenaming = true
                    }
                    EditButton()
                } label: {
                    Label("Options", systemImage: "ellipsis.circle")
                }
                .alert("Rename Presentation", isPresented: $isRenaming) {
                    TextField("Title", text: $renameTitleValue)
                    Button("Rename", action: onRenamePresentation)
                    Button("Cancel", role: .cancel) { renameTitleValue = "" }
                }
            }
        }
        ToolbarItemGroup(placement: .bottomBar) {
            Button { onCreateSlide() } label: {
                Label("New Slide", systemImage: "plus.circle.fill")
                    .labelStyle(.titleAndIcon)
                    .fontWeight(.semibold)
            }
            Button("Present") { isShowingSheet = true }
                .sheet(isPresented: $isShowingSheet) {
                    presentationSheet
                }
        }
    }
    
    func onRenamePresentation() {
        presentation.title = renameTitleValue
        renameTitleValue = ""
    }
    
    func onCreateSlide() {
        let slide: Slide = .init(title: "", content: "")
        presentation.slides.append(slide)
        router.path.append(slide)
    }
    
    var presentationSheet: some View {
        NavigationStack {
            VStack {
                if isRequestingRoom {
                    Text("Requesting room code")
                    ProgressView()
                        .task(delayPresentation)
                } else {
                    PresentationSlideView(presentation: presentation, currentSlideNum: $currentSlideNum)
                }
            }
                .toolbar {
                    if !isRequestingRoom {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text("**Room:** DEMO")
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            if currentSlideNum != 0 {
                                Button {
                                    currentSlideNum = max(currentSlideNum - 1, 0)
                                } label: {
                                    Label("Previous Slide", systemImage: "arrow.backward.circle.fill")
                                        .labelStyle(.titleAndIcon)
                                        .fontWeight(.semibold)
                                }
                            } else {
                                Spacer()
                            }
                            if currentSlideNum != presentation.slides.count - 1 {
                                Button {
                                    currentSlideNum = min(currentSlideNum + 1, presentation.slides.count - 1)
                                } label: {
                                    Label("Next Slide", systemImage: "arrow.forward.circle.fill")
                                        .labelStyle(IconLastStyle())
                                        .fontWeight(.semibold)
                                }
                            } else {
                                Spacer()
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("End") {
                            isShowingSheet.toggle()
                            isRequestingRoom = true
                            currentSlideNum = 0
                        }
                    }
                }
        }
        .interactiveDismissDisabled()
    }
    
    @Sendable func delayPresentation() async {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        if isShowingSheet {
            isRequestingRoom = false
        }
    }
}

struct IconLastStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

struct NewPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        PresentationView(presentation: DataModel().presentations[0])
    }
}

struct SlideListItem: View {
    @ObservedObject var slide: Slide
    
    var body: some View {
        NavigationLink(value: slide) {
            HStack {
                Image(systemName: "text.quote")
                    .font(.title)
                    .padding(.trailing, 5)
                    .foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text(slide.title.isEmpty ? "New Slide" : slide.title)
                        .font(.headline)
                        .lineLimit(1)
                    Text(slide.content.isEmpty ? "No content" : slide.content)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .lineLimit(2, reservesSpace: true)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

struct SlideListItem_Previews: PreviewProvider {
    static var previews: some View {
        SlideListItem(slide: DataModel().presentations[0].slides[0])
    }
}

struct PresentationSlideView: View {
    var presentation: Presentation
    @Binding var currentSlideNum: Int
    
    var body: some View {
        VStack {
            Form {
                Text(presentation.slides[currentSlideNum].title)
                    .font(.title2)
                    .bold()
                    .padding(.top)
                Text(presentation.slides[currentSlideNum].content)
                    .padding(.vertical)
                    .transition(.slide)
            }
        }
    }
}

struct PresentationSlideView_Previews: PreviewProvider {
    static var previews: some View {
        PresentationSlideView(presentation: DataModel().presentations[0], currentSlideNum: .constant(0))
    }
}
