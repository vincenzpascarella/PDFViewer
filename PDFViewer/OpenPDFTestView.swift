//
//  OpenPDFTestView.swift
//  PDFViewer
//
//  Created by Vincenzo Pascarella on 14/02/23.
//

import SwiftUI

/// A view, used as example to test the PDFReader, that displays a button to open a PDF reader in full screen.
/// 
/// Use this view to allow the user to open a PDF file in a full screen modal.
/// When the user taps the "Open PDF" button, a `PDFReader` view is presented with the PDF example file that is bundled with the app.
struct OpenPDFTestView: View {
    
    @State private var pdfIsPresented = false
    var body: some View {
        NavigationStack {
            
            Button{
                pdfIsPresented.toggle()
            } label: {
                HStack {
                    Text("Open PDF")
                    Image(systemName: "doc.fill")
                }
            }//ButtonOpenPDF
        }//NavigationStack
        // A full screen cover to present the PDF reader view
        .fullScreenCover(isPresented: $pdfIsPresented) {
            PDFReader(Bundle.main.url(forResource: "PDFBook", withExtension: "pdf")!)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        OpenPDFTestView()
    }
}
