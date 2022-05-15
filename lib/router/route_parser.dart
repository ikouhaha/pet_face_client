import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    var location = routeInformation.location;
    return SynchronousFuture(location!);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}