import 'model/activity.dart';
import 'model/activity_group.dart';

final dailyRoutine = <ActivityGroup>[
  ActivityGroup(title: 'Morning routine')
    ..activities.addAll([
      Activity(keyword: 'wake up'),
      Activity(keyword: 'brush teeth'),
      Activity(keyword: 'eat breakfast'),
      Activity(keyword: 'go to work'),
    ]),
  ActivityGroup(title: 'Evening routine')
    ..activities.addAll([
      Activity(keyword: 'go home'),
      Activity(keyword: 'eat dinner'),
      Activity(keyword: 'brush teeth'),
      Activity(keyword: 'go to bed')
    ]),
];