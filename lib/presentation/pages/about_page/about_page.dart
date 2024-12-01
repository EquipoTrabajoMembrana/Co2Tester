import 'package:co2tester/presentation/pages/map_page/widgets/legend_container.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isWideScreen = width > 600;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.5,
                    child: Image.asset(
                      'assets/images/escuela.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x63000000),
                            Color(0xAA000000),
                          ]),
                    ),
                    width: width,
                    height: height * 0.5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.02),
                    child: Column(
                      children: [
                        Text(
                          'CO2Tester: Mejora la calidad del aire de la UTM',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Un grupo de estudiantes en colaboracion con un profesor ha desarrollado este proyecto para monitorear los niveles de CO2 en la Universidad Teconologica Metropolitana, mejorando el ambiente y asegurando un espacio más seguro.',
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: Text(
                  '\n ¿Por qué es importante este proyecto? \n',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: Text(
                  'El aire en espacios cerrados puede deteriorarse rapidamente, elevando los niveles de CO2 y causando sintomas como fatiga, dolores de cabeza ocasionando problemas de concentracion, Este sistema te ayudará a saber cuando ventilar el espacio. \n',
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: Text(
                  '¿Como funciona? \n',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Monitoreamos los niveles de CO2 en tiempo real, además utilizamos indicadores visuales para informar cuando es necesario tomar precauciones. \n',
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              LegendContainer(
                height: height,
                width: width,
                isWideScreen: isWideScreen,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: Text(
                  '\n ¿Como te beneficia?',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: Text(
                  'Este sistema es util para profesores y estudiantes que buscan asegurar un ambiente saludable. \n',
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
