import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/home/presentation/blocs/map_bloc.dart';
import 'package:zenciti/features/home/presentation/blocs/map_event.dart';
import 'package:zenciti/features/home/presentation/blocs/map_state.dart';
import 'package:zenciti/features/home/domain/entities/map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class NavigationStep {
  final String instruction;
  final String maneuver;
  final double distanceMeters;
  final int durationSeconds;
  final LatLng startLocation;
  final LatLng endLocation;

  NavigationStep({
    required this.instruction,
    required this.maneuver,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.startLocation,
    required this.endLocation,
  });
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
  final String imageUrl;

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
    required this.imageUrl,
  });

  factory LocationItem.fromMapInformation(MapInformation info) {
    return LocationItem(
      name: info.name,
      type: info.type,
      distance: info.distanceFormatted,
      rating: 0,
      address: info.address,
      isOpen: true,
      icon: info.type.toLowerCase() == "restaurant"
          ? FontAwesomeIcons.utensils
          : FontAwesomeIcons.dumbbell,
      color: AppColors.primary,
      position: LatLng(info.latitude, info.longitude),
      imageUrl: info.imageUrl,
    );
  }
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(36.7538, 3.0588);
  LatLng? _currentLocation;
  bool _isLoadingLocation = true; // Separate loading state for location
  String? _errorMessage;
  bool _locationPermissionGranted = false;
  bool _showingRoute = false;
  List<LatLng> _routePoints = [];
  LocationItem? _selectedDestination;
  List<NavigationStep> _navigationSteps = [];
  int _currentStepIndex = 0;
  StreamSubscription<Position>? _positionStreamSubscription;
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = "All";
  bool _showLocationsList = false;
  final List<String> filterOptions = [
    "All",
    "Restaurants",
    "Activities",
    "Nearby"
  ];

  List<LocationItem> _locations = [];
  bool _hasInitialized = false; // Prevent multiple initializations

  static const String _googleMapsApiKey =
      'AIzaSyDcs_Pwq_BzeHhatRYtxm4df8E0uiAbnec';

  Set<Marker> get _markers {
    Set<Marker> markers = {};
    for (var location in filteredLocations) {
      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: location.position,
          infoWindow: InfoWindow(
            title: location.name,
            snippet: '${location.rating} ⭐ • ${location.distance}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          onTap: () => _showLocationDetails(location),
        ),
      );
    }
    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }
    return markers;
  }

  Set<Polyline> get _polylines {
    if (!_showingRoute || _routePoints.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _routePoints,
        color: AppColors.primary,
        width: 5,
        patterns: [],
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  List<LocationItem> get filteredLocations {
    var locations = _locations;
    if (selectedFilter != "All") {
      locations = locations
          .where(
              (location) => location.type == selectedFilter.replaceAll("s", ""))
          .toList();
    }
    if (_searchController.text.isNotEmpty) {
      locations = locations
          .where((location) => location.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }
    return locations;
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _startLocationStream();
  }

  Future<void> _initializeLocation() async {
    // Prevent multiple initializations
    if (_hasInitialized) return;
    _hasInitialized = true;

    try {
      print('🔍 Starting location initialization...');

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location services are disabled');
        if (mounted) {
          setState(() {
            _errorMessage =
                'Location services are disabled. Please enable them in settings.';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print('📍 Current permission: $permission');

      if (permission == LocationPermission.denied) {
        print('📍 Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('📍 Permission after request: $permission');
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('❌ Location permission denied');
        if (mounted) {
          setState(() {
            _errorMessage =
                'Location permission denied. Please enable location access in settings.';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      print('📍 Getting current position...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      print('📍 Got location: ${position.latitude}, ${position.longitude}');
      print('📍 Accuracy: ${position.accuracy}m');

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _center = _currentLocation!;
          _locationPermissionGranted = true;
          _isLoadingLocation = false;
          _errorMessage = null;
        });

        // Auto-zoom to user location when map is ready
        if (_mapController != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_currentLocation!, 16.0),
          );
          print('📍 Map centered on user location');
        }

        // Fetch nearby locations from your database using the bloc
        context.read<MapBloc>().add(MapSubmitted(
              longitude: position.longitude,
              latitude: position.latitude,
            ));
      }
    } catch (e) {
      print('❌ Location error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error getting location: $e';
          _isLoadingLocation = false;
        });

        // Try to get last known position as fallback
        try {
          Position? lastPosition = await Geolocator.getLastKnownPosition();
          if (lastPosition != null && mounted) {
            print(
                '📍 Using last known position: ${lastPosition.latitude}, ${lastPosition.longitude}');
            setState(() {
              _currentLocation =
                  LatLng(lastPosition.latitude, lastPosition.longitude);
              _center = _currentLocation!;
              _locationPermissionGranted = true;
              _isLoadingLocation = false;
              _errorMessage = null;
            });

            // Fetch locations for last known position
            context.read<MapBloc>().add(MapSubmitted(
                  longitude: lastPosition.longitude,
                  latitude: lastPosition.latitude,
                ));

            if (_mapController != null) {
              await _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(_currentLocation!, 16.0),
              );
            }
          }
        } catch (e2) {
          print('❌ Could not get last known position: $e2');
        }
      }
    }
  }

  void _startLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        print(
            '📍 Location updated: ${position.latitude}, ${position.longitude}');
        if (mounted) {
          setState(() {
            _currentLocation = LatLng(position.latitude, position.longitude);
          });
        }
      },
      onError: (error) {
        print('❌ Location stream error: $error');
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    // If we already have location, zoom to it
    if (_currentLocation != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16.0),
      );
    }
  }

  Future<void> _showRoute(LocationItem destination) async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current location not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Use a separate loading state for route generation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      List<LatLng> route =
          await _generateRoute(_currentLocation!, destination.position);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        setState(() {
          _showingRoute = true;
          _routePoints = route;
          _selectedDestination = destination;
        });

        _fitMapToRoute();
        _showRouteDetails(destination);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading route: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<List<LatLng>> _generateRoute(LatLng start, LatLng end) async {
    try {
      final String url =
          'https://routes.googleapis.com/directions/v2:computeRoutes';
      final Map<String, dynamic> requestBody = {
        "origin": {
          "location": {
            "latLng": {"latitude": start.latitude, "longitude": start.longitude}
          }
        },
        "destination": {
          "location": {
            "latLng": {"latitude": end.latitude, "longitude": end.longitude}
          }
        },
        "travelMode": "DRIVE",
        "routingPreference": "TRAFFIC_AWARE",
        "computeAlternativeRoutes": false,
        "routeModifiers": {
          "avoidTolls": false,
          "avoidHighways": false,
          "avoidFerries": false
        },
        "languageCode": "en-US",
        "units": "METRIC"
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _googleMapsApiKey,
          'X-Goog-FieldMask':
              'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline,routes.legs.steps.navigationInstruction,routes.legs.steps.localizedValues,routes.legs.steps.staticDuration,routes.legs.steps.distanceMeters,routes.legs.steps.startLocation,routes.legs.steps.endLocation,routes.legs.steps.polyline.encodedPolyline'
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          _navigationSteps = [];

          if (route['legs'] != null && route['legs'].isNotEmpty) {
            for (var leg in route['legs']) {
              if (leg['steps'] != null) {
                for (var step in leg['steps']) {
                  String instruction = 'Continue straight';
                  String maneuver = 'straight';

                  if (step['navigationInstruction'] != null) {
                    instruction = step['navigationInstruction']
                            ['instructions'] ??
                        'Continue';
                    maneuver =
                        step['navigationInstruction']['maneuver'] ?? 'straight';
                  }

                  double distance = (step['distanceMeters'] ?? 0).toDouble();
                  int duration = step['staticDuration'] != null
                      ? int.parse(step['staticDuration'].replaceAll('s', ''))
                      : 0;

                  LatLng startLoc = LatLng(
                    step['startLocation']['latLng']['latitude'],
                    step['startLocation']['latLng']['longitude'],
                  );
                  LatLng endLoc = LatLng(
                    step['endLocation']['latLng']['latitude'],
                    step['endLocation']['latLng']['longitude'],
                  );

                  _navigationSteps.add(NavigationStep(
                    instruction: instruction,
                    maneuver: maneuver,
                    distanceMeters: distance,
                    durationSeconds: duration,
                    startLocation: startLoc,
                    endLocation: endLoc,
                  ));
                }
              }
            }
          }

          _currentStepIndex = 0;
          final String polylinePoints = route['polyline']['encodedPolyline'];
          List<LatLng> routePoints = decodePolyline(polylinePoints)
              .map((point) => LatLng(point[0].toDouble(), point[1].toDouble()))
              .toList();

          return routePoints;
        }
      }
    } catch (e) {
      print('❌ Error generating route: $e');
    }

    // Fallback to direct line if API fails
    return [start, end];
  }

  void _fitMapToRoute() {
    if (_routePoints.isEmpty || _mapController == null) return;

    double minLat = _routePoints.first.latitude;
    double maxLat = _routePoints.first.latitude;
    double minLng = _routePoints.first.longitude;
    double maxLng = _routePoints.first.longitude;

    for (LatLng point in _routePoints) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0,
      ),
    );
  }

  void _showRouteDetails(LocationItem destination) {
    double distance = Geolocator.distanceBetween(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      destination.position.latitude,
      destination.position.longitude,
    );
    double distanceKm = distance / 1000;
    int estimatedTime = (distanceKm * 3).round();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              child: SingleChildScrollView(
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
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.route,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Route to Destination',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  destination.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.xmark,
                              size: 18,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _showingRoute = false;
                                _routePoints.clear();
                                _selectedDestination = null;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.road,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${distanceKm.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Text(
                                  'Distance',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.clock,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$estimatedTime min',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Text(
                                  'Est. Time',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.car,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Driving',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Text(
                                  'Transport',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _startNavigation(destination);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.locationArrow,
                            size: 16,
                          ),
                          label: const Text(
                            'Start Navigation',
                            style: TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }

  void _startNavigation(LocationItem destination) {
    if (_navigationSteps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No navigation steps available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _currentStepIndex = 0;
    });

    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!_showingRoute || _navigationSteps.isEmpty) {
        timer.cancel();
        return;
      }

      if (mounted) {
        setState(() {
          if (_currentStepIndex < _navigationSteps.length - 1) {
            _currentStepIndex++;
          } else {
            timer.cancel();
            _showNavigationComplete(destination);
          }
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation started to ${destination.name}'),
        backgroundColor: AppColors.primary,
        action: SnackBarAction(
          label: 'Stop',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _showingRoute = false;
              _routePoints.clear();
              _selectedDestination = null;
              _navigationSteps.clear();
              _currentStepIndex = 0;
            });
          },
        ),
      ),
    );
  }

  void _showNavigationComplete(LocationItem destination) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have arrived at ${destination.name}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLocationDetails(LocationItem location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.xmark,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                location.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: location.isOpen
                                        ? AppColors.primary
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    location.isOpen ? 'Open' : 'Closed',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              location.icon,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.type,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Premium ${location.type.toLowerCase()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.solidStar,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    location.rating.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(124 reviews)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.locationDot,
                                  color: AppColors.primary,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  location.distance,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              FontAwesomeIcons.locationPin,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Address',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    location.address,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showRoute(location);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.route,
                              size: 16,
                            ),
                            label: const Text(
                              'Get Directions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _navigateToLocationPage(location);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                      color: AppColors.primary),
                                ),
                              ),
                              icon: Icon(
                                location.type == "Restaurant"
                                    ? FontAwesomeIcons.utensils
                                    : FontAwesomeIcons.calendar,
                                size: 16,
                              ),
                              label: Text(
                                location.type == "Restaurant"
                                    ? 'View Menu'
                                    : 'Book Now',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
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
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapSuccess) {
          // Only update locations, don't change loading state
          setState(() {
            _locations = state.locations
                .map((e) => LocationItem.fromMapInformation(e))
                .toList();
          });
          print('📍 Loaded ${_locations.length} locations from database');
        } else if (state is MapFailure) {
          print('❌ Failed to load locations: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load nearby locations: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        // Don't handle MapLoading here to avoid loading loop
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildCustomAppBar(),
          body: Stack(
            children: [
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
                polylines: _polylines,
                zoomControlsEnabled: false,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: true,
              ),

              // Location loading overlay - only show when getting location
              if (_isLoadingLocation)
                Container(
                  color: Colors.white.withOpacity(0.9),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                            color: AppColors.primary),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage ?? 'Getting your location...',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _hasInitialized = false;
                              _isLoadingLocation = true;
                              _errorMessage = null;
                            });
                            _initializeLocation();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Route info banner
              if (_showingRoute && _selectedDestination != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.route,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Navigation Active',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'To ${_selectedDestination!.name}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.xmark,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showingRoute = false;
                                  _routePoints.clear();
                                  _selectedDestination = null;
                                  _navigationSteps.clear();
                                  _currentStepIndex = 0;
                                });
                              },
                            ),
                          ],
                        ),

                        // Navigation instruction
                        if (_navigationSteps.isNotEmpty &&
                            _currentStepIndex < _navigationSteps.length)
                          const SizedBox(height: 12),
                        if (_navigationSteps.isNotEmpty &&
                            _currentStepIndex < _navigationSteps.length)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getManeuverIcon(
                                        _navigationSteps[_currentStepIndex]
                                            .maneuver),
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _navigationSteps[_currentStepIndex]
                                            .instruction,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Next step',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${(_navigationSteps[_currentStepIndex].distanceMeters).round()}m',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Search and filters (only show when not navigating and not loading)
              if (!_showingRoute && !_isLoadingLocation)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search restaurants & activities...',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showLocationsList
                                    ? FontAwesomeIcons.xmark
                                    : FontAwesomeIcons.list,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              onPressed: () => setState(() {
                                _showLocationsList = !_showLocationsList;
                              }),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey[300]!,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        selectedFilter = filter;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Text(
                                        filter,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Current location button
              if (!_isLoadingLocation)
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          if (_currentLocation != null &&
                              _mapController != null) {
                            await _mapController!.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                  _currentLocation!, 18.0),
                            );
                          } else {
                            setState(() {
                              _hasInitialized = false;
                              _isLoadingLocation = true;
                              _errorMessage = null;
                            });
                            _initializeLocation();
                          }
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          child: const Icon(
                            FontAwesomeIcons.locationCrosshairs,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Locations list overlay
              if (_showLocationsList && !_showingRoute && !_isLoadingLocation)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -4),
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
                          child: filteredLocations.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No locations found nearby',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: filteredLocations.length,
                                  itemBuilder: (context, index) {
                                    final location = filteredLocations[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color: Colors.grey[200]!),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        leading: Icon(
                                          location.icon,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                        title: Text(
                                          location.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.solidStar,
                                                  color: Colors.amber,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${location.rating}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '• ${location.distance}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: location.isOpen
                                                ? AppColors.primary
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            location.isOpen ? 'Open' : 'Closed',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          if (_mapController != null) {
                                            await _mapController!.animateCamera(
                                              CameraUpdate.newLatLngZoom(
                                                  location.position, 17.0),
                                            );
                                          }
                                          setState(() {
                                            _showLocationsList = false;
                                          });
                                          _showLocationDetails(location);
                                        },
                                      ),
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
      },
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Explore Map',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                      Text(
                        'Find restaurants & activities',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getManeuverIcon(String maneuver) {
    switch (maneuver.toLowerCase()) {
      case 'turn-right':
      case 'turn_right':
        return FontAwesomeIcons.arrowRight;
      case 'turn-left':
      case 'turn_left':
        return FontAwesomeIcons.arrowLeft;
      case 'straight':
      case 'continue':
        return FontAwesomeIcons.arrowUp;
      case 'slight-right':
      case 'slight_right':
        return FontAwesomeIcons.arrowTrendUp;
      case 'slight-left':
      case 'slight_left':
        return FontAwesomeIcons.arrowTrendUp;
      case 'sharp-right':
      case 'sharp_right':
        return FontAwesomeIcons.arrowRightFromBracket;
      case 'sharp-left':
      case 'sharp_left':
        return FontAwesomeIcons.arrowLeft;
      case 'u-turn':
      case 'u_turn':
        return FontAwesomeIcons.arrowRotateLeft;
      case 'roundabout':
        return FontAwesomeIcons.circle;
      case 'merge':
        return FontAwesomeIcons.codeMerge;
      case 'fork':
        return FontAwesomeIcons.codeFork;
      case 'exit':
        return FontAwesomeIcons.rightFromBracket;
      default:
        return FontAwesomeIcons.arrowUp;
    }
  }

  void _navigateToLocationPage(LocationItem location) {
    if (location.type == "Restaurant") {
      context.push('/home/restaurant/s/${location.name}');
    } else {
      context.push('/activity/${location.name}');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
