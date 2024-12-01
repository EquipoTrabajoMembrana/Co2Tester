import 'package:co2tester/presentation/pages/map_page/widgets/speedometer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:to_csv/to_csv.dart' as export_csv;

class DetailsBottomSheet extends StatefulWidget {
  final int id;
  final String name;
  final double co2Level;
  final double humidityLevel;
  final String lastUpdated;
  final List<Map<String, dynamic>> supabaseData;

  const DetailsBottomSheet({
    super.key,
    required this.id,
    required this.name,
    required this.co2Level,
    required this.humidityLevel,
    required this.lastUpdated,
    required this.supabaseData,
  });

  @override
  State<DetailsBottomSheet> createState() => _DetailsBottomSheetState();
}

class _DetailsBottomSheetState extends State<DetailsBottomSheet> {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  List<Map<String, dynamic>> co2DataFull = [];
  List<Map<String, dynamic>> co2DataFiltered = [];

  void filterCo2Data() {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 15));

    co2DataFull = widget.supabaseData
        .where(
          (data) {
            final date = DateTime.tryParse(data['last_update']);
            return data['name'] == widget.name &&
                data['co2_level'] > 0 &&
                date != null &&
                date.isAfter(cutoffDate);
          },
        )
        .map(
          (data) => {
            'date': data['last_update'],
            'level': data['co2_level'],
          },
        )
        .toList();

    co2DataFull.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });

    co2DataFiltered =
        co2DataFull.length > 5 ? co2DataFull.sublist(0, 5) : co2DataFull;
  }

  void exportCo2ToCSV() async {
    if (co2DataFull.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('El historial de CO2 está vacío. No se puede exportar.'),
        ),
      );
      return;
    }

    if (!kIsWeb) {
      var status = await Permission.storage.request();

      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permisos denegados. No se puede exportar.'),
            ),
          );
        }
        return;
      }
    }

    List<String> header = ['Fecha', 'Nivel de CO2'];

    List<List<String>> rows = co2DataFull.map((data) {
      try {
        final dateTime = DateTime.parse(data['date']);
        final formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
        return [formattedDate, data['level'].toString()];
      } catch (_) {
        return ['Fecha inválida', data['level'].toString()];
      }
    }).toList();

    export_csv.myCSV(
      header,
      rows,
      fileName: 'historial_co2_${widget.name}',
      transposeAfterRow: 11,
      emptyRowsConfig: {11: 2},
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Archivo CSV creado exitosamente.')),
      );
    }
  }

  Color getBarColor(double co2Level) {
    if (co2Level <= 600) return Colors.green;
    if (co2Level <= 1000) return Colors.yellow;
    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
    filterCo2Data();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final parsedDate = DateTime.tryParse(widget.lastUpdated);
    final formattedDate = parsedDate != null
        ? DateFormat('dd/MM/yyyy').format(parsedDate)
        : 'Fecha no disponible';
    final formattedHour = parsedDate != null
        ? DateFormat('HH:mm').format(parsedDate)
        : 'Hora no disponible';

    return LayoutBuilder(
      builder: (builder, constraints) {
        return DraggableScrollableSheet(
          key: sheet,
          controller: controller,
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0,
          expand: false,
          snap: true,
          snapSizes: [
            60 / constraints.maxHeight,
            0.5,
          ],
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              width: width,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dispositivo: ${widget.name}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nivel actual de CO2',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SpeedoMeter(
                      widget: widget,
                      theme: theme,
                    ),
                    Text(
                      'El nivel de Humedad es: ${widget.humidityLevel}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'Última actualización: $formattedDate a las $formattedHour \n',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Historial de CO2',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 1400,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < co2DataFiltered.length) {
                                    final date = co2DataFiltered[index]['date'];
                                    final dateTime = DateTime.parse(date);
                                    return Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            DateFormat('MM/dd')
                                                .format(dateTime),
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('HH:mm')
                                                .format(dateTime),
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              fontSize: 8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: co2DataFiltered.asMap().entries.map(
                            (entry) {
                              int index = entry.key;
                              double co2Level = entry.value['level'];
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: co2Level,
                                    color: getBarColor(co2Level),
                                    width: 15,
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: exportCo2ToCSV,
                      child: const Text('Exportar historial a CSV'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
