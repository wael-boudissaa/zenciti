import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/home/data/models/models.dart';
import 'package:zenciti/features/home/data/repositories/activite_type_repo.dart';
import 'package:zenciti/features/home/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/home/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/home/presentation/blocs/activity_event.dart';
// import 'package:zenciti/features/home/presentation/blocs/activity_state.dart'; // You forgot to import the state file

import 'package:go_router/go_router.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  void initState() {
    super.initState();
    context.read<ActivityTypeBloc>().add(ActivityTypeGet());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchAnchor(
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return Future.value([
                  const ListTile(
                    title: Text("No suggestions yet"),

                  ),
                ]);
              },
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                );
              },
            ),
            const SizedBox(height: 20),

            Text(
              'All Activities',
              style: const TextStyle(
                color: AppColors.greenPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 100,
              child: BlocBuilder<ActivityTypeBloc, ActivityState>(
                builder: (context, state) {
                  if (state is ActivityLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ActivityFailure) {
                    return const Center(
                        child: Text('Error loading activities.'));
                  } else if (state is ActivitySuccess) {
                    final activities = state.activities;

                    if (activities.isEmpty) {
                      return const Center(child: Text('No activities found.'));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to activity details
                            context.go('/home/type/${activity.idTypeActivity}',
                                extra: activity);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                if (activity.imageActivity != null)
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(activity.imageActivity!),
                                    radius: 30,
                                  )
                                else
                                  CircleAvatar(
                                    child: Icon(Icons.error),
                                    radius: 30,
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  activity.nameTypeActivity,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox(); // fallback if no state matches
                  }
                },
              ),
            ),
            // const SizedBox(height: 20),
            Text(
              'Populaire Activities',
              style: const TextStyle(
                color: AppColors.greenPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            // const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<ActivityTypeBloc, ActivityState>(
                builder: (context, state) {
                  if (state is ActivityLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ActivityFailure) {
                    return const Center(
                        child: Text('Error loading activities.'));
                  } else if (state is ActivitySuccess) {
                    final activities = state.activities;

                    if (activities.isEmpty) {
                      return const Center(child: Text('No activities found.'));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(4, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Image.network(
                                  'https://picsum.photos/200',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 180,
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox(); // fallback if no state matches
                  }
                },
              ),
            ),
          ],
        ));
  }
}
