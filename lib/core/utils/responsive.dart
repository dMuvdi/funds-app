import 'package:flutter/material.dart';

/// Responsive breakpoint helper
/// Desktop layout when width >= 800px
bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 800;
