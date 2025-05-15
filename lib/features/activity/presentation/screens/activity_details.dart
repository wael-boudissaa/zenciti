import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_single.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti_container.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';

class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({super.key});

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPages(),

      body: Column(
        children: [
          BlocBuilder<ActivitySingleBloc, ActivityState>(
            builder: (context, state) {
              if (state is ActivityLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ActivitySuccess) {
                if (state.activities.isEmpty) {
                  return const Center(child: Text("No activity found."));
                }

                final activity = state.activities.first;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            activity.imageActivity,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          activity.nameActivity,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.category, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(activity.typeActivity),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text("Popularity: ${activity.popularity}"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(activity.descriptionActivity),
                      ],
                    ),
                  ),
                );
              } else if (state is ActivityFailure) {
                return Center(child: Text("Error: ${state.error}"));
              } else {
                return const Center(child: Text("No data found"));
              }
            },
          ),
          // const SizedBox(height: 20),
          ButtonZencitiContainer(
            textButton: "Book Now",
            onPressed: () {
              // Handle booking action
              context.push('/restaurant/tables',extra: "r1" as String);


              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //       content: Text("Booking functionality not implemented")),
            },
          ),
        ],
      ),
    );
  }
}
