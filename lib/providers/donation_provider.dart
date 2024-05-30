import 'dart:async';

import 'package:cmsc_23_project_group3/api/firebase_donation_api.dart';
import 'package:flutter/material.dart';
import '../models/donation_model.dart';

class DonationProvider with ChangeNotifier {
  FirebaseDonationAPI firebaseService = FirebaseDonationAPI();
  late Stream<List<Donation>> _donationStream = Stream.empty();
  Donation? _donation;
  StreamSubscription<Donation?>? _subscription;
  Donation? get donation => _donation;
  Stream<List<Donation>> get donationStream => _donationStream;

  // Store donations as a class-level variable
  List<Donation> _donations = [];
  List<Donation> get donations => _donations;

   void setDonationId(String donationId) {
    _subscription?.cancel();
    _subscription = firebaseService.getDonationInfo(donationId).listen((donation) {
      _donation = donation;
      notifyListeners();
    });
  }
 void fetchDonationsGivenProfile(String? uid) {
    try {
      if (uid != null) {
        // Fetch donations from Firebase if uid is not null
        _donationStream = firebaseService.fetchDonationsGiven(uid);

        // Update local donations array when there are changes in the stream
        _donationStream.listen((newDonations) {
          _donations = newDonations; // Update class-level variable
          notifyListeners();
        });
      } else {
        // If uid is null, clear the stream and donations array
        _donationStream = Stream.empty();
        _donations.clear();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching donations: $e');
      _donationStream = Stream.empty();
      _donations.clear();
      notifyListeners();
    }
  }

    void fetchDonationsGiven(String? uid) {
    try {
      _donationStream = Stream.empty();
      if (uid != null) {_donationStream = firebaseService.fetchDonationsGiven(uid);};
      notifyListeners();
    } catch (e) {
      print('Error fetching donations: $e');
      _donationStream = Stream.empty();
      notifyListeners();
    }
  }

  void fetchDonationsReceived(String uid) {
    try {
      _donationStream = firebaseService.fetchDonationsReceived(uid);
      notifyListeners();
    } catch (e) {
      print('Error fetching donations: $e');
      _donationStream = Stream.empty();
      notifyListeners();
    }
  }

  Future<String> addDonation(Donation donation) async {
    String message =
        await firebaseService.addDonation(donation.toJson(donation));
    notifyListeners();
    return message;
  }


  Future<String?> updateDonation(String id, Donation details) async {
    String? message = await firebaseService.updateDonation(id, details.toJson(details));
    notifyListeners();
    return message;
  }

  Future<String?> updateDonationStatus(String id) async {
    String? message = await firebaseService.updateDonationStatus(id);
    notifyListeners();
    return message;

  }

  Future<String?> updateDonationStatusCancel(String id) async {
    String? message = await firebaseService.updateDonationStatusCancel(id);
    notifyListeners();
    return message;
  }
  


}
