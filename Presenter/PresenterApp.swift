//
//  PresenterApp.swift
//  Presenter
//
//  Created by Brian Holderness on 11/15/22.
//

import SwiftUI

@main
struct PresenterApp: App {
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemMint
     }
    var body: some Scene {
        WindowGroup {
            PresentationListView()
        }
    }
}
