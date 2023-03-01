//
//  PDFReaderAppearanceSetup.swift
//  PDFViewer
//
//  Created by Vincenzo Pascarella on 01/03/23.
//

import SwiftUI

extension PDFReader {
    /// Call this method to set up the default appearance for the navigation bar or the toolbar with the top placement
    func setupNavigationBarAppearance(){
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    /// Call this method to set up the default appearance for the tab bar.
    func setupTabBarAppearance(){
        let tabBarAppearance = UIToolbarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UIToolbar.appearance().standardAppearance = tabBarAppearance
        UIToolbar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
