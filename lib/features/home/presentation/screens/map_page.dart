import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(36.7538, 3.0588); // Algiers default
  LatLng? _currentLocation;
  bool _isLoading = true;
  String? _errorMessage;
  bool _locationPermissionGranted = false;
  
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = "All";
  bool _showLocationsList = false;
  
  final List<String> filterOptions = ["All", "Restaurants", "Activities", "Nearby"];
  
  final List<LocationItem> mockLocations = [
    LocationItem(
      name: "Restaurant La Marina",
      type: "Restaurant",
      distance: "0.5 km",
      rating: 4.5,
      address: "123 Marina Street",
      isOpen: true,
      icon: FontAwesomeIcons.utensils,
      color: Colors.orange,
      position: const LatLng(36.7538, 3.0588),
    ),
    LocationItem(
      name: "Fitness Club Elite",
      type: "Activity",
      distance: "1.2 km",
      rating: 4.8,
      address: "456 Sports Avenue",
      isOpen: true,
      icon: FontAwesomeIcons.dumbbell,
      color: AppColors.primary,
      position: const LatLng(36.7558, 3.0608),
    ),
    LocationItem(
      name: "Café Central",
      type: "Restaurant",
      distance: "0.8 km",
      rating: 4.2,
      address: "789 City Center",
      isOpen: false,
      icon: FontAwesomeIcons.mugHot,
      color: Colors.brown,
      position: const LatLng(36.7518, 3.0568),
    ),
    LocationItem(
      name: "Tennis Court",
      type: "Activity",
      distance: "2.1 km",
      rating: 4.6,
      address: "321 Sports Complex",
      isOpen: true,
      icon: FontAwesomeIcons.baseball,
      color: Colors.green,
      position: const LatLng(36.7578, 3.0628),
    ),
  ];

  Set<Marker> get _markers {
    return filteredLocations.map((location) {
      return Marker(
        markerId: MarkerId(location.name),
        position: location.position,
        infoWindow: InfoWindow(
          title: location.name,
          snippet: '${location.rating} ⭐ • ${location.distance}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          location.type == "Restaurant" 
              ? BitmapDescriptor.hueOrange 
              : BitmapDescriptor.hueBlue,
        ),
        onTap: () => _showLocationDetails(location),
      );
    }).toSet();
  }

  List<LocationItem> get filteredLocations {
    var locations = mockLocations;
    
    if (selectedFilter != "All") {
      locations = locations.where((location) => 
        location.type == selectedFilter.replaceAll("s", "")).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      locations = locations.where((location) => 
        location.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    
    return locations;
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final status = await Permission.location.request();
      
      if (status.isGranted) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          setState(() {
            _errorMessage = 'Location services are disabled.';
            _isLoading = false;
          });
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );

        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _center = _currentLocation!;
          _locationPermissionGranted = true;
          _isLoading = false;
          _errorMessage = null;
        });

        if (_mapController != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_currentLocation!, 15.0),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Location permission denied';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    
    if (_currentLocation != null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15.0),
      );
    }
  }

  void _showLocationDetails(LocationItem location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: location.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            location.icon,
                            color: location.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                location.address,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: location.isOpen ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            location.isOpen ? 'Open' : 'Closed',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          location.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Icon(
                          FontAwesomeIcons.locationPin,
                          color: Colors.grey[500],
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          location.distance,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (location.type == "Restaurant") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Opening ${location.name} restaurant...')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Booking ${location.name} activity...')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          location.type == "Restaurant" ? 'View Restaurant' : 'Book Activity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPages(),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            myLocationEnabled: _locationPermissionGranted,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            markers: _markers,
            zoomControlsEnabled: false,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Loading map...'),
                  ],
                ),
              ),
            ),

          // Search and filters overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search locations...',
                      prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showLocationsList 
                              ? FontAwesomeIcons.xmark 
                              : FontAwesomeIcons.list,
                          size: 16,
                        ),
                        onPressed: () => setState(() {
                          _showLocationsList = !_showLocationsList;
                        }),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterOptions.length,
                    itemBuilder: (context, index) {
                      final filter = filterOptions[index];
                      final isSelected = selectedFilter == filter;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          checkmarkColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Current location button
          Positioned(
            right: 16,
            bottom: _showLocationsList ? 200 : 100,
            child: FloatingActionButton(
              onPressed: () async {
                if (_currentLocation != null && _mapController != null) {
                  await _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentLocation!, 18.0),
                  );
                } else {
                  _initializeLocation();
                }
              },
              backgroundColor: AppColors.primary,
              child: const Icon(
                FontAwesomeIcons.locationCrosshairs,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Locations list overlay
          if (_showLocationsList)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          final location = filteredLocations[index];
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: location.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                location.icon,
                                color: location.color,
                                size: 16,
                              ),
                            ),
                            title: Text(
                              location.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '${location.rating} ⭐ • ${location.distance}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 12,
                              color: Colors.grey[400],
                            ),
                            onTap: () async {
                              await _mapController?.animateCamera(
                                CameraUpdate.newLatLngZoom(location.position, 17.0),
                              );
                              setState(() {
                                _showLocationsList = false;
                              });
                              _showLocationDetails(location);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}

class LocationItem {
  final String name;
  final String type;
  final String distance;
  final double rating;
  final String address;
  final bool isOpen;
  final IconData icon;
  final Color color;
  final LatLng position;

  LocationItem({
    required this.name,
    required this.type,
    required this.distance,
    required this.rating,
    required this.address,
    required this.isOpen,
    required this.icon,
    required this.color,
    required this.position,
  });
}
