import 'package:aula10/classes/cliente.dart';
import 'package:aula10/pages/home_page.dart';
import 'package:aula10/widgets/widget_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  var _ctrId = TextEditingController();
  var _ctrNome = TextEditingController();
  var _ctrEmail = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  var _isRadioValue;
  var _ocupado = false;
  var _msgErro = '';
  Cliente cliente;

  Future gravarCliente() async {
    try {
      Dio dio = Dio();
      Response response = await dio.put(
        URL_BASE,
        options: Options(
          contentType: "application/x-www-form-urlencoded",
        ),
        data: {
          'id': this._ctrId.text,
          'nome': this._ctrNome.text,
          'email': this._ctrEmail.text,
          'tipo': (this._isRadioValue == 0) ? 'FISICA' : 'JURIDICA'
        },
      );

      return response.statusCode;
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    this.cliente = ModalRoute.of(context).settings.arguments as Cliente;

    if (this.cliente != null && this._ctrId.text == '') {
      this._ctrId.text = cliente.id;
      this._ctrNome.text = cliente.nome;
      this._ctrEmail.text = cliente.email;
      if (cliente.tipo == 'JURIDICA') {
        this._isRadioValue = 1;
      } else {
        this._isRadioValue = 0;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cliente'),
      ),
      body: Visibility(
        visible: this._ocupado,
        child: Loader(texto: 'Aguarde, atualizando cliente ...'),
        replacement: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Visibility(
                visible: (this._msgErro == ''),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _ctrId,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'ID',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _ctrNome,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Informe o nome';
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _ctrEmail,
                        enabled: true,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Informe o e-mail';
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: _isRadioValue,
                            onChanged: (value) {
                              setState(() {
                                _isRadioValue = value;
                              });
                            },
                          ),
                          Text(
                            'Física',
                            style: TextStyle(fontSize: 15),
                          ),
                          Radio(
                            value: 1,
                            groupValue: _isRadioValue,
                            onChanged: (value) {
                              setState(() {
                                _isRadioValue = value;
                              });
                            },
                          ),
                          Text(
                            'Jurídica',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          color: Theme.of(context).primaryColor,
                          child: FlatButton(
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                setState(() {
                                  this._ocupado = true;
                                });
                                gravarCliente().then((statusCode) {
                                  if (statusCode == 202) {
                                    Navigator.of(context).pop(true);
                                  }
                                }).catchError((erro) {
                                  setState(() {
                                    this._ocupado = false;
                                    this._msgErro = erro.toString();
                                  });
                                });
                              }
                            },
                            child: Text(
                              'SALVAR EDIÇÃO',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                replacement: Center(
                  child: Text(
                    this._msgErro,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
