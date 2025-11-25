import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

void openInvoice(String url) async {
  try {
    final dir = await getTemporaryDirectory();
    final filePath = "${dir.path}/invoice.pdf";

    await Dio().download(url, filePath);
    await OpenFile.open(filePath);
  } catch (e) {
    print("Error opening invoice: $e");
  }
}
