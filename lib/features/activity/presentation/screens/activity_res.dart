import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';

class CourtReservationPage extends StatefulWidget {
  final String activityId;
  final String clientId;
  const CourtReservationPage(
      {super.key, required this.activityId, required this.clientId});

  @override
  State<CourtReservationPage> createState() => _CourtReservationPageState();
}

class _CourtReservationPageState extends State<CourtReservationPage> {
  final List<DateTime> courtDates = List.generate(
    6,
    (i) => DateTime.now().add(Duration(days: i)).copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        ),
  );

  final List<String> timeSlots = [
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM"
  ];

  Set<String> unavailableSlots = {};
  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUnavailableTimes();
  }

  void _fetchUnavailableTimes() {
    final selectedDate = courtDates[selectedDateIndex];
    final String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    log("Fetching unavailable times for date: $dateStr");
    context.read<ActivityBloc>().add(
          GetTimeNotAvailable(widget.activityId, dateStr),
        );
  }

  // NEW IMPLEMENTATION: Manually parse time without DateFormat.jm()
  String slotTo24h(String slot) {
    try {
      // Remove all whitespace and make uppercase
      String normalized = slot.replaceAll(RegExp(r'\s+'), '').toUpperCase();
      final ampm = normalized.endsWith("AM") ? "AM" : "PM";
      final time = normalized.replaceAll(RegExp(r'(AM|PM)'), '');
      final parts = time.split(":");
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      if (ampm == "AM") {
        if (hour == 12) hour = 0;
      } else {
        if (hour != 12) hour += 12;
      }
      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00";
    } catch (e) {
      log("slotTo24h: Error parsing slot '$slot': $e");
      return "00:00:00";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF00614B);
    final Color secondary = const Color(0xFFF0F7F4);
    final Color available = const Color(0xFF4CAF50);
    final Color unavailable = const Color(0xFFF44336);
    final Color selectedColor = const Color(0xFF2196F3);

    final selectedDate = courtDates[selectedDateIndex];
    final selectedTime = timeSlots[selectedTimeIndex];

    String getSelectedSummary() {
      final date = selectedDate;
      final dow = DateFormat('EEEE').format(date);
      final day = DateFormat('d').format(date);
      final month = DateFormat('MMM').format(date);
      return "$dow, $day $month • $selectedTime";
    }

    Widget buildDateItem(DateTime date, int idx) {
      final isSelected = selectedDateIndex == idx;
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedDateIndex = idx;
          });
          _fetchUnavailableTimes();
        },
        child: Container(
          width: 65,
          margin: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            color: isSelected ? primary : secondary,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                DateFormat('E').format(date).toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('d').format(date),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMM').format(date).toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildSlot(String slot, int idx) {
      final slotKey = slotTo24h(slot);
      final isBooked = unavailableSlots.contains(slotKey);
      final isSelected = selectedTimeIndex == idx;

      Color borderColor;
      if (isBooked) {
        borderColor = unavailable;
      } else if (isSelected) {
        borderColor = selectedColor;
      } else {
        borderColor = available;
      }

      return GestureDetector(
        onTap: isBooked ? null : () => setState(() => selectedTimeIndex = idx),
        child: Container(
          decoration: BoxDecoration(
            color: isBooked
                ? Colors.grey[100]
                : (isSelected ? selectedColor.withOpacity(0.12) : secondary),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getTimeIcon(slot),
                color: _getTimeIconColor(slot),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                slot,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isBooked
                      ? Colors.grey[500]
                      : isSelected
                          ? selectedColor
                          : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BlocListener<ActivityBloc, ActivityState>(
      listener: (ctx, state) {
        if (state is ActivityLoading) {
        } else if (state is ActivityCreatedSuccess) {
          MotionToast.success(
            description: Text("Activity Created"),
          ).show(ctx);
          context.go('/reservation/qr', extra: state.idClientActivity);
        } else if (state is ActivityFailure) {
        } else if (state is TimeSlotNotAvailable) {
          setState(() {
            unavailableSlots = state.listTimeNotAvailable.toSet();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.chevronLeft,
                              size: 18, color: Color(0xFF1A2E35)),
                          onPressed: () => Navigator.of(context).maybePop(),
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Court Reservation",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2E35),
                          ),
                        ),
                        const Spacer(),
                        Icon(FontAwesomeIcons.solidCalendarDays,
                            color: primary, size: 20),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://storage.googleapis.com/uxpilot-auth.appspot.com/565b7f0879-be5b594d3b9b67e05e4a.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Green Park Tennis",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.mapMarkerAlt,
                                      size: 12, color: Color(0xFF00674B)),
                                  const SizedBox(width: 6),
                                  const Text("Downtown ZenCiti",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(
                                        4,
                                        (index) => const Icon(Icons.star,
                                            color: Color(0xFFFFD700),
                                            size: 14)),
                                  ),
                                  const Icon(Icons.star_half,
                                      color: Color(0xFFFFD700), size: 14),
                                  const SizedBox(width: 8),
                                  const Text("4.5",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                  const SizedBox(width: 4),
                                  const Text("(48)",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SELECT DATE",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: courtDates.length,
                            itemBuilder: (context, idx) =>
                                buildDateItem(courtDates[idx], idx),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SELECT TIME",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            timeSlots.length,
                            (idx) => SizedBox(
                              width: 140,
                              child: buildSlot(timeSlots[idx], idx),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _legendDot(available),
                            const SizedBox(width: 16),
                            _legendDot(unavailable),
                            const SizedBox(width: 16),
                            _legendDot(selectedColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 110),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Selected Time",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13)),
                                const SizedBox(height: 2),
                                Text(getSelectedSummary(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A2E35),
                                    )),
                              ],
                            ),
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: "\$12",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF00674B))),
                                TextSpan(
                                    text: "/hr",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          elevation: 1,
                        ),
                        onPressed: _submitReservation,
                        child: const Text("Confirm Reservation"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReservation() {
    final selectedDate = courtDates[selectedDateIndex];
    final timeSlot = timeSlots[selectedTimeIndex];
    final timeParts = timeSlot
        .replaceAll(RegExp(r'\s+'), '')
        .toUpperCase()
        .replaceAll(RegExp(r'(AM|PM)'), '')
        .split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    final isPM = timeSlot.toUpperCase().contains("PM") && hour != 12;
    if (isPM) hour += 12;
    if (timeSlot.toUpperCase().contains("AM") && hour == 12) hour = 0;
    final reservationDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    ).toUtc();

    context.read<ActivityBloc>().add(
          ActivityCreate(
            widget.activityId,
            widget.clientId,
            reservationDateTime,
          ),
        );
  }

  IconData _getTimeIcon(String time) {
    final hour = int.parse(time.split(":")[0]);
    if (hour < 12) return FontAwesomeIcons.solidSun;
    if (hour < 17) return FontAwesomeIcons.cloudSun;
    return FontAwesomeIcons.moon;
  }

  Color _getTimeIconColor(String time) {
    final hour = int.parse(time.split(":")[0]);
    if (hour < 12) return Colors.amber;
    if (hour < 17) return Colors.blue;
    return Colors.indigo;
  }

  Widget _legendDot(Color color) {
    return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
