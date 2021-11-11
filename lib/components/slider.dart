import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/state/book_controller.dart';

class CustomSlider extends StatelessWidget {
  final String form;
  final Color thumb;
  final Color inactive;
  final Color active;

  CustomSlider({
    Key? key,
    required this.form,
    required this.thumb,
    required this.active,
    required this.inactive,
  }) : super(key: key);
  final state = Get.find<BookController>();
  @override
  Widget build(BuildContext context) {
    if (form == "speed") {
      final labels = [
        '120',
        '150',
        '180',
        '210',
        '240',
        '270',
        '300',
        '330',
        '360',
        '390',
        '420',
        '450',
        '480',
        '510',
        '540',
        '570',
        '600'
      ];
      final double min = 0;
      final isRunning = state.isTimerRunning.value;
      final double max = labels.length - 1.0;
      final divisions = labels.length - 1;

      return Obx(() {
        return Slider(
            value: state.indexSpeedSlider.value.toDouble(),
            thumbColor: thumb,
            activeColor: active,
            inactiveColor: inactive,
            max: max,
            min: min,
            divisions: divisions,
            label: '${state.speedDeger.value}',
            onChanged: (value) {
              if (!isRunning) {
                state.setIndexSpeed(value.toInt());
              } else {
                null;
              }
            });
      });
    } else {
      final isRunning = state.isTimerRunning.value;
      final labels = ['1', '2'];
      final double min = 0;
      final double max = labels.length - 1.0;
      final divisions = labels.length - 1;
      return Obx(() {
        return Container(
          width: 80,
          child: Slider(
              thumbColor: thumb,
              inactiveColor: inactive,
              activeColor: active,
              value: state.indexWordSlider.value.toDouble(),
              max: max,
              min: min,
              divisions: divisions,
              label: '${state.wordDeger.value}',
              onChanged: (value) {
                if (!isRunning) {
                  state.setIndexWord(value.toInt());
                } else {
                  null;
                }
              }),
        );
      });
    }
  }
}
