import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: const MyHomePage(title: 'Animation Bottom Nav Bar'),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    body: Stack(
      children: [
        IndexedStack(
          index: index,
          children: [
            'home',
            'favorite',
            'settings',
            'profile',
          ].map(mainUIWidget).toList(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBarAnimation(
              pageIndex: index,
              onIndexChanged: (newIndex) => setState(() => index = newIndex),
            ),
          ),
        ),
      ],
    ),
  );
}

class BottomNavBarAnimation extends StatefulWidget {
  const BottomNavBarAnimation({
    super.key,
    required this.pageIndex,
    required this.onIndexChanged,
  });
  final int pageIndex;
  final ValueChanged<int> onIndexChanged;
  @override
  State<BottomNavBarAnimation> createState() => _BottomNavBarAnimationState();
}

class _BottomNavBarAnimationState extends State<BottomNavBarAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> controllers;
  final icons = [Icons.home, Icons.favorite, Icons.settings, Icons.person];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      icons.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2250),
      ),
    );
    controllers[0].repeat();
    controllers[0].forward();
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void handleAnimationBtmBar(int index) {
    for (var i = 0; i < controllers.length; i++) {
      if (i == index) {
        controllers[i].reset();
        controllers[i].forward();
      } else {
        controllers[i].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    height: 45,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(32),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        icons.length,
        (i) => GestureDetector(
          onTap: () {
            widget.onIndexChanged(i);
            handleAnimationBtmBar(i);
          },
          child: Animate(
            controller: controllers[i],
            autoPlay: false,
            effects: [
              Effect(duration: 1950.ms),
              Effect(delay: 350.ms, duration: 1500.ms),
              ScaleEffect(end: const Offset(1, 1), curve: Curves.easeOutBack),
              MoveEffect(end: const Offset(0, -5)),
              ElevationEffect(
                end: controllers[i].isForwardOrCompleted ? 30 : 0,
              ),
            ],
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: i == widget.pageIndex
                    ? Colors.blue.shade50
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icons[i],
                color: i == widget.pageIndex ? Colors.blue : Colors.grey,
                size: 30,
              ),
            ),
          ),
        ),
      ).expandSpacing(50),
    ),
  );
}

extension on List<Widget> {
  List<Widget> expandSpacing(double spacing) {
    if (isEmpty) return [];
    final spaced = <Widget>[];
    for (var i = 0; i < length; i++) {
      spaced.add(this[i]);
      if (i != length - 1) spaced.add(SizedBox(width: spacing));
    }
    return spaced;
  }
}

Widget mainUIWidget(String title) =>
    Center(child: Text(title, style: const TextStyle(fontSize: 30)));
