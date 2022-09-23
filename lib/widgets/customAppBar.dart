import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget with PreferredSizeWidget{
  const CustomAppbar({Key? key, required this.title, this.noBackButton}) : super(key: key);
  final String title;
  final bool? noBackButton;
  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      bottom: PreferredSize(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).backgroundColor,
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).backgroundColor,
                ],
                stops: [0.2,0.5,0.8],

              ),
            ),
            height: 2.0,
          ),
          preferredSize: Size.fromHeight(4.0)
      ),
      centerTitle: true,
      leading: (widget.noBackButton == null || !widget.noBackButton!)?GestureDetector(
        onTap: ()=>Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ):Container(),
      title: Text(widget.title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary
        ),
      ),
    );
  }
}
