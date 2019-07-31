import 'package:flutter/cupertino.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class MyLoading extends StatelessWidget {
  final double loadingSize;

  MyLoading({this.loadingSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Loading(
        indicator: BallPulseIndicator(),
        size: loadingSize,
      ),
    );
  }
}
