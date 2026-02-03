import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:d_n_d_soundboard/constants.dart';
import 'package:d_n_d_soundboard/db/database.dart';
import 'package:d_n_d_soundboard/extensions.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
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

  List<ToAddEntry> toAddEntries = [];
  bool _dragging = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n().adding_new_sounds),
        trailing: toAddEntries.isEmpty
            ? null
            : CupertinoButton(
                child: Icon(CupertinoIcons.clear),
                onPressed: () {
                  setState(() {
                    toAddEntries.clear();
                  });
                },
              ),
      ),
      child: SafeArea(
        child: toAddEntries.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.all(MARGIN_DEFAULT),
                itemCount: toAddEntries.length,
                itemBuilder: (context, index) {
                  return ToAddViewHolder(
                    entry: toAddEntries[index],
                    onImageClick: (entry) async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg'],
                          );

                      if (result != null) {
                        setState(() {
                          entry.image = result.xFiles.first;
                        });
                      }
                    },
                  );
                },
              )
            : DropTarget(
                onDragDone: (detail) async {
                  onFilesSelected(detail.files);
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
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.textStyle,
                            ),
                          )
                          .wrapInRoundedRectangle(
                            _loading
                                ? context.colors().error.withAlpha(100)
                                : (_dragging
                                      ? context
                                            .colors()
                                            .primaryContainer
                                            .withAlpha(100)
                                      : CupertinoColors.transparent),
                            radius: RADIUS_DEFAULT,
                          )
                          .setOnClickListener(() async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: ['mp3'],
                                );

                            if (result != null) {
                              onFilesSelected(result.xFiles);
                            }
                          }),
                ),
              ),
      ),
    );
  }

  void onFilesSelected(List<XFile> files) {
    setState(() {
      for (XFile xFile in files) {
        toAddEntries.add(ToAddEntry(image: null, sound: xFile));
      }
    });
  }

  Future<void> saveFiles(List<SoundModel> models) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    AppDatabase database = AppDatabase();
    Directory directory = await getApplicationDocumentsDirectory();

    await Future.wait(models.map((e) => saveFile(e, directory, database)));

    setState(() {
      _loading = false;
    });
  }

  Future<void> saveFile(
    SoundModel entry,
    Directory directory,
    AppDatabase database,
  ) async {
    await saveSound(entry.sound, directory);
    if (entry.image != null) {
      await saveImage(entry.image!, directory);
    }
    await database
        .into(database.dBSoundModel)
        .insert(
          DBSoundModelCompanion.insert(
            index: entry.index,
            uuid: Uuid().v4(),
            soundName: entry.sound.name,
            imageName: Value(entry.image?.name),
          ),
        );
  }

  Future<bool> saveSound(XFile sound, Directory directory) async {
    String? mime = lookupMimeType(sound.path);
    if (mime != "audio/mpeg") {
      return false;
    }

    File file = File('${directory.path}/${sound.name}');

    if (await file.exists()) {
      return false;
    }

    List<int> bytes = await sound.readAsBytes();
    await file.writeAsBytes(bytes);
    return true;
  }

  Future<void> saveImage(XFile image, Directory directory) async {
    File file = File('${directory.path}/${image.name}');

    if (await file.exists()) {
      await file.delete();
    }

    List<int> bytes = await image.readAsBytes();
    await file.writeAsBytes(bytes);
  }
}

class ToAddViewHolder extends StatelessWidget {
  const ToAddViewHolder({
    super.key,
    required this.entry,
    required this.onImageClick,
  });

  final ToAddEntry entry;
  final Function(ToAddEntry entry) onImageClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MARGIN_DEFAULT / 2),
      child:
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: MARGIN_DEFAULT,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: entry.image == null
                      ? Icon(CupertinoIcons.photo)
                      : Image.file(File(entry.image!.path), fit: BoxFit.cover),
                ).setOnClickListener(() => onImageClick(entry)),

                Expanded(
                  child: Text(
                    entry.sound.name,
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                ),
              ],
            ),
          ).wrapInRoundedRectangle(
            CupertinoColors.transparent,
            radius: RADIUS_DEFAULT,
            strokeWidth: 1.0,
            strokeColor: CupertinoTheme.of(context).textTheme.textStyle.color!,
          ),
    );
  }
}
