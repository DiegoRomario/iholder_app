import 'package:iholder_app/models/produto-view-model.dart';
import 'package:iholder_app/repositories/produto.repository.dart';

class ProdutoService {
  var produtoRepository = new ProdutoRepository();
  List<ProdutoViewModel> produtos;

  ProdutoService() {
    produtos = new List<ProdutoViewModel>();
  }

  String obterPorDescricao(String description) {
    ProdutoViewModel produto = produtos
        .firstWhere((e) => e.descricao == description, orElse: () => null);

    return produto?.id;
  }

  Future<List<String>> obterSugestao(String query) async {
    List<ProdutoViewModel> matches = List();

    await produtoRepository.obterTodos().then(
      (data) {
        this.produtos = data;
      },
    );

    matches.addAll(produtos);

    matches.retainWhere(
        (s) => s.descricao.toLowerCase().contains(query.toLowerCase()));

    List<String> sList = matches.map((val) => val.descricao).toList();

    return sList;
  }
}
