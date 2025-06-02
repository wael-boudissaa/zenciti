import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

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

class ReservationPage extends StatefulWidget {
  final Restaurant restaurant;
  final String idClient;

  const ReservationPage({
    Key? key,
    required this.restaurant,
    required this.idClient,
  }) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime selectedDate = DateTime.now();
  int selectedPeople = 2;
  int selectedTimeIndex = 0;
  String? _tableId;
  final requestsController = TextEditingController();

  // Helper to combine date and time slot
  DateTime get timeFrom {
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

  Future<void> _pickTable() async {
    final selectedTable = await context.push<String>(
      '/restaurant/tables',
      extra: {
        'idRestaurant': widget.restaurant.idRestaurant,
        'timeSlot':
            timeFrom.toIso8601String(), // send combined date+time in ISO
      },
    );
    if (selectedTable != null && mounted) {
      setState(() {
        _tableId = selectedTable;
      });
    }
  }

  void _submitReservation() {
    if (widget.idClient.isEmpty ||
        widget.restaurant.idRestaurant.isEmpty ||
        selectedDate == null ||
        selectedTimeIndex == null ||
        selectedPeople <= 0 ||
        _tableId == null ||
        _tableId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all required fields.")),
      );
      return;
    }

    context.read<RestaurantBloc>().add(
          CreateReservation(
            idClient: widget.idClient,
            idRestaurant: widget.restaurant.idRestaurant,
            idTable: _tableId!,
            timeFrom: timeFrom,
            numberOfPeople: int.tryParse(requestsController.text) ?? 1,
          ),
        );
    final reservationData = {
      "idClient": widget.idClient,
      "idRestaurant": widget.restaurant.idRestaurant,
      "idTable": _tableId,
      "numberOfPeople": selectedPeople,
      "timeFrom": timeFrom,
      "specialRequests": requestsController.text,
    };

    // Use context.go or context.push as needed, or trigger your BLoC event here.
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final secondary = const Color(0xFFE6F4F1);
    final accent = const Color(0xFF8EEDC7);
    final teal = const Color(0xFF38B2AC);
    final mint = const Color(0xFF4FD1C5);
    final emerald = const Color(0xFF047857);

    final bottomSafe = MediaQuery.of(context).viewPadding.bottom;

    return BlocListener<RestaurantBloc, RestaurantState>(
        listener: (ctx, state) {
          if (state is RestaurantLoading) {
            // could show a loading overlay if desired
          } else if (state is ReservationSuccess) {
            MotionToast.success(
              description: Text(state.message),
            ).show(ctx);
            context.go('/order', extra: {
              "idRestaurant": widget.restaurant.idRestaurant,
              "reservationId": state.reservationId,
            });
          } else if (state is RestaurantFailure) {
            print('Error: ${state.error}');
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
                  padding: EdgeInsets.only(bottom: 150 + bottomSafe),
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
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  "Reservation",
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
                      // Banner
                      Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 190,
                            child: Image.network(
                              "${widget.restaurant.image}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.restaurant.nameR}",
                                  style: TextStyle(
                                    fontFamily: "Playfair Display",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(FontAwesomeIcons.solidStar,
                                        color: accent, size: 16),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "4.9 (1500+ reviews)",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // FORM
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
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
                            // People Selector
                            Text("Number of People",
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() {
                                      if (selectedPeople > 1) selectedPeople--;
                                    }),
                                    icon: Icon(FontAwesomeIcons.minus,
                                        color: primary),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: const CircleBorder(),
                                      minimumSize: const Size(38, 38),
                                      elevation: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "$selectedPeople",
                                              style: TextStyle(
                                                color: primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " people",
                                              style: TextStyle(
                                                color: teal,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() {
                                      if (selectedPeople < 12) selectedPeople++;
                                    }),
                                    icon: Icon(FontAwesomeIcons.plus,
                                        color: primary),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: const CircleBorder(),
                                      minimumSize: const Size(38, 38),
                                      elevation: 1,
                                    ),
                                  ),
                                ],
                              ),
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
                                  final isMint = idx == 2 || idx == 7;
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: sel
                                          ? emerald
                                          : isMint
                                              ? mint
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
                            const SizedBox(height: 24),
                            // Contact Section
                            TextField(
                              controller: requestsController,
                              minLines: 3,
                              maxLines: 4,
                              decoration: InputDecoration(
                                label: Text("Special Requests (Optional)",
                                    style: TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.w500)),
                                hintText:
                                    "Any special requests or notes for your reservation",
                                filled: true,
                                fillColor: secondary,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 18),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Table Preview
                            Container(
                              padding: const EdgeInsets.all(18),
                              margin: const EdgeInsets.only(bottom: 28),
                              decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Table Selection",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: primary,
                                              fontSize: 16)),
                                      const Spacer(),
                                      TextButton.icon(
                                        onPressed: _pickTable,
                                        icon: Text("View Layout",
                                            style: TextStyle(
                                                color: teal, fontSize: 14)),
                                        label: Icon(FontAwesomeIcons.angleRight,
                                            color: teal, size: 16),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: primary.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(FontAwesomeIcons.table,
                                              color: primary, size: 22),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                _tableId != null
                                                    ? "Table $_tableId"
                                                    : "No table selected",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14)),
                                            Text(
                                                "Available for $selectedPeople people",
                                                style: TextStyle(
                                                    fontSize: 11, color: teal)),
                                          ],
                                        ),
                                        const Spacer(),
                                        if (_tableId != null)
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: accent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(FontAwesomeIcons.check,
                                                color: primary, size: 9),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
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
                  bottom: 76 + bottomSafe,
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
                    onPressed: () {
                      _submitReservation();
                    },
                    icon:
                        const Icon(FontAwesomeIcons.solidCheckCircle, size: 20),
                    label: const Text("Confirm Reservation"),
                  ),
                ),
                // Footer Nav
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Material(
                    elevation: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _footerNavItem(
                              "Home", FontAwesomeIcons.home, true, primary),
                          _footerNavItem("Activities", FontAwesomeIcons.bolt,
                              false, primary),
                          _footerNavItem(
                              "Profile", FontAwesomeIcons.user, false, primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _footerNavItem(
          String label, IconData icon, bool selected, Color primary) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selected ? primary : Colors.grey[400], size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                color: selected ? primary : Colors.grey[400],
                fontSize: 12,
                fontWeight: selected ? FontWeight.w500 : FontWeight.normal),
          )
        ],
      );
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

