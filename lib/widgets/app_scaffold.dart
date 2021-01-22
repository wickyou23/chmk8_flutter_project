import 'package:chkm8_app/services/navigation_service.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final Widget bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final Color backgroundColor;
  final GlobalKey<ScaffoldState> scKey;

  const AppScaffold({
    this.scKey,
    this.body,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
  });

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _scPrivateKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get _myScKey {
    return this.widget.scKey ?? _scPrivateKey;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetService().addScaffold(_myScKey);
    });
  }

  @override
  void dispose() {
    GetService().removeScaffoldKey(_myScKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _myScKey,
      body: this.widget.body,
      bottomNavigationBar: this.widget.bottomNavigationBar,
      resizeToAvoidBottomInset: this.widget.resizeToAvoidBottomInset,
      backgroundColor: this.widget.backgroundColor,
    );
  }
}
