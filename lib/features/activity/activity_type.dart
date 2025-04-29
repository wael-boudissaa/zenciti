import 'package:flutter/material.dart';
import 'package:zenciti/features/home/domain/entities/activity.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/home/presentation/widgets/navigation_bar.dart';

class ActivityType extends StatefulWidget {
  final TypeActivity activityType;
  // final ActivityTypeModel? activityTypeModel;

  const ActivityType({super.key, required this.activityType});

  @override
  State<ActivityType> createState() => _ActivityTypeState();
}


class _ActivityTypeState extends State<ActivityType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPages(),
      body: Center(
        child: Text('Activity Type Screen'),
      ),
    );
  }
}
