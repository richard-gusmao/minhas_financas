import 'package:minhas_financas/model/base_dados.dart';

class Saida {
  int? id;
  String? nome;
  double? valor;
  DateTime? dataHora;

  Saida({this.nome, this.valor, this.dataHora, this.id});
  Future<void> adicionar() async {
    final db = await BaseDados().conectar();

    await db.insert("saida", {
      'nome': nome,
      'valor': valor,
      'dataHora': dataHora.toString(),
    });
  }

  Future<void> eliminar() async {
    final db = await BaseDados().conectar();
    await db.delete("saida", where: 'id = ?', whereArgs: [id]);
  }

  Future<List> obterTodos() async {
    final db = await BaseDados().conectar();
    List data = await db.query(
      "saida",
      orderBy: 'id DESC',
    );
    return data;
  }
}
