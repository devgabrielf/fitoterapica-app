import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const MyAppBar({
    required this.title,
    this.leading,
    this.actions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", width: 40, height: 40),
            const SizedBox(width: 10),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: actions,
        leading: leading,
        iconTheme: const IconThemeData(color: Colors.white));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
