import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SizedBox(
        height: 100.0,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8.0),
                  Text("Something went wrong:"),
                ],
              ),
              Text(e.toString()),
            ],
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,

    ),
  );
}