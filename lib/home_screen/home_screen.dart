import 'dart:io';

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
          onPressed: () async {
            await Navigator.of(
              context,
            ).push(CupertinoPageRoute(builder: (context) => AddScreen()));
            viewModel.refresh();
          },
        ),
      ),
      child: SafeArea(
        child: ReorderableBuilder(
          enableDraggable: true,
          onReorder: (ReorderedListFunction reorderedListFunction) {
            viewModel.saveNewOrder(reorderedListFunction(state.items));
          },
          children: state.items
              .map(
                (e) =>
                    SizedBox(
                          width: MAIN_ITEM_WIDTH,
                          height: MAIN_ITEM_HEIGHT,
                          child: Column(
                            //spacing: MARGIN_DEFAULT,
                            children: [
                              SizedBox(
                                height: MAIN_ITEM_WIDTH,
                                width: MAIN_ITEM_WIDTH,
                                child: e.image == null
                                    ? Icon(CupertinoIcons.photo)
                                    : Image.file(
                                        File(e.image!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(MARGIN_DEFAULT),
                                  child: Text(
                                    e.displayName,
                                    style: CupertinoTheme.of(
                                      context,
                                    ).textTheme.textStyle.copyWith(fontSize: 14),
                                    maxLines: 5,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .wrapInRoundedRectangle(
                          CupertinoColors.transparent,
                          radius: RADIUS_DEFAULT,
                          strokeWidth: 1.0,
                          strokeColor: CupertinoTheme.of(
                            context,
                          ).primaryContrastingColor,
                          key: Key(e.uuid),
                        ),
              )
              .toList(),
          builder: (children) {
            return GridView(
              padding: EdgeInsets.all(MARGIN_DEFAULT),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MAIN_ITEM_WIDTH,
                childAspectRatio: MAIN_ITEM_WIDTH / MAIN_ITEM_HEIGHT,
                mainAxisSpacing: MARGIN_DEFAULT,
                crossAxisSpacing: MARGIN_DEFAULT,
              ),
              children: children,
            );
          },
        ),
      ),
    );
  }
}
