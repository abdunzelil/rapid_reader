import 'package:flutter/material.dart';

class Slider extends StatefulWidget {
  final String form;
  final String view;
  const Slider({Key? key, required this.form,required this.view}) : super(key: key);

  @override
  _SliderState createState() => _SliderState(this.form,this.view);
}

class _SliderState extends State<Slider> {
  final String form;
  final String view;
  _SliderState(this.form,this.view);
  @override
  Widget build(BuildContext context) {
    final labels = ['1', '2'];
    final double min = 0;
    wordDeger = indexWordSlider + 1;
    final double max = labels.length - 1.0;
    final divisions = labels.length - 1;
    if (form == "speed") {
      return (
        (view=="block")
        ?
        :
      );
    }
    else {
      return (view=="block")
        ?
        :
    }
  }
}
