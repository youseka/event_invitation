import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'guest_book_message.dart';

enum Attending { yes, no, unknown }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  /// The AplicationState class is a ChangeNotifier class that manages the state of the application.
  /// It has a series of properties that represent the state of the application,
  /// such as whether the user is logged in, the number of attendees, and the user's attendance status.
  /// It also has a list of guest book messages that are displayed in the app.
  // ---------------------------------
  // Propiedades del estado
  // ---------------------------------
  bool _loggedIn = false;
  int _attendees = 0;
  Attending _attending = Attending.unknown;

  List<GuestBookMessage> _guestBookMessages = [];
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;

  // Getters públicos para acceder al estado
  bool get loggedIn => _loggedIn;
  int get attendees => _attendees;
  Attending get attending => _attending;
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  // ---------------------------------
  // Métodos principales
  // ---------------------------------
  Future<void> init() async {
    // Inicializa Firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Configura los proveedores de autenticación
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    // Escucha los cambios de usuario
    _listenToAuthChanges();

    // Escucha los cambios en la colección 'attendees'
    _listenToAttendeeCount();
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('guestbook').add({
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    userDoc.set({'attending': attending == Attending.yes});
  }

  // ---------------------------------
  // Métodos privados
  // ---------------------------------
  void _listenToAuthChanges() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        // Usuario autenticado
        _loggedIn = true;

        // Escucha los mensajes del Guest Book
        _listenToGuestBookMessages();

        // Escucha el estado de asistencia del usuario
        _listenToUserAttendance(user.uid);
      } else {
        // Usuario no autenticado
        _loggedIn = false;

        // Limpia los datos y cancela las suscripciones
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _attendingSubscription?.cancel();
      }

      notifyListeners();
    });
  }

  void _listenToGuestBookMessages() {
    _guestBookSubscription = FirebaseFirestore.instance
        .collection('guestbook')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _guestBookMessages = snapshot.docs.map((doc) {
        return GuestBookMessage(
          name: doc.data()['name'] as String,
          message: doc.data()['text'] as String,
        );
      }).toList();

      notifyListeners();
    });
  }

  void _listenToUserAttendance(String userId) {
    _attendingSubscription = FirebaseFirestore.instance
        .collection('attendees')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        _attending = (snapshot.data()!['attending'] as bool)
            ? Attending.yes
            : Attending.no;
      } else {
        _attending = Attending.unknown;
      }

      notifyListeners();
    });
  }

  void _listenToAttendeeCount() {
    FirebaseFirestore.instance
        .collection('attendees')
        .where('attending', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _attendees = snapshot.docs.length;
      notifyListeners();
    });
  }
}
