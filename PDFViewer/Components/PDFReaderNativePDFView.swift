//
//  PDFReaderNativePDFView.swift
//  PDFViewer
//
//  Created by Vincenzo Pascarella on 01/03/23.
//

import PDFKit
import SwiftUI

extension PDFReader {
    
    /// A UIKit view representing a PDFView to display a PDF document in SwiftUI.
    ///
    /// Use this view as a UIViewRepresentable in SwiftUI to display a PDF document using PDFView from the PDFKit framework.
    ///
    /// - Note: By default, this view displays the entire PDF document with automatic scaling. If the singlePage parameter is set to true, the view displays only one page at a time.
    struct PDFKitRepresentedView: UIViewRepresentable {
        
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

}
