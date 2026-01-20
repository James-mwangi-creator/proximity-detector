import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proximity Detector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4285F4)),
        useMaterial3: true,
      ),
      home: const ProximityDetectorScreen(),
    );
  }
}

class ProximityDetectorScreen extends StatefulWidget {
  const ProximityDetectorScreen({super.key});

  @override
  State<ProximityDetectorScreen> createState() => _ProximityDetectorScreenState();
}

class _ProximityDetectorScreenState extends State<ProximityDetectorScreen> {
  double _proximityValue = 0.0;
  late Stream<ProximityEvent> _proximityStream;

  @override
  void initState() {
    super.initState();
    _proximityStream = proximityEvents;
    _proximityStream.listen((ProximityEvent event) {
      setState(() {
        _proximityValue = event.proximity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximity Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _proximityValue < 5 ? Icons.warning_amber_rounded : Icons.check_circle,
              color: _proximityValue < 5 ? Colors.red : Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              _proximityValue < 5 ? 'OBJECT NEARBY!' : 'NO OBJECT DETECTED',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _proximityValue < 5 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Distance: ${_proximityValue.toStringAsFixed(2)} cm',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bring an object near your phone\'s proximity sensor'),
              duration: Duration(seconds: 3),
            ),
          );
        },
        child: const Icon(Icons.info),
      ),
    );
  }
}