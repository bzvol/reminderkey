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

  Activity copy() => Activity(
        keyword: keyword,
        description: description,
        reminderTime: reminderTime != null
            ? DateTime.fromMillisecondsSinceEpoch(
                reminderTime!.millisecondsSinceEpoch)
            : null,
        emoji: emoji,
      );
}
