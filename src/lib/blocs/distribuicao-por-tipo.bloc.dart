import 'package:flutter/widgets.dart';
import 'package:iholder_app/models/distribuicao-view-model.dart';
import 'package:iholder_app/repositories/distribuicao.repository.dart';
import 'Idistribuicao.bloc.dart';

class DistribuicaoPorTipoBloc extends ChangeNotifier implements IDistribuicaoBloc {
  var mostraTabela = true;
  final distribuicoesRepository =
      new DistribuicaoRepository("DistribuicaoPorTipoInvestimento");

  List<DistribuicaoViewModel> distribuicoes;

  DistribuicaoPorTipoBloc() {
    obterDistribuicao();
  }

  alteraFormatoVisualizacao() {
    mostraTabela = !mostraTabela;
    notifyListeners();
  }

  obterDistribuicao() {
    distribuicoesRepository.getAll().then((data) {
      this.distribuicoes = data;
      notifyListeners();
    });
  }
}
