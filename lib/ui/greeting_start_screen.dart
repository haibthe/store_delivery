import 'dart:math';

import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class GreetingStartScreen extends StatefulWidget {
  @override
  _GreetingStartScreenState createState() => _GreetingStartScreenState();
}

class _GreetingStartScreenState extends State<GreetingStartScreen> with SingleTickerProviderStateMixin {
  int current = 1;
  AnimationController _controller;
  Animation<double> _rotateAnimation;

  bool isForward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _rotateAnimation = Tween<double>(begin: 0, end: 360).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          setState(() {
            current++;
            if (current > 3) {
              current = 1;
            }
          });
        }
        print("Animation Status: $status");
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
      body: Container(
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
              child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: _buildCard(null)),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Community",
                      style: textThem.display1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Lorem ipsum dolor sit consetetur sadipscing elitr, sed diam",
                      textAlign: TextAlign.center,
                      style: textThem.title.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isForward) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
                isForward = !isForward;
              },
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
          ],
        ),
      ),
    );
  }

  degree2Rad(double degree) {
    return degree * pi / 180.0;
  }

  _buildCard(Object data) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          bottom: 50,
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
        Positioned.fill(
          bottom: 20,
          left: 30,
          right: 30,
          top: 120,
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
        )
      ],
    );
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
