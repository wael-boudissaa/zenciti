import 'package:flutter/material.dart';

// ---------- MOCK DATA STRUCTURE (replace with your ReservationInformation model) -----------

class ReservationInformation {
  final String restaurantName;
  final String restaurantImageUrl;
  final String bookingStatus;
  final String bookingStatusColor;
  final String bookingDateTime;
  final int partySize;
  final String table;
  final String bookingId;
  final List<OrderItem> orderItems;
  final String address;
  final String phone;
  final double subtotal;
  final double tax;
  final double serviceFee;
  final double total;
  final double rating;
  final int reviews;

  ReservationInformation({
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.bookingStatus,
    required this.bookingStatusColor,
    required this.bookingDateTime,
    required this.partySize,
    required this.table,
    required this.bookingId,
    required this.orderItems,
    required this.address,
    required this.phone,
    required this.subtotal,
    required this.tax,
    required this.serviceFee,
    required this.total,
    required this.rating,
    required this.reviews,
  });
}

class OrderItem {
  final String name;
  final String subtitle;
  final String imgUrl;
  final double price;
  final int count;

  OrderItem({
    required this.name,
    required this.subtitle,
    required this.imgUrl,
    required this.price,
    required this.count,
  });
}

// ---------- MAIN COMPONENT -----------

class ReservationInformationPage extends StatefulWidget {
  final ReservationInformation reservation;
  const ReservationInformationPage({Key? key, required this.reservation})
      : super(key: key);

  @override
  State<ReservationInformationPage> createState() =>
      _ReservationInformationPageState();
}

class _ReservationInformationPageState
    extends State<ReservationInformationPage> {
  bool showMapModal = false;

  @override
  Widget build(BuildContext context) {
    final res = widget.reservation;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reservation Details',
            style: TextStyle(
                fontFamily: 'Playfair Display',
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                .copyWith(bottom: 120),
            children: [
              RestaurantInfoCard(
                name: res.restaurantName,
                imageUrl: res.restaurantImageUrl,
                status: res.bookingStatus,
                statusColor: res.bookingStatusColor,
                rating: res.rating,
                reviews: res.reviews,
                address: res.address,
                phone: res.phone,
                onMapPressed: () => setState(() => showMapModal = true),
              ),
              const SizedBox(height: 16),
              ReservationInformationCard(
                dateTime: res.bookingDateTime,
                partySize: res.partySize,
                table: res.table,
                bookingId: res.bookingId,
              ),
              const SizedBox(height: 16),
              OrderDetailsCard(
                items: res.orderItems,
                subtotal: res.subtotal,
                tax: res.tax,
                serviceFee: res.serviceFee,
                total: res.total,
              ),
              const SizedBox(height: 16),
              ActionButtons(),
            ],
          ),
          if (showMapModal)
            MapModal(
              imageUrl:
                  "https://storage.googleapis.com/uxpilot-auth.appspot.com/19bdab6f9c-6e66374d2dde973cf007.png",
              restaurantName: res.restaurantName,
              onClose: () => setState(() => showMapModal = false),
            ),
        ],
      ),
    );
  }
}

// ---------- COMPONENTS -----------

class RestaurantInfoCard extends StatelessWidget {
  final String name, imageUrl, status, statusColor, address, phone;
  final double rating;
  final int reviews;
  final VoidCallback onMapPressed;
  const RestaurantInfoCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.status,
    required this.statusColor,
    required this.rating,
    required this.reviews,
    required this.address,
    required this.phone,
    required this.onMapPressed,
  });

  Color getStatusColor() {
    switch (statusColor) {
      case "green":
        return Colors.green.shade100;
      case "red":
        return Colors.red.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(5, (i) {
                      if (i < rating.floor()) {
                        return const Icon(Icons.star,
                            color: Color(0xFFFFD700), size: 16);
                      } else if (i < rating && rating % 1 != 0) {
                        return const Icon(Icons.star_half,
                            color: Color(0xFFFFD700), size: 16);
                      } else {
                        return const Icon(Icons.star_border,
                            color: Color(0xFFFFD700), size: 16);
                      }
                    }),
                    const SizedBox(width: 8),
                    Text("($reviews reviews)",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF00674B), size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(address,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Color(0xFF00674B), size: 18),
                    const SizedBox(width: 6),
                    Text(phone,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onMapPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00674B),
                      side: const BorderSide(color: Color(0xFF00674B)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.map),
                    label: const Text("View on Map"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationInformationCard extends StatelessWidget {
  final String dateTime;
  final int partySize;
  final String table;
  final String bookingId;
  const ReservationInformationCard({
    super.key,
    required this.dateTime,
    required this.partySize,
    required this.table,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reservation Details",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
            const SizedBox(height: 14),
            _DetailItem(
              icon: Icons.calendar_today_outlined,
              label: "Date & Time",
              value: dateTime,
            ),
            _DetailItem(
              icon: Icons.group,
              label: "Party Size",
              value: "$partySize People",
            ),
            _DetailItem(
              icon: Icons.restaurant,
              label: "Table",
              value: table,
            ),
            _DetailItem(
              icon: Icons.receipt_long,
              label: "Booking ID",
              value: bookingId,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _DetailItem(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF00674B).withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00674B)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderDetailsCard extends StatelessWidget {
  final List<OrderItem> items;
  final double subtotal, tax, serviceFee, total;
  const OrderDetailsCard({
    super.key,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.serviceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Order",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(item.imgUrl,
                            width: 56, height: 56, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text(item.subtitle,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("\$${item.price.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          Text("x${item.count}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 18),
            Divider(),
            _OrderSummary(label: "Subtotal", value: subtotal),
            _OrderSummary(label: "Tax", value: tax),
            _OrderSummary(label: "Service Fee", value: serviceFee),
            const SizedBox(height: 4),
            Divider(),
            _OrderSummary(label: "Total", value: total, isTotal: true),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  const _OrderSummary(
      {required this.label, required this.value, this.isTotal = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                  fontSize: isTotal ? 17 : 13)),
          Text("\$${value.toStringAsFixed(2)}",
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                  fontSize: isTotal ? 17 : 13)),
        ],
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF00674B),
              side: const BorderSide(color: Color(0xFF00674B)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.edit),
            label: const Text("Modify"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00674B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.qr_code),
            label: const Text("Show QR Code"),
          ),
        ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavIcon(
      {required this.icon, required this.label, required this.active});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,
            color: active ? const Color(0xFF00674B) : Colors.grey, size: 28),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: active ? const Color(0xFF00674B) : Colors.grey)),
      ],
    );
  }
}

// --------- MAP MODAL -----------
class MapModal extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;
  final VoidCallback onClose;
  const MapModal(
      {super.key,
      required this.imageUrl,
      required this.restaurantName,
      required this.onClose});
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.7),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(restaurantName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          IconButton(
                            icon: const Icon(Icons.close,
                                size: 28, color: Colors.grey),
                            onPressed: onClose,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(0)),
                            child: Image.network(imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover),
                          ),
                          Positioned(
                            bottom: 24,
                            right: 24,
                            child: Column(
                              children: [
                                _MapActionButton(icon: Icons.add, onTap: () {}),
                                const SizedBox(height: 8),
                                _MapActionButton(
                                    icon: Icons.remove, onTap: () {}),
                                const SizedBox(height: 8),
                                _MapActionButton(
                                    icon: Icons.my_location, onTap: () {}),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00674B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.directions),
                          label: const Text("Get Directions"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapActionButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(99),
      elevation: 6,
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
              child: Icon(icon, color: const Color(0xFF00674B), size: 24)),
        ),
      ),
    );
  }
}
