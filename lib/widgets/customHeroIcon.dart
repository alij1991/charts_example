
import 'package:flutter/material.dart';

class CustomHeroIcon extends StatelessWidget {
  const CustomHeroIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'botIcon',
      child: Container(
        width: 100,
        height: 100,
        child: Image.asset('assets/images/appIcon.png'),
      ),
    );
  }
}
