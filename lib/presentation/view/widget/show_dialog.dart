import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/widget/success_dialog.dart';


import 'dialog_button.dart';

void showDeleteDialog(BuildContext context, Function onDelete,String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
        actionsAlignment: MainAxisAlignment.center,
        actions: [

          DialogButton(text: 'Yes', textColor:Colors.white,onPressed: (){
            showSuccessDialog(context, onDelete, 'You successfully deleted the item!');
          }, color: AppColors.primaryColor),
          DialogButton(text: 'Cancel',textColor:AppColors.authHeaderTextColor, onPressed: (){
            Navigator.pop(context);
          }, color: Color(0xFFE9E9EA)),
        ],
      );
    },
  );
}
