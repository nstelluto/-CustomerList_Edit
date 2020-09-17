import 'package:aula10/widgets/widget_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var _ctrNome = TextEditingController();
  var _ctrEmail = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  var _isRadioValue = 0;
  var _ocupado = false;
  var _msgErro = '';

  Future<int> gravarCliente() async {
    Dio dio = Dio();
    Response response = await dio.post(
      URL_BASE,
      options: Options(
        contentType: "application/x-www-form-urlencoded",
      ),
      data: {
        'nome': this._ctrNome.text,
        'email': this._ctrEmail.text,
        'tipo': (this._isRadioValue == 0) ? 'Física' : 'Jurídica'
      },
    );
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Cliente'),
      ),
      body: Visibility(
        visible: this._ocupado,
        child: Loader(texto: "Adicionando Cliente"),
        replacement: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Visibility(
                visible: (_msgErro == ''),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
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
                                  if (statusCode == 201) {
                                    Navigator.of(context).pop(true);
                                  }
                                });
                              }
                            },
                            child: Text(
                              'SALVAR CLIENTE',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                replacement: Text(_msgErro),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
