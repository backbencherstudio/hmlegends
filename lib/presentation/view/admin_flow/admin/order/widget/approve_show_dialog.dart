import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/order/widget/success_order_summary_card.dart';




import '../../../../widget/dialog_button.dart';


void showApproveDialog(BuildContext context,String text) {
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
            SuccessOrderSummaryCard(context,  'You have successfully approved the order!');
          }, color: AppColors.primaryColor),
          DialogButton(text: 'Cancel',textColor:AppColors.authHeaderTextColor, onPressed: (){
            Navigator.pop(context);
          }, color: Color(0xFFE9E9EA)),
        ],
      );
    },
  );
}

