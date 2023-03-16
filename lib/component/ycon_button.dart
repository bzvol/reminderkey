import 'package:flutter/material.dart';

class YconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Icon icon;

  const YconButton({Key? key, required this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: icon,
      ),
    );
  }
}
