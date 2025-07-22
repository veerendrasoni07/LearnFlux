import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String link;
  const PdfViewScreen({super.key,required this.link});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: ()=>Navigator.pop(context),
            icon: Icon(
                Icons.arrow_back_ios
            )
        ),
      ),
      body: SfPdfViewer.network(
        link
      ),
    );
  }
}
