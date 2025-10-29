import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cliente_viewmodel.dart';
import 'cadastro_cliente_page.dart';
import '../db/persistencia_helper.dart';
import '../viewmodel/cliente_dto.dart';


class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ClienteViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes (MVVM + SQLite/Firebase)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_alt),
            onPressed: () async {
              final usaFirebase = await PersistenciaHelper.getUsaFirebase();
              await PersistenciaHelper.setUsaFirebase(!usaFirebase);

              final novoModo = !usaFirebase ? 'Firebase' : 'SQLite';
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Modo alterado para $novoModo')),
                );
              }

              await vm.loadClientes();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CadastroClientePage()),
              );
              await vm.loadClientes(_searchController.text);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) async {
                await vm.loadClientes(value);
              },
            ),
          ),
          Expanded(
            child: vm.clientes.isEmpty
                ? const Center(child: Text('Nenhum cliente encontrado'))
                : ListView.builder(
                    itemCount: vm.clientes.length,
                    itemBuilder: (context, index) {
                      final dto = vm.clientes[index];
                      return ListTile(
                        title: Text(dto.nome),
                        subtitle: Text(dto.subtitulo),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CadastroClientePage(
                                      clienteDTO: dto,
                                    ),
                                  ),
                                );
                                await vm.loadClientes(_searchController.text);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await vm.removerCliente(dto.codigo!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
