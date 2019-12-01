import 'package:flutter/material.dart';


class PageStandard extends StatelessWidget {

  final Widget title;
  final Widget child;
  final PreferredSizeWidget bottom;
  final int tabLength;
  final bool automaticallyImplyLeading;
  final List<Widget> actions;

  PageStandard({
    this.title,
    this.child,
    this.bottom,
    this.tabLength,
    this.automaticallyImplyLeading = false,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController (
      initialIndex: 0,
      length: bottom != null ? tabLength : 0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          textTheme: Theme.of(context).textTheme,
          centerTitle: true,
          title: title,
          elevation: 1,
          bottom: bottom,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          brightness: Theme.of(context).brightness,
          actions: actions,
        ),
        body: child,
      ),
    );
  }


}
