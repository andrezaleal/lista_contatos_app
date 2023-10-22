// ignore_for_file: use_rethrow_when_possible

import 'package:lista_contatos/model/contatos_model.dart';
import 'package:lista_contatos/repositories/custom_dio.dart';

class ContatosRepository {
  final _custonDio = CustonDio();

  ContatosRepository();

  Future<ContatosModel> readContatos() async {
    var url = "/Contatos";
    var result = await _custonDio.dio.get(url);
    return ContatosModel.fromJson(result.data);
  }

  Future<void> create(ContatoModel contatoModel) async{
    try {
      await _custonDio.dio.post("/Contatos", data: contatoModel.toJsonEndpoint());
    } catch (e) {
      throw(e);
    }
  }

  Future<void> update(ContatoModel contatoModel) async{
    try {
      await _custonDio.dio.put("/Contatos/${contatoModel.objectId}", data: contatoModel.toJsonEndpoint());
    } catch (e) {
      throw(e);
    }
  }

  Future<void> delete(String objectId) async{
    try {
      await _custonDio.dio.delete("/Contatos/$objectId");
    } catch (e) {
      throw(e);
    }
  }

}
