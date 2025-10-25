import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/lista_cliente.dart';
import 'viewmodel/cliente_viewmodel.dart';
import 'repository/cliente_repository.dart';
import 'repository/cliente_repository_firebase.dart';
import 'db/db_helper.dart';
import 'utils/persistence_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Antes do Firebase.initializeApp'); // Debug
  await Firebase.initializeApp();
  print('Depois do Firebase.initializeApp'); // Debug

  final useFirebase = await PersistenceMode.getUseFirebase();
  print('useFirebase: $useFirebase'); // Debug

  if (!useFirebase) {
    print('Inicializando SQLite'); // Debug
    await DatabaseHelper.instance.database;
    print('SQLite inicializado'); // Debug
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ClienteViewModel(
            useFirebase
                ? ClienteRepositoryFirebase()
                : ClienteRepository(),
          ),
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
      title: 'Cadastro de Clientes (MVVM + SQLite)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaClientesPage(),
    );
  }
}
