import 'package:flutter/material.dart';

import '../model/activity.dart';
import '../model/activity_group.dart';
import '../view/activity_group_card.dart';
import '../examples.dart' as examples;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final activities = examples.dailyRoutine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomAppBar(
            padding: EdgeInsets.all(64.0), child: Text('Bottom bar')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            activities.add(ActivityGroup(title: 'Untitled'));
          }),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        body: SafeArea(
          child: Column(
            children: [
              const SearchBar(),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) => ActivityGroupCard(
                  activities[index],
                  onRemove: (group) => setState(() => activities.remove(group)),
                ),
                itemCount: activities.length,
              ))
            ],
          ),
        ));
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String)? _onType;

  const SearchBar({
    super.key,
    void Function(String)? onType,
  }) : _onType = onType;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      padding: const EdgeInsets.all(16.0),
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
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TextField(
            onChanged: widget._onType,
            decoration: InputDecoration(
              hintText: 'Search for reminders',
              contentPadding: EdgeInsets.only(
                  bottom:
                      Theme.of(context).textTheme.bodyLarge!.fontSize! - 4.0),
              border: InputBorder.none,
            ),
          )),
          const SizedBox(width: 16.0),
          const Icon(Icons.search, size: 28.0),
        ],
      ),
    );
  }
}
