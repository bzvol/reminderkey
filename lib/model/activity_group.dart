import 'package:dio/dio.dart';

import 'activity.dart';

class ActivityGroup {
  String title;
  final List<Activity> activities;
  final DateTime? reminderTime;
  String? aiTips;
  bool isLoadingTips = false;

  ActivityGroup({
    required this.title,
    this.reminderTime,
  }) : activities = [];

  ActivityGroup._({
    required this.title,
    required this.activities,
    required this.reminderTime,
  });

  Future<void> loadAiTips() async {
    if (aiTips != null) return;

    const url = 'https://europe-west1-zvolproj.cloudfunctions.net/tips';
    final body = {
      'group_title': title,
      'items': activities.map((e) => e.keyword).toList(),
    };
    const headers = {'Content-Type': 'application/json'};

    final response =
        await Dio().post(url, data: body, options: Options(headers: headers));
    aiTips = response.data['answer'];
  }

  Future<void> generateTitle() async {
    const url = 'https://europe-west1-zvolproj.cloudfunctions.net/title-gen';
    final body = {
      'items': activities.map((e) => e.keyword).toList(),
    };
    const headers = {'Content-Type': 'application/json'};

    final response =
        await Dio().post(url, data: body, options: Options(headers: headers));

    title = response.data['title'];
  }

  ActivityGroup copy() => ActivityGroup._(
        title: title,
        activities: activities.map<Activity>((e) => e.copy()).toList(),
        reminderTime: reminderTime,
      );

  void filterActivities(String keyword) {
    String filter = keyword.trim().toLowerCase();
    activities.retainWhere((element) =>
        element.keyword.toLowerCase().contains(filter) ||
        (element.description != null &&
            element.description!.toLowerCase().contains(filter)));
  }
}
