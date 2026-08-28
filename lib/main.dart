import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'consumo_agua.dart';
import 'gerenciar_consumo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool temaEscuro = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: temaEscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: SplashScreen(
        temaEscuro: temaEscuro,
        onTemaAlterado: () {
          setState(() {
            temaEscuro = !temaEscuro;
          });
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  final bool temaEscuro;
  final VoidCallback onTemaAlterado;

  const SplashScreen({
    super.key,
    required this.temaEscuro,
    required this.onTemaAlterado,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, size: 110, color: Colors.blue),

                const SizedBox(height: 25),

                const Text(
                  'Consumo de Água',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Controle sua hidratação diariamente',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: onTemaAlterado,
                  icon: Icon(temaEscuro ? Icons.light_mode : Icons.dark_mode),
                  label: Text(temaEscuro ? 'Tema claro' : 'Tema escuro'),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GerenciarConsumo gerenciar = GerenciarConsumo();

  List<ConsumoAgua> consumos = [];

  @override
  void initState() {
    super.initState();
    carregarConsumos();
  }

  Future<void> carregarConsumos() async {
    final lista = await gerenciar.listar();

    setState(() {
      consumos = lista;
    });
  }

  Future<void> salvarDados() async {
    await gerenciar.salvar(consumos);
  }

  void adicionarConsumo() {
    final dataController = TextEditingController();
    final quantidadeController = TextEditingController();
    final pesoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar consumo'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    hintText: 'Ex: 26/08/2026',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade em ml',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Peso atual em kg',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () async {
                if (dataController.text.isEmpty ||
                    quantidadeController.text.isEmpty ||
                    pesoController.text.isEmpty) {
                  return;
                }

                final consumo = ConsumoAgua(
                  data: dataController.text,
                  quantidadeEmMl: double.parse(
                    quantidadeController.text.replaceAll(',', '.'),
                  ),
                  pesoAtualKg: double.parse(
                    pesoController.text.replaceAll(',', '.'),
                  ),
                );

                setState(() {
                  consumos.add(consumo);
                });

                await salvarDados();

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void editarConsumo(int index) {
    final consumo = consumos[index];

    final dataController = TextEditingController(text: consumo.data);

    final quantidadeController = TextEditingController(
      text: consumo.quantidadeEmMl.toString(),
    );

    final pesoController = TextEditingController(
      text: consumo.pesoAtualKg.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar consumo'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(labelText: 'Data'),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade em ml',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Peso atual em kg',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () async {
                setState(() {
                  consumos[index] = ConsumoAgua(
                    data: dataController.text,
                    quantidadeEmMl: double.parse(
                      quantidadeController.text.replaceAll(',', '.'),
                    ),
                    pesoAtualKg: double.parse(
                      pesoController.text.replaceAll(',', '.'),
                    ),
                  );
                });

                await salvarDados();

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void excluirConsumo(int index) async {
    setState(() {
      consumos.removeAt(index);
    });

    await salvarDados();
  }

  double get totalConsumido {
    if (consumos.isEmpty) {
      return 0;
    }

    return consumos.fold(0, (total, consumo) => total + consumo.quantidadeEmMl);
  }

  double get metaDiaria {
    if (consumos.isEmpty) {
      return 0;
    }

    return consumos.last.metaDiaria;
  }

  double get porcentagemMeta {
    if (metaDiaria == 0) {
      return 0;
    }

    return (totalConsumido / metaDiaria) * 100;
  }

  List<ChartData> get dadosGrafico {
    return consumos.map((consumo) {
      return ChartData(consumo.data, consumo.quantidadeEmMl);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consumo de Água',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: adicionarConsumo,
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: carregarConsumos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // =========================
            // CARDS
            // =========================
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: Colors.blue,
                            size: 35,
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Consumido',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${totalConsumido.toStringAsFixed(0)} ml',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.flag, color: Colors.green, size: 35),

                          const SizedBox(height: 8),

                          const Text(
                            'Meta diária',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${metaDiaria.toStringAsFixed(0)} ml',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text(
                      'Meta diária atingida',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${porcentagemMeta.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: (porcentagemMeta / 100).clamp(0.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Registros de consumo',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (consumos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: Text('Nenhum consumo registrado.')),
              ),

            ...consumos.asMap().entries.map((entry) {
              final index = entry.key;
              final consumo = entry.value;

              return Card(
                child: ListTile(
                  onTap: () {
                    editarConsumo(index);
                  },

                  leading: const CircleAvatar(child: Icon(Icons.water_drop)),

                  title: Text(
                    consumo.data,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    '${consumo.quantidadeEmMl.toStringAsFixed(0)} ml'
                    '\n'
                    'Peso: ${consumo.pesoAtualKg.toStringAsFixed(1)} kg'
                    '\n'
                    'Meta: ${consumo.porcentagemMeta.toStringAsFixed(1)}%',
                  ),

                  isThreeLine: true,

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      excluirConsumo(index);
                    },
                  ),
                ),
              );
            }),

            const SizedBox(height: 25),

            const Text(
              'Relatório de consumo',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            if (consumos.isNotEmpty)
              SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Data')),

                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Quantidade (ml)'),
                  ),

                  tooltipBehavior: TooltipBehavior(enable: true),

                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: dadosGrafico,

                      xValueMapper: (ChartData data, _) => data.data,

                      yValueMapper: (ChartData data, _) => data.quantidade,

                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),

            if (consumos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text('Adicione registros para visualizar o gráfico.'),
                ),
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String data;
  final double quantidade;

  ChartData(this.data, this.quantidade);
}
