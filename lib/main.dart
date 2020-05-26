import 'package:app/ui/greeting_start_screen.dart';
import 'package:flutter/material.dart';

//void main() => runApp(GreetingStartScreen());

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(primaryColor: Color(0xff031ef9)),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),

      home: GreetingStartScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff69D16C).withOpacity(0.5), Color(0x00C4C4C4)])),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.green),
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                  ),
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 50, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "SWIFT FOOD",
                    style: textTheme.display2.copyWith(fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),
                  ),
                  Text(
                    "Fill your craving with our solution",
                    style: textTheme.body1.copyWith(color: Color(0xff858585)),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width - 90,
                          buttonColor: Colors.green,
                          height: 45,
                          child: RaisedButton(
                            child: Text(
                              "Get Started",
                              style: textTheme.button.copyWith(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width - 90,
                          height: 45,
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Skip",
                              style: textTheme.button.copyWith(color: Color(0xffc0c0c0)),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
