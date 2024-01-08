import 'package:flutter/material.dart';

AppBar buildCustomAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 150,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            "https://as1.ftcdn.net/v2/jpg/02/45/71/98/1000_F_245719844_TSZNRYNLIAC53e5HVGpD9lw3SFz9ADgU.jpg",
          ),
        ),
      ),
    ),
  );
}
