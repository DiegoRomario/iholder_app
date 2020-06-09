import 'package:flutter/widgets.dart';
import 'package:iholder_app/models/distribuicao-divisao.dart';
import 'package:iholder_app/models/distribuicao-view-model.dart';
import 'package:iholder_app/models/distribuicao.dart';
import 'package:iholder_app/repositories/distribuicao.repository.dart';
import 'Idistribuicao.bloc.dart';

class DistribuicaoPorTipoBloc extends ChangeNotifier
    implements IDistribuicaoBloc {
  var mostraTabela = true;
  final distribuicoesRepository =
      new DistribuicaoRepository("DistribuicaoPorTipoInvestimento");

  List<DistribuicaoViewModel> distribuicoes;

  DistribuicaoPorTipoBloc() {
    obterDistribuicao();
    notifyListeners();
  }

  alteraFormatoVisualizacao() {
    mostraTabela = !mostraTabela;
    notifyListeners();
  }

  obterDistribuicao() async {
    await distribuicoesRepository.obterTodos().then((data) {
      this.distribuicoes = data;
      notifyListeners();
    });
  }

  Future<String> salvar(Distribuicao tipoInvestimento) async {
    try {
      var response = await distribuicoesRepository.salvar(tipoInvestimento);
      await obterDistribuicao();
      return response;
    } catch (ex) {
      throw ex;
    }
  }

  Future<String> dividir(DistribuicaoDivisao divisao) async {
    try {
      var response = await distribuicoesRepository.dividir(divisao);
      await obterDistribuicao();
      return response;
    } catch (ex) {
      throw ex;
    }
  }
}
