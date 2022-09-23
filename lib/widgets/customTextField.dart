import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
  const LoginInput({
    Key? key, this.hint_txt, this.obscure_txt, this.onTextChanged,
  }) : super(key: key);
  final String? hint_txt;
  final bool? obscure_txt;
  final Function? onTextChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          // border: Border.all(width: 2.0, color: Theme.of(context).primaryColorLight),
          gradient: LinearGradient(
              colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(8.0),
              // border: Border.all(width: 2.0, color: Theme.of(context).primaryColorLight),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: onTextChanged as void Function(String)?,
                style: TextStyle(color: Theme.of(context).primaryColorLight),
                obscureText: obscure_txt!,
                cursorColor: Theme.of(context).primaryColorLight,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  // disabledBorder: InputBorder.none,

                  contentPadding:
                  EdgeInsets.all(8),
                  hintText: hint_txt,
                  hintStyle: TextStyle(color: Theme.of(context).primaryColorLight.withAlpha(0x66)),
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}
