import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_introduction/pages/state_single_class/home_single_class_controller.dart';
import 'package:flutter_bloc_introduction/pages/state_single_class/home_state.dart';

class HomeSinglePage extends StatefulWidget {
  const HomeSinglePage({super.key});

  @override
  State<HomeSinglePage> createState() => _HomeSinglePageState();
}

class _HomeSinglePageState extends State<HomeSinglePage> {
  final homeController = HomeSingleClassController();
  final formkey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeSingleClassController, HomeState>(
      bloc: homeController,
      listener: (context, state) {
        if (state.status == HomeStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro ao buscar Endereço")),
          );
        }
      },
      child: Scaffold(
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
                          homeController.findCep(cepEC.text);
                        }
                      },
                      child: const Text("Buscar"),
                    ),
                    BlocBuilder<HomeSingleClassController, HomeState>(
                      bloc: homeController,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.status == HomeStatus.loading,
                          child: const CircularProgressIndicator(),
                        );
                      },
                    ),
                    BlocBuilder<HomeSingleClassController, HomeState>(
                      bloc: homeController,
                      builder: (context, state) {
                        if (state.status == HomeStatus.loaded) {
                          return Text(
                            "Logradouro:${state.enderecoModel?.logradouro} \nComplemento: ${state.enderecoModel?.complemento} \nCEP:${state.enderecoModel?.cep}",
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
