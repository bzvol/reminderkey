import 'package:flutter/material.dart';

import '../component/chippy.dart';
import '../component/ycon_button.dart';
import '../model/activity.dart';
import '../model/activity_group.dart';

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
      onTap: /*isRemovable ? null : () => print('tapped')*/ null,
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
    widget.groupToInsert.aiTips = null;
    widget.onRemove(widget);

    setState(() {});
  }
}