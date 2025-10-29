import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:exdb/view/lista_cliente.dart';
import 'package:exdb/viewmodel/cliente_viewmodel.dart';
import 'package:exdb/repository/cliente_repository.dart';
import 'package:exdb/db/persistencia_helper.dart';
import 'package:exdb/db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final usaFirebase = await PersistenciaHelper.getUsaFirebase();

  if (usaFirebase) {
    await Firebase.initializeApp();
    print(' Firebase inicializado');
  } else {
    await DatabaseHelper.instance.database;
    print(' SQLite inicializado');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ClienteViewModel(ClienteRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Clientes (MVVM)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaClientesPage(),
    );
  }
}
