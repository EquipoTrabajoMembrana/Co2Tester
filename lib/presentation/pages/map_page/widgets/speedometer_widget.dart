import 'package:co2tester/presentation/pages/map_page/widgets/details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedoMeter extends StatelessWidget {
  const SpeedoMeter({
    super.key,
    required this.widget,
    required this.theme,
  });

  final DetailsBottomSheet widget;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 100,
          maximum: 1400,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 100,
              endValue: 600,
              color: Colors.green,
            ),
            GaugeRange(
              startValue: 601,
              endValue: 1000,
              color: Colors.yellow,
            ),
            GaugeRange(
              startValue: 1001,
              endValue: 1400,
              color: Colors.red,
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(value: widget.co2Level),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                '${widget.co2Level.toStringAsFixed(1)} ppm',
                style: theme.textTheme.titleMedium,
              ),
              angle: 90,
              positionFactor: 0.8,
            ),
          ],
        ),
      ],
    );
  }
}
