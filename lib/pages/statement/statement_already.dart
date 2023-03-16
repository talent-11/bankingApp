import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

const descriptions = "You have already completed your one time matching of funds.";
const header = "Congratulations!";

class StatementAlreadyPage extends StatefulWidget {
  const StatementAlreadyPage({Key? key}) : super(key: key);

  @override
  State<StatementAlreadyPage> createState() => _StatementAlreadyPageState();
}

class _StatementAlreadyPageState extends State<StatementAlreadyPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  void onPressedBar(BuildContext context) {
    _scaffoldState.currentState?.openDrawer();
  }

  IconButton menuButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.menu, size: 32.0),
    onPressed: () => onPressedBar(context), 
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: const SideBar(),
      body: Column(
        children: [
          const LogoBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(header, style: Theme.of(context).textTheme.headline1),
                const Padding(
                  padding: EdgeInsets.all(32), 
                  child: Text(
                    descriptions, 
                    style: TextStyle(
                      color: Color(0xff98a9bc),
                      fontSize: 16,
                      height: 1.6
                    )
                  )
                )
              ]
            )
          ),
        ],
      )
    );
  }
}
