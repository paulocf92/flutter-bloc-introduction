import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_introduction/pages/state_subclass/home_controller.dart';
import 'package:flutter_bloc_introduction/pages/state_subclass/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();
  final formkey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeController, HomeState>(
      bloc: homeController,
      listener: (context, state) {
        if (state is HomeFailure) {
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
                    BlocBuilder<HomeController, HomeState>(
                      bloc: homeController,
                      builder: (context, state) {
                        return Visibility(
                          visible: state is HomeLoading,
                          child: const CircularProgressIndicator(),
                        );
                      },
                    ),
                    BlocBuilder<HomeController, HomeState>(
                      bloc: homeController,
                      builder: (context, state) {
                        if (state is HomeLoaded) {
                          return Text(
                            "Logradouro:${state.enderecoModel.logradouro} \nComplemento: ${state.enderecoModel.complemento} \nCEP:${state.enderecoModel.cep}",
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
