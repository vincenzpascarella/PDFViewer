//
//  PDFReader.swift
//  PDFReader
//
//  Created by Vincenzo Pascarella on 14/02/23.
//

import PDFKit
import SwiftUI

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
                                    SaveButton(isPresented: $showingExporter)
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
    }
}

/// Call this method to set up the default appearance for the navigation bar or the toolbar with the top placement
private func setupNavigationBarAppearance(){
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithDefaultBackground()
    UINavigationBar.appearance().standardAppearance = navBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
}

/// Call this method to set up the default appearance for the tab bar.
private func setupTabBarAppearance(){
    let tabBarAppearance = UIToolbarAppearance()
    tabBarAppearance.configureWithDefaultBackground()
    UIToolbar.appearance().standardAppearance = tabBarAppearance
    UIToolbar.appearance().scrollEdgeAppearance = tabBarAppearance
}

// MARK: Menu label style
/// A label used in a menu that displays a title and a chevron icon pointing down.
///
/// Use `MenuLabel` to create a label in a menu that displays a title and a chevron icon pointing down.
///
/// Example usage:
///
///     MenuLabel("Sort by")
///
private struct MenuLabel: View{
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View{
        HStack{
            Text(title)
                .foregroundColor(.primary)
                .font(.body)
                .fontWeight(.semibold)
            
            Image(systemName: "chevron.down.circle.fill").symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.secondary)
                .font(.footnote)
                .fontWeight(.bold)
        }
    }
}

// MARK: Menu button styles

/// A SwiftUI View that represents a print button.
///
/// Use this view to display a button that can be used to print PDF files from the app.
private struct PrintButton: View{
    
    /// The PDF data to be printed.
    let data: Data
    
    /// Initializes a new instance of `PrintButton`.
    /// - Parameter data: The PDF data to be printed.
    init(_ data: Data) {
        self.data = data
    }
    
    var body: some View{
        Button {
            airPrintView(data)
        } label: {
            HStack{
                Text("Print")
                Spacer()
                Image(systemName: "printer")
            }
        }
    }
    
    /// Prints the specified PDF data using the system sheet for printing
    /// - Parameter data: The PDF data to be printed.
    private func airPrintView(_ data: Data) {
        // Start creating the Info about the PDF that will be printed
        guard let pdf = PDFDocument(data: data),
              let pdfName = pdf.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String else {
            print("Error: Invalid PDF data or no title found")
            return
        }
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.jobName = pdfName
        
        // Initializes the PrinterController that rapresents the sheet with the print options
        let printController = UIPrintInteractionController.shared
        printController.printingItem = data
        printController.printInfo = printInfo
        printController.present(animated: true, completionHandler: nil)
    }
}

/// A SwiftUI View that represents a save button.
///
/// Use this view to display a button that can be used to save files to the user's device.
///
/// - Remark: This View is used in conjunction with a Binding object that tracks whether or not the button is currently being presented.
private struct SaveButton: View{
    @Binding var isPresented: Bool
    
    var body: some View{
        Button {
            isPresented.toggle()
        } label: {
            HStack{
                Text("Save to Files")
                Spacer()
                Image(systemName: "folder")
            }
        }
    }
}


/// A UIKit view representing a PDFView to display a PDF document in SwiftUI.
///
/// Use this view as a UIViewRepresentable in SwiftUI to display a PDF document using PDFView from the PDFKit framework.
///
/// - Note: By default, this view displays the entire PDF document with automatic scaling. If the singlePage parameter is set to true, the view displays only one page at a time.
private struct PDFKitRepresentedView: UIViewRepresentable {
    
    /// The type of UIView to create.
    typealias UIViewType = PDFView
    
    /// The PDF data to display.
    let data: Data

    /// Whether to display only a single page of the PDF document at a time.
    let singlePage: Bool

    /// It enables the find interaction on the PDF document..
    var find: Bool
    
    /// Initializes a new `PDFKitRepresentedView` with the specified PDF data, single page display setting, and find interaction setting.
    /// - Parameters:
    ///   - data: The PDF data to display.
    ///   - singlePage: Whether to display only a single page of the PDF document at a time. Default is `false`.
    ///   - find: It enables the find interaction on the PDF document.
    init(_ data: Data, singlePage: Bool = false, find: Bool) {
        self.data = data
        self.singlePage = singlePage
        self.find = find
    }
    
    /// Creates and returns a new `PDFView`.
    /// - Parameter context: The context information provided by the system.
    /// - Returns: A new `PDFView` instance.
    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
        let pdfView = PDFView()
        
        // Set the PDF document to display.
        pdfView.document = PDFDocument(data: data)
        
        // Set the display mode to single page if specified.
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        
        // Enable automatic scaling.
        pdfView.autoScales = true
        
        // Enable find interaction.
        pdfView.isFindInteractionEnabled = true
        
        return pdfView
    }
    
    /// Updates the `PDFView` with any changes to its state.
    /// Presents the "Find" navigator.
    /// - Parameters:
    ///   - pdfView: The `PDFView` to update.
    ///   - context: The context information provided by the system.
    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Present the find navigator for find interaction.
        pdfView.findInteraction.presentFindNavigator(showingReplace: false)
    }
}


struct Previews_PDFReader_Previews: PreviewProvider {
    static var previews: some View {
        PDFReader(Bundle.main.url(forResource: "PDFBook", withExtension: "pdf")!)
    }
}

