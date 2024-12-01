import 'package:co2tester/presentation/pages/map_page/widgets/legend_item.dart';
import 'package:flutter/material.dart';

class LegendContainer extends StatelessWidget {
  const LegendContainer({
    super.key,
    required this.height,
    required this.width,
    required this.isWideScreen,
  });

  final double height;
  final double width;
  final bool isWideScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height * .25,
      width: width * .25,
      decoration: const BoxDecoration(
        color: Color(0xFF3B3838),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Indicadores',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              isWideScreen
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 15,
                        children: [
                          LegendItem(
                            color: Colors.green,
                            label: 'Seguro',
                          ),
                          LegendItem(
                            color: Colors.yellow,
                            label: 'Precaución',
                          ),
                          LegendItem(
                            color: Colors.red,
                            label: 'Peligro',
                          ),
                        ],
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LegendItem(
                          color: Colors.green,
                          label: 'Seguro',
                        ),
                        LegendItem(
                          color: Colors.yellow,
                          label: 'Precaución',
                        ),
                        LegendItem(
                          color: Colors.red,
                          label: 'Peligro',
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
