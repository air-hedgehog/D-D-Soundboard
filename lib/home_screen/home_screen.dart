import 'dart:io';

import 'package:d_n_d_soundboard/add_screen/add_screen.dart';
import 'package:d_n_d_soundboard/constants.dart';
import 'package:d_n_d_soundboard/extensions.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
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
                (e) => SoundGridViewHolder(
                  key: Key(e.uuid),
                  model: e,
                  state: state,
                  viewModel: viewModel,
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

class SoundGridViewHolder extends StatelessWidget {
  SoundGridViewHolder({
    super.key,
    required this.model,
    required this.state,
    required this.viewModel,
  });

  final SoundModel model;
  final HomeState state;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: MAIN_ITEM_WIDTH,
          height: MAIN_ITEM_HEIGHT,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MAIN_ITEM_WIDTH,
                    width: MAIN_ITEM_WIDTH,
                    child: model.image == null
                        ? Icon(CupertinoIcons.photo)
                        : Image.file(
                            File(model.image!.path),
                            fit: BoxFit.cover,
                          ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(MARGIN_DEFAULT),
                      child: Text(
                        model.displayName,
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

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  spacing: 1.0,
                  children: [
                    if (viewModel.manager.sounds.containsKey(model.uuid))
                      CupertinoButton.tinted(
                        borderRadius: BorderRadius.all(
                          Radius.circular(RADIUS_DEFAULT),
                        ),
                        foregroundColor:
                            viewModel.manager.sounds[model.uuid]!.isLooping
                            ? CupertinoColors.destructiveRed
                            : null,
                        color: viewModel.manager.sounds[model.uuid]!.isLooping
                            ? CupertinoColors.destructiveRed
                            : CupertinoTheme.of(context).primaryColor,
                        child: Icon(CupertinoIcons.loop),
                        onPressed: () {
                          viewModel.toggleInfinite(model);
                        },
                      ),
                    if (viewModel.manager.sounds.containsKey(model.uuid))
                      CupertinoButton.tinted(
                        borderRadius: BorderRadius.all(
                          Radius.circular(RADIUS_DEFAULT),
                        ),
                        color: CupertinoTheme.of(context).primaryColor,
                        onPressed: state.loading
                            ? null
                            : () {
                                viewModel.stop(model);
                              },
                        child: Icon(CupertinoIcons.stop_circle_fill),
                      ),
                  ],
                ),
              ),
            ],
          ),
        )
        .setOnClickListener(
          () {
            viewModel.togglePlay(model);
          },
          onRightClick: () {
            _showContextMenu(context);
          },
        )
        .wrapInRoundedRectangle(
          CupertinoColors.transparent,
          radius: RADIUS_DEFAULT,
          strokeWidth: 1.0,
          strokeColor: CupertinoTheme.of(
            context,
          ).textTheme.textStyle.color!.withAlpha(50),
        );
  }

  void _showContextMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteEntry(model);
            },
            child: Text(context.l10n().delete),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n().cancel),
        ),
      ),
    );
  }

}
