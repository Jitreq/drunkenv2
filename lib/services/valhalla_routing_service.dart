import 'package:latlong2/latlong.dart';
import 'package:routing_engine/routing_engine.dart';

class ValhallaRoutingResult {
  final List<LatLng> routePoints;
  final double? distanceMeters;

  const ValhallaRoutingResult({
    required this.routePoints,
    this.distanceMeters,
  });
}

class ValhallaRoutingService {
  ValhallaRoutingService({
    this.host = 'valhalla1.openstreetmap.de',
    this.port = 443,
    this.useHttps = true,
  }) : _engine = ValhallaRoutingEngine(
          baseUrl: '${useHttps ? 'https' : 'http'}://$host${(useHttps && port == 443) || (!useHttps && port == 80) ? '' : ':$port'}',
        );

  final String host;
  final int port;
  final bool useHttps;
  final ValhallaRoutingEngine _engine;

  Future<ValhallaRoutingResult?> getWalkingRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    if (!await _engine.isAvailable()) {
      return null;
    }

    try {
      final result = await _engine.calculateRoute(RouteRequest(
        origin: origin,
        destination: destination,
        costing: 'pedestrian',
        language: 'en-US',
      ));

      if (!result.hasGeometry) {
        return null;
      }

      return ValhallaRoutingResult(
        routePoints: _normalizeRoutePoints(result.shape),
        distanceMeters: result.totalDistanceKm * 1000,
      );
    } catch (_) {
      return null;
    }
  }

  List<LatLng> _normalizeRoutePoints(List<LatLng> points) {
    if (points.isEmpty) {
      return points;
    }

    final normalized = <LatLng>[points.first];
    for (var i = 1; i < points.length; i++) {
      final current = points[i];
      final previous = normalized.last;
      if (current.latitude != previous.latitude ||
          current.longitude != previous.longitude) {
        normalized.add(current);
      }
    }
    return normalized;
  }

  void dispose() {
    _engine.dispose();
  }
}
