import 'package:flutter/material.dart';
import 'package:iholder_app/blocs/distribuicao-por-ativo.bloc.dart';
import 'package:iholder_app/blocs/distribuicao-por-produto.bloc.dart';
import 'package:iholder_app/blocs/distribuicao-por-tipo.bloc.dart';
import 'package:iholder_app/settings.dart';
import 'package:iholder_app/ui/shared/widgets/usuario-nao-autorizado.widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'distribuicao.screen.dart';

class PainelScreen extends StatefulWidget {
  @override
  _PainelScreenState createState() => _PainelScreenState();
}

class _PainelScreenState extends State<PainelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      body: Settings.usuario != null ? OpcoesPaineis() : UsuarioNaoAutorizado(),
    );
  }
}

class OpcoesPaineis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  title: Text(
                    'Distribuições',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: GridView.count(
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 2,
                      childAspectRatio: .99,
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => DistribuicaoScreen(
                                      "Distribuição por ativos",
                                      Provider.of<DistribuicaoPorAtivoBloc>(
                                          context)),
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(MdiIcons.chartPie),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('Ativos'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => DistribuicaoScreen(
                                      "Distribuição por produtos",
                                      Provider.of<DistribuicaoPorProdutoBloc>(
                                          context)),
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(MdiIcons.chartDonut),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('Produtos'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => DistribuicaoScreen(
                                      "Distribuição por tipos",
                                      Provider.of<DistribuicaoPorTipoBloc>(
                                          context)),
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(MdiIcons.chartBar),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('Tipos de Investimento'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
