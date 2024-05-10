import 'package:window_rounded_corners/window_rounded_corners.dart';

var deviceCorner = 0.0;
var trackMode = 'поездки';

void setCorners() {
  deviceCorner = WindowCorners.getCorners().bottomRight;
}