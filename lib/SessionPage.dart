/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:quiver/async.dart';
import 'package:scoped_model/scoped_model.dart';

class SessionPage extends StatefulWidget {
  @override
  State createState() {
    return new _SessionPageState();
  }
}

class _SessionPageState extends State<SessionPage> {
  Duration _timeRemaining;
  int _selectedChip;
  bool _showSessionPage = false;

  CountdownTimer _countdownTimer;

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(child: _buildPageContent(context));
  }

  Widget _buildPageContent(BuildContext context) {
    Widget page;
    if (_showSessionPage == false) {
      _selectedChip = null;
      page = _buildSplashPage();
    } else {
      page = _buildSessionPage();
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.largeMargin), child: page);
  }

  Widget _buildSplashPage() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0),
          ),
          elevation: 0,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                "Start a session",
                textAlign: TextAlign.center,
              )),
          onPressed: () => setState(() {
            _showSessionPage = true;
          }),
        ),
      ),
      Container(
          // workaround for BoxFit.fitHeight rendering to the height of the screen, not the available height
          height: MediaQuery.of(context).size.height * (0.65),
          child: Image.asset('assets/photos/device-diagram.jpg'))
    ]);
  }

  Widget _buildSessionPage() {
    return SafeArea(child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
              child: Text(
            "My Session",
            style: Theme.of(context).textTheme.title,
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimensions.fullMargin, Dimensions.fullMargin, Dimensions.fullMargin, 0),
            child: Text("Select a light treatment mode to start the session:"),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _choiceChip(6, model),
              _choiceChip(8, model),
              _choiceChip(10, model),
            ],
          ),
          ..._buildActiveSessionWidgets()
        ],
      );
    }));
  }

  void _onTimerEvent(CountdownTimer event, CarePlanModel model) {
    setState(() {
      _timeRemaining = event.remaining;
    });
    // onDone is also called when the timer is canceled and there is no way to
    // distinguish cancelation from completion, so fire _onTimerFinished at the
    // last onData event instead.
    if (_timeRemaining < Duration(seconds: 1)) {
      _onTimerFinished(model);
    }
  }

  void _onTimerFinished(CarePlanModel model) {
    snack("Session completed!", context);
    model.addCompletedSession(_selectedChip);

    setState(() {
      _showSessionPage = false;
      _timeRemaining = null;
      _countdownTimer.cancel();
      _countdownTimer = null;
    });
  }

  Widget _choiceChip(int minutes, CarePlanModel model) {
    bool isSelected = minutes == _selectedChip;
    return ChoiceChip(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      label: Text(
        '$minutes minutes',
        style: Theme.of(context)
            .accentTextTheme
            .subtitle
            .apply(color: Theme.of(context).accentTextTheme.body1.color),
        overflow: TextOverflow.ellipsis,
      ),
      selected: isSelected,
      onSelected: (bool) => setState(() {
        if (isSelected) {
          _selectedChip = null;
          // stop session if there is one
          _timeRemaining = null;

          _countdownTimer.cancel();
        } else {
          _selectedChip = minutes;
          // start the session!
          _timeRemaining = Duration(minutes: _selectedChip);
          if (_countdownTimer != null) {
            _countdownTimer.cancel();
          }
          _countdownTimer =
              new CountdownTimer(_timeRemaining + Duration(seconds: 1), Duration(seconds: 1));
          _countdownTimer.listen((event) => _onTimerEvent(event, model));
        }
      }),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  List<Widget> _buildActiveSessionWidgets() {
    if (_selectedChip == null || _timeRemaining == null) {
      return [];
    }

    return [
      Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.largeMargin),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[CurvedShape(), CurveAnimation(Duration(minutes: _selectedChip))],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.largeMargin),
        child: Row(
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Text("Hold"),
            Spacer(
              flex: 1,
            ),
            Text("Relax"),
            Spacer(
              flex: 1,
            ),
            Text("Hold"),
            Spacer(flex: 1)
          ],
        ),
      ),
      Container(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                  "Time remaining",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Center(
                child: Text(
                    '${_timeRemaining.inMinutes.toString().padLeft(2, '0')}:${_timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    style: Theme.of(context)
                        .textTheme
                        .display3
                        .apply(color: Theme.of(context).accentColor, fontWeightDelta: 1)),
              )
            ],
          ),
        ),
      )
    ];
  }
}

class CurveAnimation extends StatefulWidget {
  final _animationDuration;

  CurveAnimation(this._animationDuration);

  @override
  _CurveAnimationState createState() => _CurveAnimationState(_animationDuration);
}

