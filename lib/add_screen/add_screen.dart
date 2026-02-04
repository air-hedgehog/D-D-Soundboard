import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:d_n_d_soundboard/constants.dart';
import 'package:d_n_d_soundboard/db/database.dart';
import 'package:d_n_d_soundboard/di.dart';
import 'package:d_n_d_soundboard/extensions.dart';
import 'package:d_n_d_soundboard/home_screen/sound_model.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final AppDatabase _database = getIt<AppDatabase>();
  List<ToAddEntry> toAddEntries = [];
  bool _dragging = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context
            .l10n()
            .adding_new_sounds),
        trailing: toAddEntries.isEmpty
            ? null
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              child: Icon(CupertinoIcons.floppy_disk),
              onPressed: () async {
                List<SoundModel> models = [];
                var uuid = Uuid();
                for (int i = 0; i < toAddEntries.length; i++) {
                  models.add(SoundModel(uuid: uuid.v4(),
                      image: toAddEntries[i].image,
                      sound: toAddEntries[i].sound,
                      index: i,
                      displayName: toAddEntries[i].displayName));
                }
                await saveFiles(models);
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                selectMp3();
              },
            ),
            CupertinoButton(
              child: Icon(CupertinoIcons.clear),
              onPressed: () {
                setState(() {
                  toAddEntries.clear();
                });
              },
            ),
          ],
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
              onDeleteClick: (entry) {
                setState(() {
                  toAddEntries.remove(entry);
                });
              },
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
                context
                    .l10n()
                    .drag_n_drop,
                style: CupertinoTheme
                    .of(
                  context,
                )
                    .textTheme
                    .textStyle,
              ),
            )
                .wrapInRoundedRectangle(
              _loading
                  ? context
                  .colors()
                  .error
                  .withAlpha(100)
                  : (_dragging
                  ? context
                  .colors()
                  .primaryContainer
                  .withAlpha(100)
                  : CupertinoColors.transparent),
              radius: RADIUS_DEFAULT,
            )
                .setOnClickListener(() {
              selectMp3();
            }),
          ),
        ),
      ),
    );
  }

  Future<void> selectMp3() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      onFilesSelected(result.xFiles);
    }
  }

  void onFilesSelected(List<XFile> files) {
    setState(() {
      for (XFile xFile in files) {
        if (toAddEntries.any((e) => e.sound.path == xFile.path)) {
          continue;
        } else {
          toAddEntries.add(
            ToAddEntry(image: null, sound: xFile, displayName: xFile.name),
          );
        }
      }
    });
  }

  Future<void> saveFiles(List<SoundModel> models) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    Directory directory = await getApplicationDocumentsDirectory();
    await Future.wait(models.map((e) => saveFile(e, directory, _database)));

    setState(() {
      _loading = false;
    });
  }

  Future<void> saveFile(SoundModel entry,
      Directory directory,
      AppDatabase database,) async {
    String? soundPath = await saveSound(entry.sound, directory);

    if (soundPath == null) {
      return;
    }

    String? imagePath;
    if (entry.image != null) {
      imagePath = await saveImage(entry.image!, directory);
    }
    await database
        .into(database.dBSoundModel)
        .insert(
      DBSoundModelCompanion.insert(
        index: entry.index,
        uuid: entry.uuid,
        soundPath: soundPath,
        displayName: entry.displayName,
        imagePath: Value(imagePath),
      ),
    );
  }

  Future<String?> saveSound(XFile sound, Directory directory) async {
    String? mime = lookupMimeType(sound.path);
    if (mime != "audio/mpeg") {
      return null;
    }

    File file = File('${directory.path}/${sound.name}');

    if (await file.exists()) {
      return file.path;
    }

    List<int> bytes = await sound.readAsBytes();
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<String?> saveImage(XFile image, Directory directory) async {
    File file = File('${directory.path}/${image.name}');

    if (await file.exists()) {
      await file.delete();
    }

    List<int> bytes = await image.readAsBytes();
    await file.writeAsBytes(bytes);
    return file.path;
  }
}

class ToAddViewHolder extends StatefulWidget {
  const ToAddViewHolder({
    super.key,
    required this.entry,
    required this.onImageClick,
    required this.onDeleteClick,
  });

  final ToAddEntry entry;
  final Function(ToAddEntry entry) onImageClick;
  final Function(ToAddEntry entry) onDeleteClick;

  @override
  State<ToAddViewHolder> createState() => _ToAddViewHolderState();
}

class _ToAddViewHolderState extends State<ToAddViewHolder> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.entry.displayName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MARGIN_DEFAULT / 2),
      child:
      SizedBox(
        height: ADDING_ITEM_HEIGHT,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: MARGIN_DEFAULT,
          children: [
            SizedBox(
              width: ADDING_ITEM_HEIGHT,
              height: ADDING_ITEM_HEIGHT,
              child: widget.entry.image == null
                  ? Icon(CupertinoIcons.photo)
                  : Image.file(
                File(widget.entry.image!.path),
                fit: BoxFit.cover,
              ),
            ).setOnClickListener(() => widget.onImageClick(widget.entry)),

            Expanded(
              child: EditableText(
                controller: _controller,
                focusNode: FocusNode(),
                showSelectionHandles: true,
                enableInteractiveSelection: true,
                style: CupertinoTheme
                    .of(context)
                    .textTheme
                    .textStyle,
                cursorColor: CupertinoTheme
                    .of(context)
                    .primaryColor,
                selectionColor: CupertinoTheme
                    .of(context)
                    .primaryColor,
                backgroundCursorColor: CupertinoTheme
                    .of(
                  context,
                )
                    .primaryContrastingColor,
              ),
            ),

            CupertinoButton(
              child: Icon(CupertinoIcons.delete),
              onPressed: () => widget.onDeleteClick(widget.entry),
            ),
          ],
        ),
      ).wrapInRoundedRectangle(
        CupertinoColors.transparent,
        radius: RADIUS_DEFAULT,
        strokeWidth: 1.0,
        strokeColor: CupertinoTheme
            .of(context)
            .textTheme
            .textStyle
            .color!,
      ),
    );
  }
}
