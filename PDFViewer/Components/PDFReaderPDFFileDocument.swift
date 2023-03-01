//
//  PDFReaderPDFFileDocument.swift
//  PDFViewer
//
//  Created by Vincenzo Pascarella on 01/03/23.
//

import SwiftUI
import UniformTypeIdentifiers

extension PDFReader {
    
    /// A file document representing a PDF file.
    ///
    /// This `FileDocument` implementation provides the data of the PDF document as its content.
    /// It also specifies the UTI for PDF files and allows for initialization from a configuration object.
    ///
    /// - Parameters:
    ///    - data: The data of the PDF document.
    ///
    /// - Note: This implementation is suitable for small to medium sized PDF files.
    struct PDFFile: FileDocument {
        // The data of the PDF document
        var data: Data
        
        // The UTI for PDF files
        static var readableContentTypes = [UTType.pdf]
        static var writableContentTypes = [UTType.pdf]
        
        init(data: Data) {
            self.data = data
        }
        
        // Initialize from a configuration object
        init(configuration: ReadConfiguration) throws {
            // Try to get the data from the file URL
            guard let data = configuration.file.regularFileContents else {
                throw CocoaError(.fileReadCorruptFile)
            }
            
            // Assign the data to self
            self.data = data
        }
        
        // Return a file wrapper with the data
        func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
            return FileWrapper(regularFileWithContents: data)
        }
    }
}
