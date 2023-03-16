import 'dart:math';

import 'package:flutter/material.dart';
import '../model/activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final activities = <ActivityGroup>[
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomAppBar(padding: EdgeInsets.all(64.0), child: Text('Bottom bar')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            activities.add(ActivityGroup(title: 'Untitled'));
          }),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRect(
              child: Column(
                children: [
                  const SearchBar(),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(child: ActivityGroupCard(activities[index])),
                          const SizedBox(width: 8.0),
                          const IconButton(
                            icon: Icon(Icons.help_outline),
                            onPressed: null,
                          ),
                        ],
                      );
                    },
                    itemCount: activities.length,
                  ))
                ],
              ),
            ),
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
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(16.0),
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
