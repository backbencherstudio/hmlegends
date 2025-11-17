import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/stock/stock_screen_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditDialog extends StatelessWidget {
  const EditDialog({super.key});

  static Future<void> showEditDialog(
    BuildContext context,
    String productId,
  ) async {
    final provider = Provider.of<StockScreenProvider>(context, listen: false);

    await provider.getSingleProductProduct(productId);

    if (provider.singleProductModel == null ||
        provider.singleProductModel?.data == null) {
      debugPrint(" Single product not loaded");
      return;
    }

    final TextEditingController _nameController = TextEditingController(
      text: provider.singleProductModel!.data!.name ?? "",
    );
    final TextEditingController _priceController = TextEditingController(
      text: provider.singleProductModel!.data!.price?.toString() ?? "",
    );
    final TextEditingController _stockController = TextEditingController(
      text: provider.singleProductModel!.data!.stock?.toString() ?? "",
    );

    File? image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
              title: Text("Edit Product: $productId"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price"),
                    ),
                    TextField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Stock"),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text("Pick Image"),
                    ),

                    if (image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.file(image!, height: 100),
                      ),

                    if (image == null &&
                        provider.singleProductModel!.data!.image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.network(
                          provider.singleProductModel!.data!.image!,
                          height: 100,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    provider.editProduct(
                      pId: productId,
                      name: _nameController.text,
                      price: _priceController.text,
                      stock: _stockController.text,
                      image: image,
                    );
                    Navigator.of(context).pop();
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
