import 'package:ajoufinder/main.dart';
import 'package:ajoufinder/ui/shared/widgets/board_list_widget.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String lostCategory;
  const HomeScreen({super.key, required this.lostCategory});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware{

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('${DateTime.now()} - HomeScreen didUpdateWidget ${widget.lostCategory}');
    if (oldWidget.lostCategory != widget.lostCategory) {
      _loadData();
    }
  }

  void _loadData() async {
    final boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
    await boardViewModel.fetchCategoricalBoardItems(widget.lostCategory);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 3. 라우트 관찰자 등록
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardViewModel>(
    builder: (context, viewModel, _) {
      if (viewModel.isLoadingBoardItems && viewModel.boards.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (viewModel.boardError != null) {
        return Center(child: Text(viewModel.boardError!));
      }
      if (viewModel.boards.isNotEmpty) {
        return SingleChildScrollView(
          child: BoardListWidget(boardItems: viewModel.boards)
        );
      }
      return const Center(child: Text('게시글이 없습니다'));
    },
  );
  }
}

