import 'package:flutter/material.dart';

class Chippy extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget child;
  final VoidCallback? onTap;

  const Chippy(
      {Key? key, this.leading, this.trailing, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .background,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Theme
            .of(context)
            .colorScheme
            .onBackground),
      ),
      margin: const EdgeInsets.only(bottom: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) leading!,
                  const SizedBox(width: 4.0),
                  Flexible(child: child),
                  const SizedBox(width: 4.0),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
