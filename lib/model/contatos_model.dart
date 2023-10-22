class ContatosModel {
  List<ContatoModel> contato = [];

  ContatosModel(this.contato);

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contato = <ContatoModel>[];
      json['results'].forEach((v) {
        contato.add(ContatoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = contato.map((v) => v.toJson()).toList();
    return data;
  }
}

class ContatoModel {
  String objectId = "";
  String nome = "";
  String pathPhoto = "";
  String number = "";

  ContatoModel(
    this.objectId,
    this.nome,
    this.pathPhoto,
    this.number,
  );
   ContatoModel.criar(
    this.nome,
    this.pathPhoto,
    this.number,
  );

  ContatoModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    pathPhoto = json['path_photo'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['path_photo'] = pathPhoto;
    data['number'] = number;
    return data;
  }

   Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['path_photo'] = pathPhoto;
    data['number'] = number;
    return data;
  }
}
