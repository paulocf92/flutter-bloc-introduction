import 'package:flutter/material.dart';

import '../models/endereco_model.dart';
import '../repositories/cep_repository.dart';
import '../repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  final formkey = GlobalKey<FormState>();
  bool loading = false;

  //controladora
  final cepEC = TextEditingController();
//toda controladora PRECISA ser encerrada ou pode gerar um escape de memória
  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar CEP"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: cepEC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "CEP Obrigatório";
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final valid = formkey.currentState?.validate() ?? false;
                      if (valid) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          final endereco =
                              await cepRepository.getCep(cepEC.text);
                          setState(() {
                            loading = false;
                            enderecoModel = endereco;
                          });
                        } catch (e) {
                          setState(() {
                            loading = false;
                            enderecoModel = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Erro ao buscar Endereço")),
                          );
                        }
                      }
                    },
                    child: const Text("Buscar"),
                  ),
                  //const Text("Logradouro, Complemento, Cep")
                  Visibility(
                      visible: loading, child: CircularProgressIndicator()),
                  Visibility(
                    visible: enderecoModel != null,
                    child: Text(
                      "Logradouro:${enderecoModel?.logradouro} \nComplemento: ${enderecoModel?.complemento} \nCEP:${enderecoModel?.cep}",
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
