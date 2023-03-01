//
//  PDFReader.swift
//  PDFReader
//
//  Created by Vincenzo Pascarella on 14/02/23.
//

import PDFKit
import SwiftUI
import UniformTypeIdentifiers

/// A view that displays a PDF document and provides options for sharing, saving, and printing the document.
///
/// This view uses `PDFKitRepresentedView` to display the PDF document and provides a toolbar with various options for the user to interact with the document.
///
/// - Note: The PDF document is loaded from the given URL and converted to `Data`. If an error occurs during this process, the app will crash.
struct PDFReader: View{
    
    /// A closure that dismisses the view.
    @Environment(\.dismiss) var dismiss
    
    /// The URL of the PDF document to display.
    let url: URL
    
    /// A Boolean value indicating whether to display the PDF document as a single page.
    let singlePage: Bool
    
    /// A state variable that indicates whether to show the find navigator.
    @State private var showFindNavigator = false
    
    /// A state variable that indicates whether to show the document exporter.
    @State private var showingExporter = false
    
    /// The data of the PDF document.
    private let data: Data
    
    /// The title of the PDF document.
    private let title: String
    
    /// Initializes and returns a new `PDFReader` instance with the specified URL and single page display setting.
    ///
    /// - Parameters:
    ///    - url: The URL of the PDF file to display.
    ///    - singlePage: A Boolean value indicating whether to display the PDF document as a single page. Defaults to `false`.
    ///
    /// - Note: The PDF document is loaded from the given URL and converted to `Data`. If an error occurs during this process, the app will crash.
    init(_ url: URL, singlePage: Bool = false) {
        self.url = url
        self.data = try! Data(contentsOf: url)
        self.title = PDFDocument(data: data)?.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String ?? url.deletingPathExtension().lastPathComponent
        self.singlePage = singlePage
    }
    
    /// Initializes and returns a new `PDFReader` instance with the specified PDF data and single page display setting.
    ///
    /// - Parameters:
    ///    - data: The data of the PDF document to display.
    ///    - singlePage: A Boolean value indicating whether to display the PDF document as a single page.
    init(_ data: Data, singlePage: Bool = false) {
        self.url = URL(dataRepresentation: data, relativeTo: nil)!
        self.data = data
        self.title = PDFDocument(data: data)?.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String ?? url.deletingPathExtension().lastPathComponent
        self.singlePage = singlePage
    }
    
    var body: some View{
        NavigationStack{
            ZStack{
                PDFKitRepresentedView(data, singlePage: singlePage, find: showFindNavigator)
                    .toolbar {
                        
                        // Add a group of items to the bottom bar placement of the toolbar
                        ToolbarItemGroup(placement: .bottomBar) {
                            
                            // Add a ShareLink item to the group, which allows sharing the PDF
                            ShareLink(item: url)
                            
                            // Add a button to show the find navigator
                            Button {
                                showFindNavigator.toggle()
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                        
                        // Add a group of items to the leading navigation bar placement of the toolbar
                        ToolbarItemGroup(placement: .navigationBarLeading) {

                            Menu {
                                
                                //Add Buttons in the Sections to add space between the group of buttons you need
                                Section{
                                    ShareLink(item: url)
                                }
                                
                                Section{
                                    SaveButton(data: data, isPresented: $showingExporter)
                                }
                                
                                Section{
                                    PrintButton(data)
                                }
                                
                            } label: {
                                MenuLabel(title)
                            }
                        }//MenuToolBarItem
                        
                        // Add a group of items to the trailing navigation bar placement of the toolbar
                        ToolbarItemGroup(placement: .navigationBarTrailing){
                            
                            Button {
                                dismiss()
                            } label: {
                                Text("Done").fontWeight(.semibold)
                            }
                        }
                        
                    }//toolbar
                
            }
        }//NavigationStack
        .onAppear {
            setupNavigationBarAppearance()
            setupTabBarAppearance()
        }//onAppear
        .fileExporter(isPresented: $showingExporter, document: PDFFile(data: data), contentType: .pdf, defaultFilename: title + ".pdf") { result in
            switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }//FileExporter
    }
}

struct Previews_PDFReader_Previews: PreviewProvider {
    static var previews: some View {
        PDFReader(Bundle.main.url(forResource: "PDFBook", withExtension: "pdf")!)
    }
}

