import 'package:flutter/material.dart';
import 'package:iholder_app/blocs/ativo.bloc.dart';
import 'package:iholder_app/models/ativo-view-model.dart';
import 'package:iholder_app/ui/android/screens/cadastro-ativo.screen.dart';
import 'package:iholder_app/ui/shared/widgets/ativo-card.widget.dart';
import 'package:iholder_app/ui/shared/widgets/data-loader.widget.dart';
import 'package:provider/provider.dart';

class AtivosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<AtivoBloc>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ativos"),
        centerTitle: true,
      ),
      body: DataLoader(
        object: bloc.ativos,
        callback: () {
          return AtivosListagem(
            ativos: bloc.ativos,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CadastroAtivoScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AtivosListagem extends StatelessWidget {
  final List<AtivoViewModel> ativos;
  AtivosListagem({this.ativos});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: ativos.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    AtivoCard(
                      ativos[index],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
