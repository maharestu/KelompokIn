// lib/screens/main_shell.dart

import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'account_screen.dart';
import 'files_screen.dart';
import 'home_screen.dart';
import 'tasks_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onSwitchTab: _onTabTapped),
      TasksScreen(onSwitchTab: _onTabTapped),
      FilesScreen(onSwitchTab: _onTabTapped),
      AccountScreen(onSwitchTab: _onTabTapped),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
