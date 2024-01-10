import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';

custumManageButton(BuildContext context,
    {void Function()? onTap, String? name}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      color: Colors.yellow,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            name!,
            style: textstyle(
              color: Colors.black,
              fontSize: 20,
              weight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
