import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/providers/task_provider.dart';

import '../../main.dart';
import '../providers/home_provider.dart';
import 'widgets/FAB.dart';
import 'widgets/build_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Provider.of<TaskProvider>(context, listen: false).loadTasks();
    Provider.of<HomeProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: const Fab(),
        body: const BuildBody(),
      ),
    );
  }
}
