//
//  PDFReaderButtons.swift
//  PDFViewer
//
//  Created by Vincenzo Pascarella on 01/03/23.
//

import SwiftUI
import PDFKit

extension PDFReader{
    // MARK: Menu label style
    /// A label used in a menu that displays a title and a chevron icon pointing down.
    ///
    /// Use `MenuLabel` to create a label in a menu that displays a title and a chevron icon pointing down.
    ///
    /// Example usage:
    ///
    ///     MenuLabel("Sort by")
    ///
    struct MenuLabel: View{
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
    struct PrintButton: View{
        
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
    /// - Parameters:
    ///    -  data: The `Data` object to be saved.
    ///    - isPresented: A `Binding<Bool>` that controls the presentation of the save dialog.
    ///
    /// - Remark: This View is used in conjunction with a Binding object that tracks whether or not the button is currently being presented.
    struct SaveButton: View{
        
        // The PDF data to save
        let data: Data
        
        // A binding to control whether the save file view is presented or dismissed
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

}
