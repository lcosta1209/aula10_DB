import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cidade_viewmodel.dart';

// Tela de busca de cidade que será exibida como popup
class BuscaCidadePage extends StatefulWidget {
  const BuscaCidadePage({super.key});

  @override
  State<BuscaCidadePage> createState() => _BuscaCidadePageState();
}

class _BuscaCidadePageState extends State<BuscaCidadePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _buscarCidades(String filtro) {
    context.read<CidadeViewModel>().loadCidades(filtro);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecionar Cidade'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            // Campo de busca simples
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Digite para filtrar...',
                border: OutlineInputBorder(),
              ),
              onChanged: _buscarCidades,
            ),
            const SizedBox(height: 16),
            
            // Lista de cidades
            Expanded(
              child: Consumer<CidadeViewModel>(
                builder: (context, viewModel, child) {
                  final cidades = viewModel.cidades;
                  
                  if (cidades.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma cidade encontrada'),
                    );
                  }

                  return ListView.builder(
                    itemCount: cidades.length,
                    itemBuilder: (context, index) {
                      final cidade = cidades[index];
                      return ListTile(
                        title: Text(cidade.nomeCidade),
                        onTap: () {
                          Navigator.of(context).pop(cidade);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}