import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:zenciti/features/home/presentation/blocs/activity_state.dart'; // You forgot to import the state file

import 'package:go_router/go_router.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_populaire_dart.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

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
    // context.read<ActivityPopulaireBloc>().add(ActivityPopulaireGet());
    context.read<RestaurantBloc>().add(RestaurantGetAll());
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
              'All Type of Activities',
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
                            context.push('/home/type/${activity.idTypeActivity}',
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
            const SizedBox(height: 20),
            Text(
              'Zenciti Resturants',
              style: const TextStyle(
                color: AppColors.greenPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<RestaurantBloc, RestaurantState>(
                builder: (context, state) {
                  if (state is RestaurantLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RestaurantFailure) {
                    return const Center(
                        child: Text('Error loading activities.'));
                  } else if (state is RestaurantSuccess) {
                    final restaurants = state.restaurant;

                    if (restaurants.isEmpty) {
                      return const Center(child: Text('No activities found.'));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurants[index] as Restaurant;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              // Navigate to activity details
                              context.push('/home/restaurant/s/${restaurant.idRestaurant}',
                                  extra: restaurant.idRestaurant);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Image.network(
                                    restaurant.image
                                            ?.trim()
                                            .replaceAll('\n', '') ??
                                        'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 180,
                                  ),
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
          ],
        ));
  }
}
