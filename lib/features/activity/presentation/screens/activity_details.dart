import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_single.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti_container.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final secondary = const Color(0xFFE6F4F1);

    return Scaffold(
      backgroundColor: secondary,
      body: BlocBuilder<ActivitySingleBloc, ActivityState>(
        builder: (context, state) {
          if (state is ActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ActivitySuccess) {
            if (state.activities.isEmpty) {
              return const Center(child: Text("No activity found."));
            }

            final activity = state.activities.first;

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 260,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              activity.imageActivity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 24,
                              child: Text(
                                activity.nameActivity,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black38,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: primary,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Type and popularity
                            Row(
                              children: [
                                Flexible(
                                  child: Chip(
                                    label: Row(
                                      children: [
                                        const Icon(Icons.category,
                                            color: Colors.grey, size: 18),
                                        const SizedBox(width: 6),
                                        Text(activity.typeActivity,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87)),
                                      ],
                                    ),
                                    backgroundColor: Colors.grey[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Chip(
                                    label: Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.orange, size: 18),
                                        const SizedBox(width: 6),
                                        Text(
                                            "Popularity: ${activity.popularity}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87)),
                                      ],
                                    ),
                                    backgroundColor: Colors.orange[50],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              activity.descriptionActivity,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Book Now Button at bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                    color: Colors.white.withOpacity(0.95),
                    child: ButtonZencitiContainer(
                      textButton: "Book Now",
                      onPressed: () {
                        // log("Navigating to reservation page for activity: ${activity.idActivity}");
                        context.push('/activity/reservation', extra: {
                          "activityId": activity.idActivity,
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ActivityFailure) {
            return Center(child: Text("Error: ${state.error}"));
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}
