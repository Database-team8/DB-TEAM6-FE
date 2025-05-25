import 'dart:async';

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
  late Future<void> _fetchBoardFuture;

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lostCategory != widget.lostCategory) {
      _loadData();
    }
  }

  void _loadData() {
    final boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
    setState(() {
      _fetchBoardFuture = boardViewModel.fetchBoards(category: widget.lostCategory);
    });
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
    _fetchBoardFuture = Completer<void>().future; 
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchBoardFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return Consumer<BoardViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.boards.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.error != null && viewModel.boards.isEmpty) {
               return Center(child: Text(viewModel.error!));
            }
            if (viewModel.boards.isNotEmpty) {
              return SingleChildScrollView(
                child: BoardListWidget(boards: viewModel.boards)
              );
            } else {
              return const Center(child: Text('게시글이 없습니다'));
            }
          },
        );
        } 
      }
    );
  }
}

