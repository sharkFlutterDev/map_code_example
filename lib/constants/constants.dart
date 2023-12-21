import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

class Constants {
  static const String ACCESS_TOKEN =
      "sk.eyJ1IjoiZHV5dHJ1b25nMjMiLCJhIjoiY2xxMzZoendmMDhrMjJqcDh0NWZscnh3eCJ9.bmv55PkVcpdicBjwYNLZcw";
  static const String PUBLIC_TOKEN =
      "pk.eyJ1IjoiZHV5dHJ1b25nMjMiLCJhIjoiY2xxMzZmMHRwMDlrcjJqcnNhcHlkd29udiJ9.jMqOTomveRzTEZrNkJzluA";
  final origin = WayPoint(
      name: "Way Point 1",
      latitude: 38.9111117447887,
      longitude: -77.04012393951416,
      isSilent: true);
  final stop1 = WayPoint(
      name: "Way Point 2",
      latitude: 38.91113678979344,
      longitude: -77.03847169876099,
      isSilent: true);
  final stop2 = WayPoint(
      name: "Way Point 3",
      latitude: 38.91040213277608,
      longitude: -77.03848242759705,
      isSilent: false);
  final stop3 = WayPoint(
      name: "Way Point 4",
      latitude: 38.909650771013034,
      longitude: -77.03850388526917,
      isSilent: true);
  final destination = WayPoint(
      name: "Way Point 5",
      latitude: 38.90894949285854,
      longitude: -77.03651905059814,
      isSilent: false);

  final home = WayPoint(
    name: "Home",
    latitude: 10.7675648,
    longitude: 106.6860544,
    isSilent: false,
  );

  final store = WayPoint(
    name: "Store",
    latitude: 10.780980199612054,
    longitude: 106.6456314378483,
    isSilent: false,
  );
}
