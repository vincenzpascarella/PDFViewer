# PDFViewer

The PDFViewer is a simple iOS app that includes a pdf file used as an example for the PDFReader, a SwiftUI View that can be used in any iOS app.

The PDFReader takes advantage of the native iOS PDFKit library for rendering PDF documents.
It allows users to open, read, save, share, and print PDF documents.

## Features
- Open and read PDF documents.
- View PDF documents with smooth scrolling and pinch-to-zoom functionality.
- Search for text within a PDF document.
- Share PDF documents via email, message, or other compatible apps.
- Save PDF documents using the Files browser.
- Print PDF documents using AirPrint.

## Requirements
- iOS 16.0+

## How to use it in personal projects
1. Clone the repository and open it in Xcode.
2. Add to your project the PDFReader.swift file and the others in the "Components" directory.
3. Use the PDFReader View in your app passing it the URL of your pdf or a Data variable that contains it.
4. You can add the .fullScreenCover modifier to call it like in the Native iOS apps.

## In app usage
1. Use pinch-to-zoom and scrolling to navigate the PDF document
2. Tap the "Magnifying glass" in the bottom toolbar to search for text within the document.
3. Tap the "Share" button, in the bottom toolbar or in the top menu, to share the PDF document via email, message, or other compatible apps.
4. Tap the "Save to Files" button in the top menu to save the PDF document.
5. Tap the "Print" button in the top menu to print the PDF document using AirPrint.

## Contributions
Contributions to the project are welcome. To contribute, simply fork the project and submit a pull request with your changes.

## Credits
The PDFViewer project with the PDFReader reusable View was created by me, Vincenzo Pascarella. If you have any questions or feedback, please contact me on [LinkedIn](https://www.linkedin.com/in/vincenzpascarella/).

## License
The PDFViewer is licensed under the MIT License. See the LICENSE file for more information.
