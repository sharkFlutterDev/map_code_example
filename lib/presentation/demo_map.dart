import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:map_code_example/constants/constants.dart';

class DemoMap extends StatefulWidget {
  const DemoMap({super.key});

  @override
  State<DemoMap> createState() => _DemoMapState();
}

class _DemoMapState extends State<DemoMap> {
  final constantLocation = Constants();
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    _navigationOption.language = "en";
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Full Screen Navigation",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Start A to B"),
                  onPressed: () async {
                    var wayPoints = <WayPoint>[];
                    wayPoints.add(constantLocation.home);
                    wayPoints.add(constantLocation.store);
                    var opt = MapBoxOptions.from(_navigationOption);
                    opt.simulateRoute = false;
                    opt.voiceInstructionsEnabled = true;
                    opt.bannerInstructionsEnabled = true;
                    opt.units = VoiceUnits.metric;
                    opt.language = "vi-VN";
                    await MapBoxNavigation.instance
                        .startNavigation(wayPoints: wayPoints, options: opt);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: const Text("Start Multi Stop"),
                  onPressed: () async {
                    _isMultipleStop = true;
                    var wayPoints = <WayPoint>[];
                    wayPoints.add(constantLocation.origin);
                    wayPoints.add(constantLocation.stop1);
                    wayPoints.add(constantLocation.stop2);
                    wayPoints.add(constantLocation.stop3);
                    wayPoints.add(constantLocation.destination);

                    MapBoxNavigation.instance.startNavigation(
                        wayPoints: wayPoints,
                        options: MapBoxOptions(
                            mode: MapBoxNavigationMode.driving,
                            simulateRoute: true,
                            language: "en",
                            allowsUTurnAtWayPoints: true,
                            units: VoiceUnits.metric));
                    //after 10 seconds add a new stop
                    await Future.delayed(const Duration(seconds: 10));
                    var stop = WayPoint(
                        name: "Gas Station",
                        latitude: 38.911176544398,
                        longitude: -77.04014366543564,
                        isSilent: false);
                    MapBoxNavigation.instance.addWayPoints(wayPoints: [stop]);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: const Text("Free Drive"),
                  onPressed: () async {
                    await MapBoxNavigation.instance.startFreeDrive();
                  },
                ),
              ],
            ),
            Container(
              color: Colors.grey,
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Embedded Navigation",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isNavigating
                      ? null
                      : () {
                          if (_routeBuilt) {
                            _controller?.clearRoute();
                          } else {
                            var wayPoints = <WayPoint>[];
                            wayPoints.add(constantLocation.home);
                            wayPoints.add(constantLocation.store);
                            _isMultipleStop = wayPoints.length > 2;
                            _controller?.buildRoute(
                                wayPoints: wayPoints, options: _navigationOption);
                          }
                        },
                  child: Text(_routeBuilt && !_isNavigating ? "Clear Route" : "Build Route"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _routeBuilt && !_isNavigating
                      ? () {
                          _controller?.startNavigation();
                        }
                      : null,
                  child: const Text('Start '),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _isNavigating
                      ? () {
                          _controller?.finishNavigation();
                        }
                      : null,
                  child: const Text('Cancel '),
                )
              ],
            ),
            ElevatedButton(
              onPressed: _inFreeDrive
                  ? null
                  : () async {
                      _inFreeDrive = await _controller?.startFreeDrive() ?? false;
                    },
              child: const Text("Free Drive"),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Long-Press Embedded Map to Set Destination",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text("Duration Remaining: "),
                      Text(_durationRemaining != null
                          ? "${(_durationRemaining! / 60).toStringAsFixed(0)} minutes"
                          : "---")
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text("Distance Remaining: "),
                      Text(_distanceRemaining != null
                          ? "${(_distanceRemaining! * 0.000621371).toStringAsFixed(1)} miles"
                          : "---")
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: MapBoxNavigationView(
                options: _navigationOption,
                onRouteEvent: _onEmbeddedRouteEvent,
                onCreated: (MapBoxNavigationViewController controller) async {
                  _controller = controller;
                  controller.initialize();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
