import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/home/domain/entities/activity.dart';
import 'package:zenciti/features/home/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/home/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/home/presentation/widgets/navigation_bar.dart';


class ActivityType extends StatefulWidget {
  final TypeActivity activityType;

  const ActivityType({super.key, required this.activityType});

  @override
  State<ActivityType> createState() => _ActivityTypeState();
}

class _ActivityTypeState extends State<ActivityType> {
  @override
  void initState() {
    super.initState();

    // Fetch activities of this specific type
    context.read<ActivityBloc>().add(
      ActivityGet(widget.activityType.idTypeActivity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPages(),
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state is ActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ActivitySuccess) {
            final activities = state.activities;

            if (activities.isEmpty) {
              return const Center(child: Text("No activities for this type."));
            }

            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  leading: activity.imageActivity != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(activity.imageActivity!),
                        )
                      : const CircleAvatar(child: Icon(Icons.image_not_supported)),
                  title: Text(activity.nameActivity),
                  subtitle: Text(activity.descriptionActivity ?? ''),
                );
              },
            );
          } else if (state is ActivityFailure) {
            return Center(child: Text("Error: ${state.error}"));
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
      // bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
