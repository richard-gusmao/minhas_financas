import 'package:minhas_financas/model/base_dados.dart';

class Entrada {
  int? id;
  String? nome;
  double? valor;
  DateTime? dataHora;

  Entrada({this.nome, this.valor, this.dataHora, this.id});
  Future<void> adicionar() async {
    final db = await BaseDados().conectar();
    await db.insert("entrada", {
      'nome': nome,
      'valor': valor,
      'dataHora': dataHora.toString(),
    });
  }

  Future<List> obterTodos() async {
    final db = await BaseDados().conectar();
    List data = await db.query(
      "entrada",
      orderBy: 'id DESC',
    );
    return data;
  }
}
