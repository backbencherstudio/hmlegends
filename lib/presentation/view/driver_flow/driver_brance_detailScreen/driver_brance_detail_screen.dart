import 'package:flutter/material.dart';

class DriverBranseDetailScreen extends StatelessWidget {
  const DriverBranseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),

        actions: [

        ],
      ),

    );
  }
}
