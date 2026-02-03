import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:d_n_d_soundboard/constants.dart';
import 'package:d_n_d_soundboard/extensions.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:view_model/widget_state.dart';

import 'add_state.dart';
import 'add_view_model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState
    extends AbstractPageState<AddScreen, AddViewModel, AddState> {
  _AddScreenState() : super(AddViewModel());

  bool _dragging = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n().adding_new_sounds),
      ),
      child: DropTarget(
              onDragDone: (detail) async {
                onFileSelected(detail.files);
              },
              onDragEntered: (detail) {
                setState(() {
                  _dragging = true;
                });
              },
              onDragExited: (detail) {
                setState(() {
                  _dragging = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(MARGIN_DEFAULT),
                child:
                    Center(
                      child: Text(
                        context.l10n().drag_n_drop,
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                    ).wrapInRoundedRectangle(
                      _loading
                          ? context.colors().error.withAlpha(100)
                          : (_dragging
                                ? context.colors().primaryContainer.withAlpha(
                                    100,
                                  )
                                : CupertinoColors.transparent),
                      radius: RADIUS_DEFAULT,
                    ),
              ),
            ),
    );
  }

  void onFileSelected(List<XFile> files) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    Directory directory = await getApplicationDocumentsDirectory();

    for (var xFile in files) {
      String? mime = lookupMimeType(xFile.path);
      if (mime != "audio/mpeg") {
        continue;
      }

      File file = File('${directory.path}/${xFile.name}');

      if (await file.exists()) {
        continue;
      }

      List<int> bytes = await xFile.readAsBytes();
      await file.writeAsBytes(bytes);
    }

    setState(() {
      _loading = false;
    });
  }
}
