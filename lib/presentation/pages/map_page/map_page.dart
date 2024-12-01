import 'package:co2tester/presentation/pages/map_page/widgets/details_bottom_sheet.dart';
import 'package:co2tester/presentation/pages/map_page/widgets/legend_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final LatLng _initialLocation = const LatLng(20.9397753, -89.6154313);
  int? _selectedMarkerId; // Variable para rastrear el punto seleccionado.

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isWideScreen = width > 300;

    return Stack(
      children: [
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: Supabase.instance.client.from('devices').stream(
              primaryKey: ['device_id']).order('last_update', ascending: true),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final devices = snapshot.data!;
            List<Marker> markers = devices.map((device) {
              Color markerColor;
              if (device['co2_level'] <= 600) {
                markerColor = Colors.green;
              } else if (device['co2_level'] <= 1000) {
                markerColor = Colors.yellow;
              } else {
                markerColor = Colors.red;
              }

              final isSelected = _selectedMarkerId == device['device_id'];

              return Marker(
                point: LatLng(
                  device['latitude'],
                  device['longitude'],
                ),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedMarkerId = device['device_id'];
                    });

                    final supabaseData = await Supabase.instance.client
                        .from('devices')
                        .select()
                        .eq('name', device['name']);

                    if (context.mounted) {
                      showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: false,
                        builder: (context) {
                          return DetailsBottomSheet(
                            id: device['device_id'],
                            co2Level: device['co2_level'],
                            humidityLevel: device['humidity_level'],
                            lastUpdated: device['last_update'],
                            name: device['name'],
                            supabaseData:
                                List<Map<String, dynamic>>.from(supabaseData),
                          );
                        },
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: isSelected ? 50 : 30,
                    width: isSelected ? 50 : 30,
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                    child: const Icon(Icons.thermostat),
                  ),
                ),
              );
            }).toList();

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialLocation,
                initialZoom: 18,
                minZoom: 10,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  tileProvider: CancellableNetworkTileProvider(),
                  tileBuilder: _darkModeTileBuilder,
                ),
                MarkerLayer(markers: markers),
              ],
            );
          },
        ),
        Positioned(
          top: 30,
          right: 10,
          child: LegendContainer(
            height: height,
            width: width,
            isWideScreen: isWideScreen,
          ),
        ),
        Positioned(
          bottom: 8,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              _mapController.move(_initialLocation, 18.0);
            },
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}

Widget _darkModeTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      -0.2126, -0.7152, -0.0722, 0, 255, // Red channel
      -0.2126, -0.7152, -0.0722, 0, 255, // Green channel
      -0.2126, -0.7152, -0.0722, 0, 255, // Blue channel
      0, 0, 0, 1, 0, // Alpha channel
    ]),
    child: tileWidget,
  );
}
