import 'package:cherry_block/pages/boss_view.dart';
import 'package:cherry_block/pages/contractor_view.dart';
import 'package:cherry_block/pages/cuadrilla_view.dart';
import 'package:cherry_block/pages/packing_view.dart';
import 'package:cherry_block/pages/planillero_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cherry_block/pages/boss_view.dart';
import 'package:cherry_block/pages/cuadrilla_view.dart';
import 'package:cherry_block/pages/packing_view.dart';
import 'package:cherry_block/pages/contractor_view.dart';
import 'package:cherry_block/pages/planillero_view.dart';

class RoleRedirectScreen extends StatelessWidget {
  const RoleRedirectScreen({super.key});

  Future<String?> _getUserRole() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final ref =
        FirebaseFirestore.instance.collection("users").doc(uid);

    final snap = await ref.get();

    if (!snap.exists) return null;

    return snap.data()!["role"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data;

        switch (role) {
          case "dueño":
            return const BossView();
          case "jefe_cuadrilla":
            return const CuadrillaView();
          case "jefe_packing":
            return const PackingView();
          case "contratista":
            return const ContractorView();
          case "planillero":
            return const PlanilleroView();
          default:
            return const Scaffold(
              body: Center(child: Text("Rol no asignado")),
            );
        }
      },
    );
  }
}
