class Cliente {
  String id;
  String nome;
  String email;
  String tipo;

  Cliente({this.id, this.nome, this.email, this.tipo});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nome = json['NOME'];
    email = json['EMAIL'];
    tipo = json['TIPO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['NOME'] = this.nome;
    data['EMAIL'] = this.email;
    data['TIPO'] = this.tipo;
    return data;
  }
}
