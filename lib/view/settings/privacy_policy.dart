import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../public_widget/custom_app_bar.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Privacy Policy", context),
      body: SfPdfViewer.asset("assets/PrivacyPolicy.pdf"),
    );
  }
}
