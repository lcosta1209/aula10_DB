import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:provider/provider.dart';
import 'package:exdb/view/lista_cliente.dart';
import 'package:exdb/viewmodel/cliente_viewmodel.dart';
import 'package:exdb/repository/cliente_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exdb/view/login_page.dart';
import 'package:exdb/db/persistencia_helper.dart';
import 'package:exdb/db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final usaFirebase = await PersistenciaHelper.getUsaFirebase();

  if (usaFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase inicializado');
  } else {
    await DatabaseHelper.instance.database;
    debugPrint('💾 SQLite inicializado');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ClienteViewModel(ClienteRepository()),
        ),
      ],
      child: MyApp(usaFirebase: usaFirebase),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool usaFirebase;

  const MyApp({super.key, required this.usaFirebase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Clientes (MVVM)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: usaFirebase ? const _FirebaseHomeDecider() : const ListaClientesPage(),
    );
  }
}

class _FirebaseHomeDecider extends StatelessWidget {
  const _FirebaseHomeDecider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show login page when not signed in; otherwise show the main list.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        return const ListaClientesPage();
      },
    );
  }
}
