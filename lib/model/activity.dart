import 'package:flutter/material.dart';
import 'package:reminderkey/component/ycon_button.dart';

import '../component/chippy.dart';

class ActivityGroup {
  String title;
  final List<Activity> activities;
  final DateTime? reminderTime;

  ActivityGroup({
    required this.title,
    this.reminderTime,
  }) : activities = [];
}

class Activity {
  String keyword;
  final String? description;
  final DateTime? reminderTime;
  final String? emoji;

  Activity({
    this.keyword = '',
    this.description,
    this.reminderTime,
    this.emoji,
  });
}

class ActivityGroupCard extends StatefulWidget {
  final ActivityGroup activityGroup;

  const ActivityGroupCard(this.activityGroup, {Key? key}) : super(key: key);

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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2446),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !_isEditingGroup
                  ? Text(
                      widget.activityGroup.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : Expanded(
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
                onPressed: !_isEditingGroup
                    ? () => setState(() {
                          _titleController.text = widget.activityGroup.title;
                          _isEditingGroup = true;
                        })
                    : _isTitleValid
                        ? () => setState(() {
                              widget.activityGroup.title =
                                  _titleController.text;
                              _isEditingGroup = false;
                            })
                        : null,
                icon: !_isEditingGroup
                    ? const Icon(Icons.edit)
                    : const Icon(Icons.done),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Wrap(
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
          ),
        ],
      ),
    );
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
}

class ActivityChip extends StatelessWidget {
  final Activity activity;
  final bool isRemovable;
  final void Function(Activity activity)? onRemove;

  const ActivityChip(this.activity,
      {Key? key, this.isRemovable = false, this.onRemove})
      : assert(!isRemovable || onRemove != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chippy(
      trailing: isRemovable
          ? YconButton(
              icon: const Icon(Icons.close, size: 20.0),
              onTap: () => onRemove!(activity))
          : null,
      onTap: isRemovable ? null : () => print('tapped'),
      child: Text(activity.keyword),
    );
  }
}

class ModifiableActivityChip extends StatefulWidget {
  final ActivityGroup groupToInsert;
  final void Function(Widget chip) onRemove;

  const ModifiableActivityChip(this.groupToInsert,
      {required this.onRemove, Key? key})
      : super(key: key);

  @override
  State<ModifiableActivityChip> createState() => _ModifiableActivityChipState();
}

class _ModifiableActivityChipState extends State<ModifiableActivityChip> {
  final Activity _activity = Activity();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Theme.of(context).colorScheme.onBackground),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () => widget.onRemove(widget),
              icon: const Icon(Icons.close),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0.0)),
                  iconSize: MaterialStateProperty.all(20.0))),
          Flexible(
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 8.0),
                counterText: '',
              ),
              style: const TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.center,
              minLines: 1,
              maxLines: 1,
              maxLength: 20,
            ),
          ),
          IconButton(
              onPressed: _controller.text.isEmpty ? null : _insertActivity,
              icon: const Icon(Icons.done),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0.0)),
                  iconSize: MaterialStateProperty.all(20.0))),
        ],
      ),
    );
  }

  void _insertActivity() {
    _activity.keyword = _controller.text;
    widget.groupToInsert.activities.add(_activity);
    widget.onRemove(widget);

    setState(() {});
  }
}
