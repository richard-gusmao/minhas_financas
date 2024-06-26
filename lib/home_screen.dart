import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_financas/components/dados_lista.dart';
import 'package:minhas_financas/model/entrada_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/saida_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double saldoDisponivel = 0;
  String alert = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  int pageIndex = 0;
  List entradaData = [];
  List saidaData = [];

  Future<void> getDataEntrada() async {
    List data = await Entrada().obterTodos();
    setState(() {
      entradaData = data;
    });
  }

  Future<void> getDataSaida() async {
    List data = await Saida().obterTodos();
    setState(() {
      saidaData = data;
    });
  }

  void getSaldo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      saldoDisponivel = (prefs.getDouble('counter') ?? 0);
    });
  }

  void setSaldo(double valor, int tipo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('counter', valor);
    setState(() {
      if (tipo == 1) {
        saldoDisponivel += valor;
      }
      if (tipo == 2) {
        saldoDisponivel -= valor;
      }
    });
  }

  void salvar() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (pageIndex == 1) {
      await Entrada(
              nome: _nameController.text,
              valor: double.parse(_valueController.text),
              dataHora: DateTime.now())
          .adicionar();
      await getDataEntrada();
    }
    if (pageIndex == 2) {
      await Saida(
              nome: _nameController.text,
              valor: double.parse(_valueController.text),
              dataHora: DateTime.now())
          .adicionar();
      await getDataSaida();
    }
    setSaldo(double.parse(_valueController.text), pageIndex);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    setState(() {
      alert = "";
    });
    _nameController.clear();
    _valueController.clear();
  }

  void _handleTabSelection() {
    setState(() {
      pageIndex = _tabController.index + 1;
    });
  }

  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: pageIndex);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    getSaldo();
    getDataEntrada();
    getDataSaida();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the TabController properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 3, 100, 126),
        title: const Text("Minhas Finanças"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Saldo Disponivel",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              NumberFormat.decimalPattern().format(saldoDisponivel),
              style: TextStyle(
                color: saldoDisponivel > 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            Container(
              height: 40,
              child: TabBar(
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                controller: _tabController, // Set the TabController
                tabs: const [
                  Tab(
                    text: 'Entradas',
                  ),
                  Tab(text: 'Saidas'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController, // Set the TabController
                children: [
                  Dados(
                    data: entradaData,
                    tipo: 1,
                  ),
                  Dados(
                    data: saidaData,
                    tipo: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            backgroundColor: Colors.red,
            shape: const CircleBorder()),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Minhas Finanças'),
              content: StatefulBuilder(builder: (
                BuildContext context,
                StateSetter setState,
              ) {
                return Container(
                  height: 400,
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: "Nome",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _valueController,
                        decoration: const InputDecoration(
                          hintText: "Valor",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      alert.isNotEmpty
                          ? Text(
                              alert,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : const SizedBox(
                              height: 1,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if ((_nameController.text.isNotEmpty ||
                                _valueController.text.isNotEmpty)) {
                              try {
                                double.parse(_valueController.text);
                                Navigator.of(context).pop();
                                salvar();
                              } catch (err) {
                                setState(() {
                                  alert = "Valor Errado";
                                });
                              }
                            } else {
                              setState(() {
                                alert = "Preenha os Campos";
                              });
                            }
                          },
                          child: const Text(
                            "Salvar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
