import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_populaire_dart.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar.dart';
import 'package:zenciti/features/home/presentation/widgets/restaurant_card.dart';
import 'package:zenciti/features/home/presentation/widgets/search_bar.dart';
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
    context.read<RestaurantBloc>().add(RestaurantGetAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding : const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarHome(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'All Type of Activities',
                  style: TextStyle(
                    color: AppColors.greenPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                        return const Center(
                            child: Text('No activities found.'));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                  '/home/type/${activity.idTypeActivity}',
                                  extra: activity);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: activity.imageActivity !=
                                            null
                                        ? NetworkImage(activity.imageActivity!)
                                        : null,
                                    child: activity.imageActivity == null
                                        ? const Icon(Icons.error)
                                        : null,
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
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Zenciti Restaurants',
                  style: TextStyle(
                    color: AppColors.greenPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<RestaurantBloc, RestaurantState>(
                builder: (context, state) {
                  if (state is RestaurantLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RestaurantFailure) {
                    return const Center(
                        child: Text('Error loading restaurants.'));
                  } else if (state is RestaurantSuccess) {
                    final restaurants = state.restaurant;

                    if (restaurants.isEmpty) {
                      return const Center(child: Text('No restaurants found.'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurants[index];
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: () {
                              context.push(
                                  '/home/restaurant/s/${restaurant.idRestaurant}',
                                  extra: restaurant.idRestaurant);
                            },
                            child: RestaurantCard(restaurant: restaurant),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

