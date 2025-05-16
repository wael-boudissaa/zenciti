
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti_container.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/domain/repositories/restaurant_repo.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_use_case.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class RestaurantDetails extends StatelessWidget {
  const RestaurantDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
        appBar: AppBar(title: const Text("Restaurant Info")),
        body: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RestaurantSingleSuccess) {
              final r = state.restaurant as Restaurant;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          r.image,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) =>
                              const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      r.nameR,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      r.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(height: 40),
                    _infoTile("Location", r.location),
                    _infoTile("Capacity", r.capacity.toString()),
                    _infoTile("Admin ID", r.idAdmineRestaurant),
                    _infoTile("Restaurant ID", r.idRestaurant),
                    ButtonZencitiContainer(
                        textButton: "Reservation",
                      onPressed: () {
                          context.push('/reservation');
                      },
                    ),
                    ButtonZencitiContainer(
                        textButton: "See Menu",
                        onPressed: () {
                            context.push('/restaurant/menu', extra: r.idRestaurant);
                        },
                    ),
                  ],
                ),
              );
            } else if (state is RestaurantFailure) {
              return Center(child: Text(state.error));
            }
            return const SizedBox();
          },
        ),
        );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}
