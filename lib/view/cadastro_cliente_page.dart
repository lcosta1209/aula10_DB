import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cliente.dart';
import '../viewmodel/cliente_viewmodel.dart';

// Tela de cadastro/edição (View)
class CadastroClientePage extends StatefulWidget {
  // Recebe um cliente opcional: se for null => criação; senão => edição
  final Cliente? cliente;
  const CadastroClientePage({super.key, this.cliente});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  // Form key para validação
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos do formulário
  late TextEditingController _cpfController;
  late TextEditingController _nomeController;
  late TextEditingController _idadeController;
  late TextEditingController _dataNascimentoController;
  late TextEditingController _cidadeController;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os valores do cliente (se existir) ou vazios
    _cpfController = TextEditingController(text: widget.cliente?.cpf ?? '');
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _idadeController = TextEditingController(
      text: widget.cliente?.idade.toString() ?? '',
    );
    _dataNascimentoController = TextEditingController(
      text: widget.cliente?.dataNascimento ?? '',
    );
    _cidadeController = TextEditingController(
      text: widget.cliente?.cidadeNascimento ?? '',
    );
  }

  @override
  void dispose() {
    // Libera os controllers
    _cpfController.dispose();
    _nomeController.dispose();
    _idadeController.dispose();
    _dataNascimentoController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  // Função chamada ao salvar (adicionar ou editar)
  Future<void> _salvar() async {
    // Valida o formulário
    if (!_formKey.currentState!.validate()) return;

    // Constrói o objeto Cliente a partir dos campos
    final cliente = Cliente(
      codigo: widget.cliente?.codigo, // manter código ao editar
      cpf: _cpfController.text.trim(),
      nome: _nomeController.text.trim(),
      idade: int.tryParse(_idadeController.text.trim()) ?? 0,
      dataNascimento: _dataNascimentoController.text.trim(),
      cidadeNascimento: _cidadeController.text.trim(),
    );

    // Obtém o ViewModel (não escuta mudanças aqui)
    final vm = Provider.of<ClienteViewModel>(context, listen: false);

    if (widget.cliente == null) {
      // Novo cliente
      await vm.adicionarCliente(cliente);
    } else {
      // Atualiza cliente existente
      await vm.editarCliente(cliente);
    }

    // Volta para a tela anterior
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo CPF
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o CPF' : null,
              ),

              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),

              // Campo Idade
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a idade' : null,
              ),

              // Campo Data de Nascimento
              TextFormField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe a data de nascimento'
                    : null,
              ),

              // Campo Cidade de Nascimento
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade de Nascimento',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a cidade' : null,
              ),

              const SizedBox(height: 20),

              // Botão de salvar
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
