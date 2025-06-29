import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/restaurant/domain/entities/restaurant.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class ActivityHistoryPage extends StatefulWidget {
  final String idClient;
  const ActivityHistoryPage({super.key, required this.idClient});

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int activityFilterIndex = 0; // 0=All, 1=Upcoming, 2=Past
  int reservationFilterIndex = 0; // 0=All, 1=Upcoming, 2=Past

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    context.read<ActivityBloc>().add(GetActivityClient(widget.idClient));
    context
        .read<RestaurantBloc>()
        .add(GetReservationsByClient(idClient: widget.idClient));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.grey),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          "My History",
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF00674B),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF00674B),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          tabs: const [
            Tab(text: "Restaurant"),
            Tab(text: "Activities"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RestaurantTab(
            filterIndex: reservationFilterIndex,
            onFilterChanged: (i) => setState(() => reservationFilterIndex = i),
          ),
          _ActivityTab(
            filterIndex: activityFilterIndex,
            onFilterChanged: (i) => setState(() => activityFilterIndex = i),
          ),
        ],
      ),
    );
  }
}

// Restaurant Tab
class _RestaurantTab extends StatelessWidget {
  final int filterIndex;
  final ValueChanged<int> onFilterChanged;
  const _RestaurantTab(
      {required this.filterIndex, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FilterTabs(
          selected: filterIndex,
          onChanged: onFilterChanged,
        ),
        Expanded(
          child: BlocBuilder<RestaurantBloc, RestaurantState>(
            builder: (context, state) {
              if (state is RestaurantLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RestaurantFailure) {
                return Center(child: Text(state.error));
              }
              if (state is ReservationClientSuccess) {
                final now = DateTime.now();
                List<ReservationClient> filtered = state.reservations;
                if (filterIndex == 1) {
                  filtered = filtered
                      .where((r) => DateTime.parse(r.timeFrom).isAfter(now))
                      .toList();
                } else if (filterIndex == 2) {
                  filtered = filtered
                      .where((r) => DateTime.parse(r.timeFrom).isBefore(now))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const Center(child: Text("No reservations found."));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemBuilder: (context, i) {
                    final r = filtered[i];
                    return _RestaurantCard(
                      reservation: r,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => _ReservationQrDialog(
                          reservation: r,
                        ),
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final ReservationClient reservation;
  final VoidCallback? onTap;
  const _RestaurantCard({required this.reservation, this.onTap});

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[600]!;
      case 'pending':
        return Colors.orange[700]!;
      case 'cancelled':
        return Colors.red[600]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Color statusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[50]!;
      case 'pending':
        return Colors.orange[50]!;
      case 'cancelled':
        return Colors.red[50]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color borderColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[600]!;
      case 'pending':
        return Colors.orange[700]!;
      case 'cancelled':
        return Colors.red[600]!;
      default:
        return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dt = DateTime.tryParse(reservation.timeFrom);
    final now = DateTime.now();
    String dateString;
    if (dt != null) {
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        dateString = "Today, ${TimeOfDay.fromDateTime(dt).format(context)}";
      } else if (dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day + 1) {
        dateString = "Tomorrow, ${TimeOfDay.fromDateTime(dt).format(context)}";
      } else {
        dateString = "${[
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ][dt.month - 1]} ${dt.day}, ${TimeOfDay.fromDateTime(dt).format(context)}";
      }
    } else {
      dateString = reservation.timeFrom;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 110,
              decoration: BoxDecoration(
                color: borderColor(reservation.status),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          reservation.restaurantName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBgColor(reservation.status),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            reservation.status,
                            style: TextStyle(
                              color: statusColor(reservation.status),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.calendar,
                            size: 14, color: Color(0xFF00674B)),
                        const SizedBox(width: 7),
                        Text(dateString,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.userGroup,
                            size: 14, color: Color(0xFF00674B)),
                        const SizedBox(width: 7),
                        Text("${reservation.numberOfPeople} People",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.locationDot,
                            size: 14, color: Color(0xFF00674B)),
                        const SizedBox(width: 7),
                        Text("See Map",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 76,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                child: Image.network(
                  reservation.restaurantImage,
                  fit: BoxFit.cover,
                  width: 76,
                  height: 110,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Activities Tab
class _ActivityTab extends StatelessWidget {
  final int filterIndex;
  final ValueChanged<int> onFilterChanged;
  const _ActivityTab(
      {required this.filterIndex, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FilterTabs(
          selected: filterIndex,
          onChanged: onFilterChanged,
        ),
        Expanded(
          child: BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, state) {
              if (state is ActivityLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ActivityFailure) {
                return Center(child: Text(state.error));
              }
              if (state is ActivityClientSuccess) {
                final now = DateTime.now();
                List<ActivityClient> filtered = state.activities;
                if (filterIndex == 1) {
                  filtered = filtered
                      .where((a) => a.timeActivity.isAfter(now))
                      .toList();
                } else if (filterIndex == 2) {
                  filtered = filtered
                      .where((a) => a.timeActivity.isBefore(now))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const Center(child: Text("No activities found."));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemBuilder: (context, i) {
                    final a = filtered[i];
                    return _ActivityCard(
                      activity: a,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => _ActivityQrDialog(activity: a),
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivityClient activity;
  final VoidCallback? onTap;
  const _ActivityCard({required this.activity, this.onTap});

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[600]!;
      case 'pending':
        return Colors.orange[700]!;
      case 'cancelled':
        return Colors.red[600]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Color statusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[50]!;
      case 'pending':
        return Colors.orange[50]!;
      case 'cancelled':
        return Colors.red[50]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color borderColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green[600]!;
      case 'pending':
        return Colors.orange[700]!;
      case 'cancelled':
        return Colors.red[600]!;
      default:
        return Colors.grey[400]!;
    }
  }

  String formattedDate(BuildContext context) {
    final now = DateTime.now();
    if (activity.timeActivity.year == now.year &&
        activity.timeActivity.month == now.month &&
        activity.timeActivity.day == now.day) {
      return "Today, ${TimeOfDay.fromDateTime(activity.timeActivity).format(context)}";
    } else if (activity.timeActivity.year == now.year &&
        activity.timeActivity.month == now.month &&
        activity.timeActivity.day == now.day + 1) {
      return "Tomorrow, ${TimeOfDay.fromDateTime(activity.timeActivity).format(context)}";
    } else {
      return "${[
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ][activity.timeActivity.month - 1]} ${activity.timeActivity.day}, ${TimeOfDay.fromDateTime(activity.timeActivity).format(context)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 90,
              decoration: BoxDecoration(
                color: borderColor(activity.status),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            activity.activityName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBgColor(activity.status),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            activity.status,
                            style: TextStyle(
                              color: statusColor(activity.status),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.calendar,
                            size: 14, color: Color(0xFF00674B)),
                        const SizedBox(width: 8),
                        Text(formattedDate(context),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 64,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                child: Image.network(
                  activity.activityImage,
                  fit: BoxFit.cover,
                  width: 64,
                  height: 90,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reservation QR Dialog
class _ReservationQrDialog extends StatelessWidget {
  final ReservationClient reservation;
  const _ReservationQrDialog({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final accent = const Color(0xFF8EEDC7);
    final dt = DateTime.tryParse(reservation.timeFrom);
    String dateString = reservation.timeFrom;
    if (dt != null) {
      final now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        dateString = "Today, ${TimeOfDay.fromDateTime(dt).format(context)}";
      } else if (dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day + 1) {
        dateString = "Tomorrow, ${TimeOfDay.fromDateTime(dt).format(context)}";
      } else {
        dateString = "${[
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ][dt.month - 1]} ${dt.day}, ${TimeOfDay.fromDateTime(dt).format(context)}";
      }
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 26.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: primary,
              size: 48,
            ),
            const SizedBox(height: 10),
            Text(
              reservation.restaurantName,
              style: TextStyle(
                color: primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              dateString,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: accent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.13),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: QrImageView(
                data: reservation.idReservation,
                version: QrVersions.auto,
                size: 168.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _infoBox(
                    icon: Icons.people_alt_rounded,
                    label: "${reservation.numberOfPeople} People",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoBox(
                    icon: Icons.confirmation_number_rounded,
                    label: reservation.status,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.add, size: 20),
              onPressed: () => {
                context.push('/order', extra: {
                  "idRestaurant": reservation.idRestaurant,
                  "reservationId": reservation.idReservation,
                }),
              },
              label: const Text('Add'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
              label: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF00614B), size: 18),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00614B),
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Activity QR Dialog
class _ActivityQrDialog extends StatelessWidget {
  final ActivityClient activity;
  const _ActivityQrDialog({required this.activity});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final accent = const Color(0xFF8EEDC7);
    String dateString;
    final dt = activity.timeActivity;
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      dateString = "Today, ${TimeOfDay.fromDateTime(dt).format(context)}";
    } else if (dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day + 1) {
      dateString = "Tomorrow, ${TimeOfDay.fromDateTime(dt).format(context)}";
    } else {
      dateString = "${[
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ][dt.month - 1]} ${dt.day}, ${TimeOfDay.fromDateTime(dt).format(context)}";
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 26.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              color: primary,
              size: 48,
            ),
            const SizedBox(height: 10),
            Text(
              activity.activityName,
              style: TextStyle(
                color: primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              dateString,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: accent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.13),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: QrImageView(
                data: activity.idClientActivity,
                version: QrVersions.auto,
                size: 168.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              activity.activityDescription,
              style: const TextStyle(
                  color: Color(0xFF00614B),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
              label: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

// Filter Tabs for both tabs
class _FilterTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _tabButton("All", 0, selected == 0, onChanged),
            _tabButton("Upcoming", 1, selected == 1, onChanged),
            _tabButton("Past", 2, selected == 2, onChanged),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(
      String label, int tabIndex, bool selected, ValueChanged<int> onChanged) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(tabIndex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF00674B) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
