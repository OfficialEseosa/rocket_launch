import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _launching = false; // triggers full-screen animation
  late AnimationController _controller;
  late Animation<double> _rocketAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rocketAnimation = Tween<double>(begin: 0, end: -300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _launching = false;
        });
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    if (_counter < 100) {
      setState(() {
        _counter++;
      });
      _checkLaunch();
    }
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _checkLaunch() {
    if (_counter == 100 && !_launching) {
      setState(() {
        _launching = true;
      });
      _controller.forward();
    }
  }

  Color _getStatusColor() {
    if (_counter == 0) return Colors.red;
    if (_counter <= 50) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rocket Launch Controller')),
      body: Stack(
        children: [
          // Main UI
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  color: _getStatusColor(),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _counter == 100 ? 'LIFTOFF!' : '$_counter',
                    style: const TextStyle(
                        fontSize: 50.0, color: Colors.white),
                  ),
                ),
              ),
              Slider(
                min: 0,
                max: 100,
                value: _counter.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _counter = value.toInt();
                  });
                  _checkLaunch();
                },
                activeColor: Colors.blue,
                inactiveColor: Colors.red,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    child: const Text('Ignite'),
                  ),
                  ElevatedButton(
                    onPressed: _decrementCounter,
                    child: const Text('Decrement'),
                  ),
                  ElevatedButton(
                    onPressed: _resetCounter,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),

          // Full-screen rocket launch animation
          if (_launching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rocketAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _rocketAnimation.value),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/rocket.jpeg', // <-- updated to JPEG
                        width: 100,
                      ),
                    ),
                    const Positioned(
                      bottom: 50,
                      child: Text(
                        "🚀 LIFTOFF! 🚀",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}