class _CurveAnimationState extends State<CurveAnimation> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  final Duration _animationDuration;

  _CurveAnimationState(this._animationDuration);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _animationDuration);
    _controller.addListener(() {});

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _controller.forward();
      }
    });

    _controller.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: AnimationCurvePainter(
            progress: _animation.value, color: Theme.of(context).accentColor));
  }
}

class AnimationCurvePainter extends CustomPainter {
  final double progress;
  final Color color;

//  final double start = -0.5 * Math.pi;
//  final double length = 3.5 * Math.pi;

  AnimationCurvePainter({this.progress, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = this.color
      ..strokeWidth = 5;

    Paint pointPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = this.color
      ..strokeWidth = 15;

    Path originalPath = getPath(size);
    Path partialPath = createPartialPath(originalPath, progress);
    PathMetric lastMetrics = partialPath.computeMetrics().last;
    Path pathEndpoint = lastMetrics.extractPath(lastMetrics.length - 1, lastMetrics.length);

    canvas.drawPath(partialPath, pathPaint);
    canvas.drawPath(pathEndpoint, pointPaint);
//    canvas.drawCircle(
//        Offset(xAtPoint(progress, size.width), yAtPoint(progress, size.height)),
//        5.0,
//        paint);
//    canvas.drawCircle(
//        Offset(xAtPoint(progress - 0.01, size.width),
//            yAtPoint(progress - 0.01, size.height)),
//        4.0,
//        paint);
//    canvas.drawCircle(
//        Offset(xAtPoint(progress - 0.02, size.width),
//            yAtPoint(progress - 0.02, size.height)),
//        3.0,
//        paint);
  }

//  double xAtPoint(double progress, double width) => progress * width;

//  double yAtPoint(double progress, double height) =>
//      (-Math.sin(start + progress * length) + 1) / 2 * height;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GrayCurvePainter(),
    );
  }
}

Path getPath(Size size) {
  var anchorPoints = [
    Offset(size.width / 3.5 * 0.0, size.height * 1.0),
    Offset(size.width / 3.5 * 0.5, size.height * 1.0),
    Offset(size.width / 3.5 * 0.5, size.height * 0.5),
    Offset(size.width / 3.5 * 0.5, size.height * 0.0),
    Offset(size.width / 3.5 * 1.0, size.height * 0),
    Offset(size.width / 3.5 * 1.5, size.height * 0),
    Offset(size.width / 3.5 * 1.5, size.height * 0.5),
    Offset(size.width / 3.5 * 1.5, size.height * 1),
    Offset(size.width / 3.5 * 2.0, size.height * 1),
    Offset(size.width / 3.5 * 2.5, size.height * 1),
    Offset(size.width / 3.5 * 2.5, size.height * 0.5),
    Offset(size.width / 3.5 * 2.5, size.height * 0),
    Offset(size.width / 3.5 * 3.0, size.height * 0),
    Offset(size.width / 3.5 * 3.5, size.height * 0.0),
    Offset(size.width / 3.5 * 3.5, size.height * 0.5),
  ];

  Path path = Path()..moveTo(anchorPoints[0].dx, anchorPoints[0].dy);
  int i = 1;
  while (i < anchorPoints.length - 1) {
    path.quadraticBezierTo(
        anchorPoints[i].dx, anchorPoints[i].dy, anchorPoints[i + 1].dx, anchorPoints[i + 1].dy);
    i = i + 2;
  }
  return path;
}

class _GrayCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = getPath(size);

    Paint paint = new Paint()
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..color = Colors.grey
      ..strokeWidth = 5;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}

Path createPartialPath(Path originalPath, double animationPercent) {
  // ComputeMetrics can only be iterated once!
  final totalLength = originalPath
      .computeMetrics()
      .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

  final currentLength = totalLength * animationPercent;

  return extractPathUntilLength(originalPath, currentLength);
}

Path extractPathUntilLength(Path originalPath, double length) {
  var currentLength = 0.0;

  final path = new Path();

  var metricsIterator = originalPath.computeMetrics().iterator;

  while (metricsIterator.moveNext()) {
    var metric = metricsIterator.current;

    var nextLength = currentLength + metric.length;

    final isLastSegment = nextLength > length;
    if (isLastSegment) {
      final remainingLength = length - currentLength;
      final pathSegment = metric.extractPath(0.0, remainingLength);

      path.addPath(pathSegment, Offset.zero);
      break;
    } else {
      // There might be a more efficient way of extracting an entire path
      final pathSegment = metric.extractPath(0.0, metric.length);
      path.addPath(pathSegment, Offset.zero);
    }

    currentLength = nextLength;
  }

  return path;
}
