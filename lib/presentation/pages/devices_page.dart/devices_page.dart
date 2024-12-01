import 'package:co2tester/presentation/pages/devices_page.dart/widgets/details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceFuture =
        Supabase.instance.client.rpc('get_latest_devices').select();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Dispositivos'),
      ),
      body: FutureBuilder(
        future: deviceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error: No se pudieron cargar los dispositivos.'),
            );
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(
              child: Text('No hay dispositivos disponibles.'),
            );
          }

          final devices = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final co2Level = device['co2_level'];
              Color co2Color;

              if (co2Level <= 600) {
                co2Color = Colors.green;
              } else if (co2Level <= 1000) {
                co2Color = Colors.yellow;
              } else {
                co2Color = Colors.red;
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: co2Color,
                  child: const Icon(
                    Icons.device_thermostat,
                    color: Colors.white,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(device['name'] ?? 'Dispositivo sin nombre'),
                    Text(
                      'ID: ${device['device_id']}',
                    )
                  ],
                ),
                subtitle: Text('Nivel de CO2: $co2Level'),
                onTap: () {
                  DetailsDialog().show(
                    context: context,
                    id: device['device_id'],
                    co2Level: device['co2_level'],
                    humidityLevel: device['humidity_level'],
                    lastUpdated: device['last_update'],
                    name: device['name'],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
