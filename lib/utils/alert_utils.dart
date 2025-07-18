import 'package:flutter/cupertino.dart';
import 'package:edge_alerts/edge_alerts.dart';
import 'package:flutter/material.dart';

void edgeAlertDialog(BuildContext context, String description) {
  edgeAlert(
    context,
    title: 'LB Connect',
    description: description,
    icon: Icons.warning_amber_rounded,
    gravity: Gravity.top,
    backgroundColor: Colors.blueGrey
  );
}