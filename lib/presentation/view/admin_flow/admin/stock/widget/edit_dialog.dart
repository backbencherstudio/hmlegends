import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/stock/stock_screen_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditDialog extends StatelessWidget {
  const EditDialog({super.key});

  static Future<void> showEditDialog(
    BuildContext context, {
    required String productId,
  }) async {
    final provider = Provider.of<StockScreenProvider>(context, listen: false);

    final product = provider.singleProductModel?.data;

    if (product == null) {
      debugPrint("Product data is null");
      return;
    }


    final nameController = TextEditingController(text: product.name ?? "");

    final priceController = TextEditingController(
      text: product.price?.toString() ?? "",
    );

    final stockController = TextEditingController(
      text: product.stock?.toString() ?? "",
    );

    File? image;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            Future<void> pickImage() async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
              );

              if (pickedFile != null) {
                setState(() {
                  image = File(pickedFile.path);
                });
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(child: Text("Edit Product")),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price"),
                    ),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Stock"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text("Pick Image"),
                    ),
                    const SizedBox(height: 10),

                    // Show new picked image
                    if (image != null) Image.file(image!, height: 100),

                    // Show existing network image
                    if (image == null && product.image != null)
                      Image.network(product.image!, height: 100),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await provider.editProduct(pId: productId, image: image, name: '', stock: '', price: '');

                    if (!dialogContext.mounted) return;

                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
