import 'dart:math';

import 'package:app/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'fade_route_builder.dart';

class Data {
  String title;
  String description;

  Data(this.title, this.description);
}

class GreetingStartScreen extends StatefulWidget {
  @override
  _GreetingStartScreenState createState() => _GreetingStartScreenState();
}

class _GreetingStartScreenState extends State<GreetingStartScreen> with TickerProviderStateMixin {
  final Duration rippleDuration = Duration(milliseconds: 500);
  final Duration delay = Duration(milliseconds: 100);

  int current = 1;
  AnimationController _controller;
  AnimationController _controllerSlide;
  AnimationController _controllerAlpha;
  Animation<double> _rotateAnimation;
  Animation<double> _alphaAnimation;

  Animation<Offset> _positionAnimation01;
  Animation<Offset> _positionAnimation02;

  bool isForward = true;

  final mData = [
    Data("Title 01", "Lorem ipsum dolor sit consetetur sadipscing elitr, sed diam"),
    Data("Title 02", "Lorem ipsum dolor sit consetetur sadipscing elitr, sed diam"),
    Data("Title 03", "Lorem ipsum dolor sit consetetur sadipscing elitr, sed diam"),
  ];

  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _controllerSlide = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _controllerAlpha = AnimationController(duration: rippleDuration, vsync: this);

    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.easeInCubic);
    final Animation curveAlpha = CurvedAnimation(parent: _controllerAlpha, curve: Curves.easeInCubic);

    final Animation curve01 = CurvedAnimation(
      parent: _controllerSlide,
      curve: Interval(0.23, 1.0, curve: Curves.easeInOut),
    );
    final Animation curve02 = CurvedAnimation(
      parent: _controllerSlide,
      curve: Interval(0.43, 1.0, curve: Curves.easeInOut),
    );

    _positionAnimation01 = Tween(begin: Offset(0, 0), end: Offset(-2, 0)).animate(curve01);
    _positionAnimation02 = Tween(begin: Offset(2, 0), end: Offset(0, 0)).animate(curve02);
    _alphaAnimation = Tween<double>(begin: 1, end: 0).animate(curveAlpha);
    _rotateAnimation = Tween<double>(begin: 0, end: 360).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward || status == AnimationStatus.reverse) {
          setState(() {
            current++;
            if (current > 3) {
              current = 1;
            }
          });
        }
        print("Animation Status: $status");
      });

    _positionAnimation01.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        var temp = _positionAnimation02;
        _positionAnimation02 = _positionAnimation01;
        _positionAnimation01 = temp;
        _controllerSlide.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textThem = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 40),
            color: Color(0xff2a6df6),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(30),
                      width: 32,
                      height: 32,
                      child: FlutterLogo(),
                    ),
                    FlatButton(
                      child: Text(
                        "Skip",
                        style: textThem.button.copyWith(color: Colors.white),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: Padding(padding: EdgeInsets.only(left: 30, right: 30), child: _buildCard(null)),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          mData[current - 1].title,
                          style: textThem.display1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          mData[current - 1].description,
                          textAlign: TextAlign.center,
                          style: textThem.title.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
                RectGetter(
                  key: rectGetterKey,
                  child: GestureDetector(
                    onTap: _onNext,
                    child: Container(
                      width: 72,
                      height: 72,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 8,
                              top: 8,
                              bottom: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(64), color: Colors.white),
                                child: Icon(Icons.arrow_forward, color: Color(0xff406dd6)),
                              ),
                            ),
                            Transform.rotate(
                              angle: degree2Rad(_rotateAnimation.value),
                              child: CircularStepProgressIndicator(
                                totalSteps: 3,
                                currentStep: current,
                                selectedColor: Colors.white,
                                selectedStepSize: 3,
                                unselectedStepSize: 3,
                                unselectedColor: Colors.white12,
                                width: 72,
                                startingAngle: -degree2Rad(90),
                                arcSize: degree2Rad(200),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _ripple(),
        ],
      ),
    );
  }

  Widget _ripple() {
    if (rect == null) return Container();
    final size = MediaQuery.of(context).size;
    print("$rect");
    return AnimatedPositioned(
      duration: rippleDuration,
      left: rect.left,
      top: rect.top,
      right: size.width - rect.right,
      bottom: size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: FadeTransition(
          opacity: _alphaAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Icon(Icons.arrow_forward, color: Color(0xff406dd6)),
          ),
        ),
      ),
    );
  }

  _onNext() {
    if (current == 3) {
      _controllerAlpha.forward();
      setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide);
        });
        Future.delayed(rippleDuration + delay, _gotoLoginScreen);
      });
    } else {
      if (isForward) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      isForward = !isForward;

      _controllerSlide.forward();
    }
  }

  void _gotoLoginScreen() {
    Navigator.of(context).push(FadeRouteBuilder(page: LoginScreen())).then((_) => setState(() {
          rect = null;
          _controllerAlpha.reset();
        }));
  }

  degree2Rad(double degree) {
    return degree * pi / 180.0;
  }

  _buildPage01() {
    return <Widget>[
      Positioned(
        right: 0,
        left: 0,
        top: 0,
        bottom: 50,
        child: SlideTransition(
          position: _positionAnimation01,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff0e46b4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Dash(
                          length: 40, direction: Axis.vertical, dashLength: 8, dashGap: 4, dashColor: Colors.white12),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 16),
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Dash(
                          length: 72, direction: Axis.vertical, dashLength: 8, dashGap: 4, dashColor: Colors.white12),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Icon(
                      Icons.card_membership,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Dash(
                          length: 40, direction: Axis.vertical, dashLength: 8, dashGap: 4, dashColor: Colors.white12),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Positioned.fill(
        bottom: 20,
        left: 30,
        right: 30,
        top: 120,
        child: SlideTransition(
          position: _positionAnimation01,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Color(0xff4685f7)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(48), color: Color(0xff72a4f8)),
                  width: 48,
                  height: 48,
                  child: Icon(Icons.arrow_upward, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(64), color: Color(0xff72a4f8)),
                  width: 64,
                  height: 64,
                  child: Icon(Icons.filter, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(48), color: Color(0xff72a4f8)),
                  width: 48,
                  height: 48,
                  child: Icon(Icons.open_with, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  _buildPage02() {
    return <Widget>[
      Positioned(
        right: 0,
        left: 0,
        top: 0,
        bottom: 50,
        child: SlideTransition(
          position: _positionAnimation02,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff0e46b4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Dash(
                          length: 40, direction: Axis.vertical, dashLength: 8, dashGap: 4, dashColor: Colors.white12),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 16),
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Dash(
                          length: 72, direction: Axis.vertical, dashLength: 8, dashGap: 4, dashColor: Colors.white12),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Icon(
                      Icons.card_membership,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Dash(
                          length: 40, direction: Axis.vertical, dashLength: 8, dashGap: 4, dashColor: Colors.white12),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Positioned.fill(
        bottom: 20,
        left: 30,
        right: 30,
        top: 120,
        child: SlideTransition(
          position: _positionAnimation02,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Color(0xff4685f7)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(48), color: Color(0xff72a4f8)),
                  width: 48,
                  height: 48,
                  child: Icon(Icons.arrow_upward, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(64), color: Color(0xff72a4f8)),
                  width: 64,
                  height: 64,
                  child: Icon(Icons.filter, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(48), color: Color(0xff72a4f8)),
                  width: 48,
                  height: 48,
                  child: Icon(Icons.open_with, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  _buildCard(Object data) {
    final arr = <Widget>[];
    arr.addAll(_buildPage01());
    arr.addAll(_buildPage02());
    return Stack(children: arr);
  }
}

class Dash extends StatelessWidget {
  const Dash(
      {Key key,
      this.direction = Axis.horizontal,
      this.dashColor = Colors.black,
      this.length = 200,
      this.dashGap = 3,
      this.dashLength = 6,
      this.dashThickness = 1,
      this.dashBorderRadius = 0})
      : super(key: key);

  final Axis direction;
  final Color dashColor;
  final double length;
  final double dashGap;
  final double dashLength;
  final double dashThickness;
  final double dashBorderRadius;

  @override
  Widget build(BuildContext context) {
    var dashes = <Widget>[];
    double n = (length + dashGap) / (dashGap + dashLength);
    int newN = n.round();
    double newDashGap = (length - dashLength * newN) / (newN - 1);
    for (var i = newN; i > 0; i--) {
      dashes.add(step(i, newDashGap));
    }
    if (direction == Axis.horizontal) {
      return SizedBox(
          width: length,
          child: Row(
            children: dashes,
          ));
    } else {
      return Column(children: dashes);
    }
  }

  Widget step(int index, double newDashGap) {
    bool isHorizontal = direction == Axis.horizontal;
    return Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          0,
          isHorizontal && index != 1 ? newDashGap : 0,
          isHorizontal || index == 1 ? 0 : newDashGap,
        ),
        child: SizedBox(
          width: isHorizontal ? dashLength : dashThickness,
          height: isHorizontal ? dashThickness : dashLength,
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: dashColor, borderRadius: BorderRadius.all(Radius.circular(dashBorderRadius))),
          ),
        ));
  }
}
