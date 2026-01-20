import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
  double _proximityValue = 10.0;
  Timer? _timer;
  final Random _random = Random();
  bool _isSimulating = false;

  @override
  void initState() {
    super.initState();
    // Simulate proximity sensor readings
    _startSimulation();
  }

  void _startSimulation() {
    _isSimulating = true;
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isSimulating) {
        setState(() {
          // Simulate random proximity values between 0 and 15 cm
          _proximityValue = _random.nextDouble() * 15;
        });
      }
    });
  }

  void _stopSimulation() {
    _isSimulating = false;
    setState(() {
      _proximityValue = 10.0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Proximity Detector'),
        actions: [
          IconButton(
            icon: Icon(_isSimulating ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                if (_isSimulating) {
                  _stopSimulation();
                } else {
                  _startSimulation();
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _proximityValue < 5 
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  border: Border.all(
                    color: _proximityValue < 5 ? Colors.red : Colors.green,
                    width: 4,
                  ),
                ),
                child: Icon(
                  _proximityValue < 5 ? Icons.warning_amber_rounded : Icons.check_circle,
                  color: _proximityValue < 5 ? Colors.red : Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 30),
              
              // Status text
              Text(
                _proximityValue < 5 ? 'OBJECT NEARBY!' : 'NO OBJECT DETECTED',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _proximityValue < 5 ? Colors.red : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // Distance card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_proximityValue.toStringAsFixed(2)} cm',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Progress indicator
              SizedBox(
                width: double.infinity,
                child: LinearProgressIndicator(
                  value: (_proximityValue / 15).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[200],
                  color: _proximityValue < 5 ? Colors.red : Colors.green,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 40),
              
              // Info card
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isSimulating 
                              ? 'Simulating proximity sensor...\nTap pause to stop'
                              : 'Simulation paused\nTap play to resume',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'This is a proximity detector demo.\n'
                'Real sensors require hardware support.',
              ),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        },
        label: const Text('Info'),
        icon: const Icon(Icons.help_outline),
      ),
    );
  }
}