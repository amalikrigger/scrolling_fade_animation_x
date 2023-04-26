import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadingScroller(
        builder: (context, scrollController) => ListView.builder(
          controller: scrollController,
          itemCount: 20,
          itemBuilder: (context, index) => GlassBox(
            index: index,
          ),
        ),
      ),
    );
  }
}

class GlassBox extends StatelessWidget {
  const GlassBox({Key? key, required this.index}) : super(key: key);

  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: Container(
              height: 250,
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black45),
              child: Center(
                child: Text(
                  index.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FadingScroller extends StatefulWidget {
  final Widget Function(BuildContext context, ScrollController scrollController)
      builder;

  final ScrollController? scrollController;

  const FadingScroller({Key? key, required this.builder, this.scrollController})
      : super(key: key);

  @override
  State<FadingScroller> createState() => _FadingScrollerState();
}

class _FadingScrollerState extends State<FadingScroller> {
  late final ScrollController _scrollController;

  bool _overlayIsVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_handleScrollUpdate);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      // Only dispise if it was _us_ creating the controller.
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _handleScrollUpdate() {
    if (_scrollController.position.extentAfter <= 0) {
      setState(() {
        _overlayIsVisible = false;
      });
    } else {
      setState(() {
        _overlayIsVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(context, _scrollController),
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _overlayIsVisible ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00FFFFFF),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [
                    0.8,
                    1,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
