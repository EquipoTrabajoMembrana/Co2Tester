import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsDialog {
  Future<void> show({
    required BuildContext context,
    required int id,
    required double co2Level,
    required double humidityLevel,
    required String lastUpdated,
    required String name,
  }) async {
    final parsedDate = DateTime.tryParse(lastUpdated);
    final formattedDate = parsedDate != null
        ? DateFormat('dd/MM/yyyy').format(parsedDate)
        : 'Fecha no disponible';
    final formattedHour = parsedDate != null
        ? DateFormat('HH:mm').format(parsedDate)
        : 'Fecha no disponible';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dispositivo: $name'),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * .50,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('El nivel de CO2 es: $co2Level'),
                  Text('El nivel de Humedad es: $humidityLevel'),
                  Text(
                    'La ultima actualizacion fue: $formattedDate a las $formattedHour',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
