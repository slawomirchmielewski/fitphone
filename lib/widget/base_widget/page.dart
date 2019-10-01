import 'package:flutter/material.dart';

class Page extends StatefulWidget {
  final Color backgroundColor;
  final Color appBarColor;
  final String pageName;
  final Widget appBarTitle;
  final List<Widget> actions;
  final List<Widget> children;
  final double expandedHeight;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final bool scrollable;
  final PreferredSizeWidget bottom;

  Page({
    this.backgroundColor,
    this.pageName,
    this.actions,
    this.appBarColor,
    this.appBarTitle,
    this.automaticallyImplyLeading,
    @required this.children,
    this.expandedHeight,
    this.centerTitle,
    this.scrollable = true,
    this.bottom,
  }) : super();

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  ScrollController _scrollController;

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (100 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
  
  Color getAppBarColor(BuildContext context){
    if(widget.appBarColor != null){
      return widget.appBarColor;
    }
    return Theme.of(context).scaffoldBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
        body: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
            SliverAppBar(
              bottom: widget.bottom,
              backgroundColor: isShrink ? Theme.of(context).canvasColor : getAppBarColor(context),
              automaticallyImplyLeading:
                  widget.automaticallyImplyLeading ?? false,
              title: widget.appBarTitle,
              actions: widget.actions,
              floating: true,
              forceElevated: widget.expandedHeight != null ? false : true,
              flexibleSpace: widget.expandedHeight != null
                  ? FlexibleSpaceBar(
                      centerTitle: false,
                      collapseMode: CollapseMode.none,
                      title: Text(
                        widget.pageName,
                        style: Theme.of(context).textTheme.headline.copyWith(
                            color: Theme.of(context).textTheme.title.color,
                            fontWeight: FontWeight.bold),
                      ),
                      titlePadding: EdgeInsets.only(left: 16, bottom: 12),
                    )
                  : null,
              actionsIconTheme: Theme.of(context).iconTheme,
              textTheme: Theme.of(context).textTheme,
              elevation: 1,
              centerTitle: widget.centerTitle,
              expandedHeight: widget.expandedHeight,
              brightness: Theme.of(context).brightness,
              pinned: true,
              iconTheme: Theme.of(context).iconTheme,
          ),
              SliverList(delegate: SliverChildListDelegate(widget.children))
        ]
        )
    );
  }
}
