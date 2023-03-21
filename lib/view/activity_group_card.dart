import 'package:flutter/material.dart';

import '../component/bottomfadeout.dart';
import '../component/chippy.dart';
import '../component/ycon_button.dart';
import '../model/activity.dart';
import '../model/activity_group.dart';
import '../utils.dart';
import 'activity_chip.dart';

class ActivityGroupCard extends StatefulWidget {
  final ActivityGroup activityGroup;
  final void Function(ActivityGroup group)? onRemove;

  const ActivityGroupCard(this.activityGroup, {Key? key, this.onRemove})
      : super(key: key);

  @override
  State<ActivityGroupCard> createState() => _ActivityGroupCardState();
}

class _ActivityGroupCardState extends State<ActivityGroupCard> {
  final List<Widget> _modifiableChips = [];
  bool _isEditingGroup = false;
  final TextEditingController _titleController = TextEditingController();

  bool get _isTitleValid => _titleController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 12,
                    blurRadius: 24,
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !_isEditingGroup
                      ? buildTitleRow(context)
                      : buildTitleEditingRow(context),
                  const SizedBox(height: 16.0),
                  buildElementList(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          !widget.activityGroup.isLoadingTips
              ? IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () => showAiTips(),
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: CircularProgressIndicator(strokeWidth: 6.0),
                ),
        ],
      ),
    );
  }

  Row buildTitleEditingRow(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlignVertical: TextAlignVertical.center,
              minLines: 1,
              maxLines: 1,
              maxLength: 20,
            ),
          ),
          IconButton(
            onPressed: _isTitleValid
                ? () => setState(() {
                      widget.activityGroup.title = _titleController.text.trim();
                      _isEditingGroup = false;
                    })
                : null,
            icon: const Icon(Icons.done),
          )
        ],
      );

  Row buildTitleRow(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          widget.activityGroup.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        buildPopupMenu(),
      ]);

  Widget buildElementList() => Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...widget.activityGroup.activities
              .map((e) => ActivityChip(e, isRemovable: _isEditingGroup,
                      onRemove: (activity) {
                    setState(() {
                      widget.activityGroup.activities.remove(activity);
                    });
                  }))
              .toList(),
          ..._modifiableChips,
          IconButton(
            onPressed: _addActivity,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      );

  Widget buildPopupMenu() => PopupMenuButton<String>(
        itemBuilder: (context) => buildPopupMenuList(),
        onSelected: onPopupMenuSelection,
        color: Theme.of(context).colorScheme.background,
        icon: const Icon(Icons.more_vert, color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      );

  List<PopupMenuEntry<String>> buildPopupMenuList() => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'edit',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Edit'),
              Icon(Icons.edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Delete'),
              Icon(Icons.delete),
            ],
          ),
        ),
        PopupMenuItem(
            value: 'generateTitle',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Generate new title'),
                Icon(Icons.title),
              ],
            )),
      ];

  void onPopupMenuSelection(String selection) {
    switch (selection) {
      case 'edit':
        setState(() {
          _titleController.text = widget.activityGroup.title;
          _isEditingGroup = true;
        });
        break;
      case 'delete':
        widget.onRemove?.call(widget.activityGroup);
        break;
      case 'generateTitle':
        generateNewTitle();
        break;
    }
  }

  void _addActivity() {
    setState(() {
      _modifiableChips.add(ModifiableActivityChip(
        widget.activityGroup,
        onRemove: (chip) => setState(() {
          _modifiableChips.remove(chip);
        }),
      ));
    });
  }

  Future<void> showAiTips() async {
    var group = widget.activityGroup;

    if (group.title == "Untitled" || group.activities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 16.0),
              Text("Please add title and some\nactivities to get tips!"),
            ],
          ),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      return;
    }

    try {
      setState(() => group.isLoadingTips = true);
      await group.loadAiTips();
      setState(() => group.isLoadingTips = false);

      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 350.0,
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: BottomFadeOut(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 32.0),
                  Text("Tips for ${group.title}",
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16.0),
                  Text(group.aiTips!,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        );
      }
    } on Exception catch (e) {
      showErrorSnackBar(context, e.toString());
      setState(() => group.isLoadingTips = false);
    }
  }

  Future<void> generateNewTitle() async {
    try {
      await widget.activityGroup.generateTitle();
    } on Exception catch (e) {
      showErrorSnackBar(context, e.toString());
    }

    setState(() {});
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Title refreshed!',
              style: TextStyle(color: Colors.white)),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.primary,
          // behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
