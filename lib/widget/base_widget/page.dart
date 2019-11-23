import 'package:flutter/material.dart';

class Page extends StatefulWidget {
  final Color backgroundColor;
  final Color appBarColor;
  final String pageName;
  final Widget appBarTitle;
  final List<Widget> actions;
  final Widget child;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final bool scrollable;
  final bool haveTitle;
  final Widget titleTriling;
  final PreferredSizeWidget bottom;

  Page({
    this.backgroundColor,
    this.pageName,
    this.actions,
    this.appBarColor,
    this.appBarTitle,
    this.haveTitle,
    this.automaticallyImplyLeading = false,
    @required this.child,
    this.centerTitle,
    this.titleTriling,
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


  Widget _getTitle(){
    if(widget.haveTitle == true && isShrink == true){
      return widget.appBarTitle;
    }
    else if(widget.haveTitle == true && isShrink == false){
      return null;
    }

    return widget.appBarTitle;
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              title: _getTitle(),
              actions: widget.actions,
              floating: true,
              forceElevated: false,
              actionsIconTheme: Theme.of(context).iconTheme,
              textTheme: Theme.of(context).textTheme,
              elevation: 1,
              centerTitle: widget.centerTitle,
              brightness: Theme.of(context).brightness,
              pinned: true,
              iconTheme: Theme.of(context).iconTheme,
          ),
              SliverList(delegate: SliverChildListDelegate([
                if(widget.haveTitle == true)Padding(
                  padding:const EdgeInsets.only(left: 16,top: 8,bottom: 16,right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.pageName,style: Theme.of(context).textTheme.display1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.title.color
                      ),),
                      Container(child: widget.titleTriling)
                    ],
                  ),
                ),
                widget.child
              ]),)
          ]
        )
    );
  }
}
