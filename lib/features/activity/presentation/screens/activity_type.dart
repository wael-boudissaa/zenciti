import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.activityType.nameTypeActivity,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                if (state is ActivityLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ActivitySuccess) {
                  final activities = state.activities;

                  if (activities.isEmpty) {
                    return const Center(
                        child: Text("No activities for this type."));
                  }

                  return ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final imageUrl =
                          activity.imageActivity?.trim().replaceAll('\n', '');
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            context.go("/activities/${activity.idActivity}");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  imageUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity.nameActivity,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        activity.descriptionActivity,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Type: ${activity.typeActivity}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  size: 16,
                                                  color: Colors.orange),
                                              const SizedBox(width: 4),
                                              Text(
                                                activity.popularity.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
          ),
        ],
      ),
      // bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
