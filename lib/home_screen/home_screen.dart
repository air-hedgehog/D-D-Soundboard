import 'package:d_n_d_soundboard/add_screen/add_screen.dart';
import 'package:d_n_d_soundboard/constants.dart';
import 'package:d_n_d_soundboard/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:view_model/widget_state.dart';

import 'home_state.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState
    extends AbstractPageState<HomeScreen, HomeViewModel, HomeState> {
  _HomeScreenState() : super(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(APP_NAME),
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.add_circled),
          onPressed: () {
            Navigator.of(
              context,
            ).push(CupertinoPageRoute(builder: (context) => AddScreen()));
          },
        ),
      ),
      child: ReorderableBuilder(
        enableDraggable: false,
        children: state.items
            .map(
              (e) =>
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Column(
                      spacing: MARGIN_DEFAULT,
                      children: [Text(e.imagePath), Text(e.soundPath)],
                    ),
                  ).wrapInRoundedRectangle(
                    context.colors().surface,
                    radius: RADIUS_DEFAULT,
                    strokeWidth: 1.0,
                    strokeColor: context.colors().onSurface,
                    key: Key(e.uuid),
                  ),
            )
            .toList(),
        builder: (children) {
          return GridView(
            padding: EdgeInsets.all(MARGIN_DEFAULT),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100.0,
              mainAxisSpacing: MARGIN_DEFAULT,
              crossAxisSpacing: MARGIN_DEFAULT,
            ),
            children: children,
          );
        },
      ),
    );
  }
}
