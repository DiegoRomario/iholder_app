import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iholder_app/blocs/ativo.bloc.dart';
import 'package:iholder_app/models/ativo-view-model.dart';
import 'package:iholder_app/models/ativo.dart';
import 'package:iholder_app/services/produto.service.dart';
import 'package:iholder_app/ui/shared/widgets/input-field.widget.dart';
import 'package:iholder_app/ui/shared/widgets/loader.widget.dart';
import 'package:iholder_app/ui/shared/widgets/type-ahead-field.widget.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CadastroAtivoScreen extends StatefulWidget {
  final AtivoViewModel ativoViewModel;
  TextEditingController descricaoCtrl = new TextEditingController();
  TextEditingController tickerCtrl = new TextEditingController();
  TextEditingController caracteristicasCtrl = new TextEditingController();
  TextEditingController cotacaoCtrl = new TextEditingController();
  TextEditingController produtoCtrl = new TextEditingController();
  Ativo ativo = new Ativo();
  CadastroAtivoScreen({this.ativoViewModel}) {
    if (ativoViewModel != null && descricaoCtrl.text != null) {
      descricaoCtrl.text = ativoViewModel.descricao;
      caracteristicasCtrl.text = ativoViewModel.caracteristicas;
      tickerCtrl.text = ativoViewModel.ticker;
      cotacaoCtrl.text = ativoViewModel.cotacao.toString();
      produtoCtrl.text = ativoViewModel.produtoDescricao;
      ativo.id = ativoViewModel.id;
    }
  }
  @override
  _CadastroAtivoScreenState createState() => _CadastroAtivoScreenState();
}

class _CadastroAtivoScreenState extends State<CadastroAtivoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var produtoService = ProdutoService();
  var _sending = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro de Ativos"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TypeAheadField(
                pcontroller: widget.produtoCtrl,
                pGetSuggestions: (val) {
                  return produtoService.obterSugestao(val);
                },
                plabel: "Produto",
                picon: MdiIcons.bulletinBoard,
                phint: "Ação, CDB, FII etc",
                pOnSaved: (val) {
                  widget.ativo.produtoId =
                      produtoService.obterPorDescricao(val);
                },
                pValidador: (value) {
                  String produtoId = produtoService.obterPorDescricao(value);
                  if (produtoId == null) {
                    return 'Produto inválido';
                  }
                  return null;
                },
              ),
              InputField(
                pcontroller: widget.descricaoCtrl,
                ptype: TextInputType.text,
                plabel: "Descrição",
                pMaxLength: 30,
                picon: MdiIcons.cardText,
                pValidador: (value) {
                  if (value.isEmpty) {
                    return 'Descrição inválida';
                  }
                  return null;
                },
                pOnSaved: (val) {
                  widget.ativo.descricao = val;
                },
              ),
              InputField(
                pcontroller: widget.tickerCtrl,
                ptype: TextInputType.text,
                plabel: "Ticket",
                pMaxLength: 30,
                picon: MdiIcons.alphabeticalVariant,
                pValidador: (value) {
                  if (value.isEmpty) {
                    return 'Ticker inválido';
                  }
                  return null;
                },
                pOnSaved: (val) {
                  widget.ativo.ticker = val;
                },
              ),
              InputField(
                pcontroller: widget.caracteristicasCtrl,
                ptype: TextInputType.multiline,
                plabel: "Características",
                picon: MdiIcons.scriptText,
                pOnSaved: (val) {
                  widget.ativo.caracteristicas = val;
                },
              ),
              InputField(
                pcontroller: widget.cotacaoCtrl,
                ptype: TextInputType.number,
                plabel: "Cotação",
                picon: MdiIcons.cashUsd,
                pFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                pValidador: (value) {
                  double teste = double.parse(value);
                  if (teste < 0) {
                    return 'Valor inválido';
                  }
                  return null;
                },
                pOnSaved: (val) {
                  widget.ativo.cotacao = double.parse(val);
                },
              ),
              Container(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RaisedButton(
                    child: Text("Salvar"),
                    onPressed: _sending
                        ? null
                        : () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              create(context);
                            }
                          },
                  ),
                ),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Loader(),
                ),
                visible: _sending,
              ),
            ],
          ),
        ),
      ),
    );
  }

  create(BuildContext context) async {
    var bloc = Provider.of<AtivoBloc>(context, listen: false);
    setState(() {
      _sending = true;
    });
    String response = await bloc.salvar(widget.ativo).whenComplete(
      () {
        setState(
          () {
            _sending = false;
          },
        );
      },
    ).catchError(
      (onError) {
        final snackBar = SnackBar(content: Text(onError.message));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      },
    );

    if (response != null) {
      final snackBar = SnackBar(
        content: Text(response),
      );
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.pop(context);
        },
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  CurrencyPtBrInputFormatter({this.maxDigits});
  final int maxDigits;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits != null && newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = formatter.format(value / 100);
    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}