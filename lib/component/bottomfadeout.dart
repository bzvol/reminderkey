import 'package:flutter/material.dart';

class BottomFadeOut extends StatelessWidget {
  final Widget child;
  final double start;

  const BottomFadeOut({Key? key, required this.child, this.start = 0.25}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment(0.0, start),
          end: Alignment.bottomCenter,
          colors: const [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
