import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  AnimationController _titleController;
  Animation<double> _titleAnimation;

  AnimationController _formController;
  Animation<double> _opacityAnimation;
  Animation<Offset> _positionAnimation;

  final alphaTween = Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    final Animation titleCurve = CurvedAnimation(parent: _titleController, curve: Curves.easeInOut);
    _titleAnimation = Tween<double>(begin: 0, end: 1).animate(titleCurve);
    _titleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationRun = true;
        });
      }
    });
    _titleController.forward();

    // Form
    _formController = AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    _positionAnimation = Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _formController, curve: Curves.easeInOut));
    _opacityAnimation = alphaTween.animate(_formController);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  final duration = Duration(milliseconds: 900);
  bool animationRun = false;

  Widget _buildBody() {
    final widgets = <Widget>[];
    widgets.addAll(_buildLineHeader());
    widgets.add(_buildTitleHeader());
    widgets.add(_buildForm());

    return Container(
      child: Stack(children: widgets),
    );
  }

  Widget _buildForm() {
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: _positionAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username or Email',
                    prefixIcon: Icon(Icons.perm_identity),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff196bff), width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff196bff), width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ButtonTheme(
                  buttonColor: Color(0xff196bff),
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      "Login to continue",
                      style: textTheme.button.copyWith(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 30),
                ButtonTheme(
                  buttonColor: Color(0xff2d3044),
                  height: 40,
                  child: OutlineButton(
                    child: Text(
                      "Continue in with Google",
                      style: textTheme.button.copyWith(color: Color(0xffaaabb7)),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 10),
                ButtonTheme(
                  buttonColor: Color(0xff2d3044),
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      "Create a Bubble Account",
                      style: textTheme.button.copyWith(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeader() {
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      left: 20,
      right: 40,
      top: 60,
      child: FadeTransition(
        opacity: _titleAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlutterLogo(
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              "Welcome to HB",
              style: textTheme.headline.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit consetetur sadipscing elitr, sed diam",
              style: textTheme.body1.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLineHeader() {
    final height = MediaQuery.of(context).size.height;
    return <Widget>[
      AnimatedPositioned(
        duration: duration,
        left: -1000,
        right: -800,
        top: -700,
        bottom: animationRun ? height - 280 : -240,
        curve: Interval(0.43, 1.0, curve: Curves.easeInOut),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.2)),
        ),
        onEnd: () => print("Test 01"),
      ),
      AnimatedPositioned(
        duration: duration,
        left: -1000,
        right: -850,
        top: -800,
        bottom: animationRun ? height - 250 : -240,
        curve: Interval(0.33, 1.0, curve: Curves.easeInOut),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff196bff)),
        ),
        onEnd: () => print("Test 02"),
      ),
      AnimatedPositioned(
        duration: duration,
        left: -1000,
        right: -900,
        top: -1000,
        bottom: animationRun ? height - 220 : -240,
        curve: Interval(0.13, 1.0, curve: Curves.easeInOut),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
        onEnd: () {
          print("Test 03");
          _formController.forward();
        },
      ),
    ];
  }
}
