import 'package:flutter/material.dart';
import '../utils/persistence_mode.dart';

class ConfiguracaoPage extends StatefulWidget {
  const ConfiguracaoPage({super.key});

  @override
  State<ConfiguracaoPage> createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  bool _useFirebase = false;

  @override
  void initState() {
    super.initState();
    _loadPersistenceMode();
  }

  Future<void> _loadPersistenceMode() async {
    _useFirebase = await PersistenceMode.getUseFirebase();
    setState(() {});
  }

  Future<void> _togglePersistenceMode(bool value) async {
    await PersistenceMode.setUseFirebase(value);
    setState(() => _useFirebase = value);
    // Reinicialize o ViewModel ou reinicie o app para aplicar a mudança
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuração')),
      body: Center(
        child: SwitchListTile(
          title: const Text('Usar Firebase'),
          value: _useFirebase,
          onChanged: _togglePersistenceMode,
        ),
      ),
    );
  }
}