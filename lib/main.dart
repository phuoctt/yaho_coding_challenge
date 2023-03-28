import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaho/bloc/contact/contact_cubit.dart';

import 'bloc/app/app_cubit.dart';
import 'bloc/app/app_state.dart';
import 'features/screens/contact.dart';
import 'package:yaho/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = App();
  await app.setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>.value(value: AppCubit(app.userLocalStorage)),
        BlocProvider<ContactCubit>.value(
            value: ContactCubit(app.userLocalStorage)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        Brightness themeMode = state.theme ?? Brightness.light;
        return MaterialApp(
          title: 'Yaho',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: themeMode,
            primarySwatch: Colors.orange,
          ),
          home: ContactScreen(themeMode: themeMode),
        );
      },
    );
  }
}
