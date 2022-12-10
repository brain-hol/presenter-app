//
//  SlideView.swift
//  Presenter
//
//  Created by Brian Holderness on 11/30/22.
//

import SwiftUI

struct SlideView: View {
    enum Field: Hashable {
        case titleField
        case contentField
    }
    
    @ObservedObject var slide: Slide
    @FocusState private var focusedField: Field?
    
    var body: some View {
        Form {
            TextField("Title", text: $slide.title)
                .focused($focusedField, equals: .titleField)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .contentField
                }
            TextField("Content", text: $slide.content, axis: .vertical)
                .lineLimit(5...25)
                .focused($focusedField, equals: .contentField)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
        }
        .onAppear {
            focusedField = .titleField
        }
    }
}

struct SlideView_Previews: PreviewProvider {
    static var previews: some View {
        SlideView(slide: .init(title: "Preview", content: "Preview stuff and content"))
    }
}
