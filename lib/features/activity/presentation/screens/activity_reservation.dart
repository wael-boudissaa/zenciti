import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_single.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';

final List<String> timeSlots = [
  "11:15",
  "12:00",
  "12:45",
  "13:15",
  "14:15",
  "15:15",
  "16:15",
  "17:00"
];

class ActivityReservation extends StatefulWidget {
  final String activityId;
  final String idClient;

  const ActivityReservation({
    Key? key,
    required this.activityId,
    required this.idClient,
  }) : super(key: key);

  @override
  State<ActivityReservation> createState() => _ActivityReservationState();
}

class _ActivityReservationState extends State<ActivityReservation> {
  DateTime selectedDate = DateTime.now();
  int selectedTimeIndex = 0;

  DateTime get timeActivity {
    final timeString = timeSlots[selectedTimeIndex];
    final hour = int.parse(timeString.split(":")[0]);
    final minute = int.parse(timeString.split(":")[1]);
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    ).toUtc();
  }

  void _submitReservation() {
    if (widget.activityId.isEmpty ||
        widget.idClient.isEmpty ||
        selectedDate == null ||
        selectedTimeIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all required fields.")),
      );
      return;
    }

    context.read<ActivityBloc>().add(
          ActivityCreate(
            widget.activityId,
            widget.idClient,
            timeActivity,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final secondary = const Color(0xFFE6F4F1);
    final accent = const Color(0xFF8EEDC7);
    final emerald = const Color(0xFF047857);

    final bottomSafe = MediaQuery.of(context).viewPadding.bottom;

    return BlocListener<ActivityBloc, ActivityState>(
      listener: (ctx, state) {
        if (state is ActivityLoading) {
          // Optionally show a loading overlay
        } else if (state is ActivityCreatedSuccess) {
          MotionToast.success(
            description: Text("Reservation created successfully!"),
          ).show(ctx);
          context.go('/reservation/qr', extra: {
            "idReservation": state.idClientActivity,
          });
        } else if (state is ActivityFailure) {
          MotionToast.error(
            description: Text(state.error),
          ).show(ctx);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 120 + bottomSafe),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Header
                    Material(
                      elevation: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.arrowLeft,
                                  color: Colors.grey, size: 22),
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Activity Reservation",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Playfair Display",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 23,
                                  color: primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                          ],
                        ),
                      ),
                    ),
                    // Form
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Picker
                          Text("Select Date",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          const SizedBox(height: 8),
                          _HorizontalCalendar(
                            selectedDate: selectedDate,
                            onChanged: (date) =>
                                setState(() => selectedDate = date),
                            primary: primary,
                            secondary: secondary,
                            startDate: DateTime.now(),
                            endDate:
                                DateTime.now().add(const Duration(days: 30)),
                          ),
                          const SizedBox(height: 22),
                          // Time Slots
                          Text("Available Time Slots",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 48,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (c, i) =>
                                  const SizedBox(width: 10),
                              itemCount: timeSlots.length,
                              itemBuilder: (context, idx) {
                                final sel = selectedTimeIndex == idx;
                                final isAccent = idx == 2 || idx == 7;
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: sel
                                        ? emerald
                                        : isAccent
                                            ? accent
                                            : primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: sel
                                        ? BorderSide(color: accent, width: 2)
                                        : BorderSide.none,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                  ),
                                  onPressed: () =>
                                      setState(() => selectedTimeIndex = idx),
                                  child: Text(
                                    timeSlots[idx],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Confirm Button
              Positioned(
                left: 20,
                right: 20,
                bottom: 40 + bottomSafe,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 5,
                    shadowColor: primary.withOpacity(0.16),
                    textStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  onPressed: _submitReservation,
                  icon: const Icon(FontAwesomeIcons.solidCheckCircle, size: 20),
                  label: const Text("Confirm Reservation"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HorizontalCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final Color primary;
  final Color secondary;
  final DateTime startDate;
  final DateTime endDate;

  const _HorizontalCalendar({
    required this.selectedDate,
    required this.onChanged,
    required this.primary,
    required this.secondary,
    required this.startDate,
    required this.endDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalDays = endDate.difference(startDate).inDays + 1;
    final dates = List<DateTime>.generate(
        totalDays, (i) => startDate.add(Duration(days: i)));

    return SizedBox(
      height: 85,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, idx) {
          final date = dates[idx];
          final isSelected = isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () => onChanged(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? primary : secondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat("E").format(date),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white : primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${date.day}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat("MMM").format(date),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white : primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
