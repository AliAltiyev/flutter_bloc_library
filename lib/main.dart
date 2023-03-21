import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
import 'package:bloc/bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NamesCubit _namesCubit;

  @override
  void initState() {
    super.initState();
    _namesCubit = NamesCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: _namesCubit.stream,
              builder: ((context, snapshot) {
                final button = TextButton(
                    onPressed: () => _namesCubit.getRandomName(),
                    child: const Text('Pick random name'));
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return button;

                  case ConnectionState.waiting:
                    return button;
                  case ConnectionState.active:
                    return Column(
                      children: [Text(snapshot.data.toString()), button],
                    );
                  case ConnectionState.done:
                    return const SizedBox();
                }
              })),
        ],
      )),
    );
  }

  @override
  void dispose() {
    _namesCubit.close();

    super.dispose();
  }
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void getRandomName() => emit(data.elementGetter());
}

//!Data for block
final data = ['Foo', 'Kate', 'Loly', 'David', 'Jone'];

//!Element getter from Iterable Extension
extension RandomElementGetter<T> on Iterable<T> {
  elementGetter() => elementAt(math.Random().nextInt(length));
}
