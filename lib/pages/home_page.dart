import 'dart:convert';

import 'package:aula10/classes/app_route.dart';
import 'package:aula10/classes/cliente.dart';
import 'package:aula10/widgets/widget_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const URL_BASE = 'https://www.wllsistemas.com.br/api/v3/cliente/';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Cliente> _listaCliente = List<Cliente>();

  var _ocupado = false;

  @override
  void initState() {
    consultaClientes();
    super.initState();
  }

  Future consultaClientes() async {
    this._ocupado = true;
    Dio dio = Dio();
    Response response = await dio.get(URL_BASE);
    if (response.statusCode == 200) {
      var clietesJson = json.decode(response.data);
      this._listaCliente.clear();
      for (var clienteJson in clietesJson) {
        this._listaCliente.add(Cliente.fromJson(clienteJson));
      }
    }

    setState(() {
      this._ocupado = false;
    });
  }

  Future excluirCliente(id) async {
    Dio dio = Dio();
    Response response = await dio.delete(URL_BASE + id);
  }

  Widget itemLista(Cliente cliente, int index) {
    final avatar = (cliente.tipo == 'JURIDICA')
        ? CircleAvatar(
            child: Icon(Icons.local_convenience_store),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          )
        : CircleAvatar(
            child: Icon(Icons.person),
            backgroundColor: Colors.blueGrey[200],
            foregroundColor: Colors.white,
          );
    return Dismissible(
      background: Container(
        alignment: AlignmentDirectional.centerStart,
        color: Colors.red,
        child: Row(
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Excluir',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      key: ObjectKey(cliente.id),
      onDismissed: (direction) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Aguarde, excluindo cliente ..."),
          ),
        );
        this._listaCliente.removeAt(index);
        this.excluirCliente(cliente.id).then((_) {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        });
        setState(() {});
      },
      direction: DismissDirection.startToEnd,
      child: ListTile(
        isThreeLine: true,
        leading: avatar,
        title: Text(cliente.nome),
        subtitle: Text('#' + cliente.id + '\n' + cliente.email),
        trailing: Container(
          width: 50,
          child: IconButton(
            icon: Icon(Icons.edit),
            color: Colors.indigo,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(
                AppRoutes.EDIT_PAGE,
                arguments: cliente,
              )
                  .then((retorno) {
                if (retorno) {
                  this.consultaClientes();
                }
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Lista de Clientes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                consultaClientes();
              });
            },
          ),
        ],
      ),
      body: Visibility(
        visible: this._ocupado,
        child: Loader(texto: 'Aguarde, consultando clientes ...'),
        replacement: RefreshIndicator(
          onRefresh: this.consultaClientes,
          child: ListView.builder(
            itemCount: this._listaCliente.length,
            itemBuilder: (BuildContext context, int index) {
              return itemLista(this._listaCliente.elementAt(index), index);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.ADD_PAGE).then((retorno) {
            if (retorno) {
              this.consultaClientes();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
