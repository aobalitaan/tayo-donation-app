// ignore_for_file: must_be_immutable

import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/donation_detail.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/contact_details.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:provider/provider.dart';

import '../../../../models/donation_model.dart';
import '../../../../providers/donation_provider.dart';
import 'package:intl/intl.dart';

class DonorDetails extends StatefulWidget {
  late String? uid;
  DonorDetails({super.key, required this.uid});

  @override
  State<DonorDetails> createState() => _DonorDetailsState();
}

class _DonorDetailsState extends State<DonorDetails> {

  AppUser? donor;
  
  bool isContactSectionVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(widget.uid!);
      Provider.of<DonationProvider>(context, listen: false).fetchDonationsGivenProfile(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    donor = context.watch<UserProvider>().selectedUser;

    return donor == null
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    aboutSection(),
                    const SizedBox(height: 15),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isContactSectionVisible = !isContactSectionVisible;
                          });
                        },
                        icon: Icon(isContactSectionVisible ? Icons.visibility_off_outlined : Icons.perm_contact_cal_rounded),
                        tooltip: isContactSectionVisible ? 'Hide Contact Section' : 'Show Contact Section',
                      ),
                      Visibility(
                        visible: isContactSectionVisible,
                        child: Center(
                          child: ContactDetails(user: donor),
                        ),
                      ),

                    donationsSection(),
                  ],
                ),
              ),
            ],
          ),
        );
  }
Widget donationsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 15),
      Text(
        "Donations",
        style: TextStyle(
          color: Styles.mainBlue,
        ),
      ),
      const SizedBox(height: 5),
      Consumer<DonationProvider>(
        builder: (context, donationProvider, child) {
          final donations = donationProvider.donations; // Get the array of donations
          if (donations.isEmpty) {
            return Center(
              child: Text('No donations found', style: TextStyle(color: Styles.darkerGray)),
            );
          } else {
            return FutureBuilder<List<Widget>>(
              future: _buildDonationTiles(donations),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final donationTiles = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children: donationTiles,
                  );
                }
              },
            );
          }
        },
      ),
    ],
  );
}


  Future<List<Widget>> _buildDonationTiles(List<Donation> donations) async {
  final List<Widget> tiles = [];
  for (final donation in donations) {
    final tile = await buildDonationTile(donation);
    tiles.add(tile);
  }
  return tiles;
}

  Future<Widget> buildDonationTile(Donation donation) async {
    final userProvider = context.read<UserProvider>();
    final recipient = await userProvider.fetchInfo(donation.recipientId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationDetailPage(donation: donation),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Styles.rounded,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(donor!.profilePhoto.isNotEmpty ? donor!.profilePhoto : Styles.defaultProfile),
                  radius: 24.0,
                ),
                const SizedBox(width: 16.0),
                _buildStatusIcon(donation.status),
                const SizedBox(width: 16.0),
                CircleAvatar(
                  backgroundImage: NetworkImage(recipient!.profilePhoto.isNotEmpty ? recipient.profilePhoto : Styles.defaultProfile),
                  radius: 24.0,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            _buildRichText("Donated to ", recipient.name),
            const SizedBox(height: 4.0),
            Text(
              DateFormat('dd MMM, yyyy | HH:mm').format(donation.selectedDateandTime.toDate()),
              style: TextStyle(
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
                color: Styles.darkerGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    if (status == 'Completed') {
      return const Icon(Icons.check, size: 24.0, color: Colors.green);
    } else if (status == 'Cancelled') {
      return const Icon(Icons.close, size: 24.0, color: Colors.red);
    } else {
      return Icon(Icons.more_horiz_outlined, size: 24.0, color: Styles.darkerGray);
    }
  }

  Widget _buildRichText(String prefix, String name) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Styles.mainBlue,
          fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
        ),
        children: [
          TextSpan(
            text: prefix,
          ),
          TextSpan(
            text: "$name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
            ),
          ),
        ],
      ),
    );
  }






  Widget aboutSection(){
    return Column(children: [
      Text(donor!.name, 
        style: TextStyle(
          color: Styles.mainBlue, 
          fontSize: 24, 
          fontWeight: FontWeight.bold
        )
      ),
    
      Text(
        "@${donor!.username}",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Styles.darkerGray, 
          fontSize: 14,
        ),
      ),

  
      const SizedBox(height: 10),
    
      Text(
        donor!.desc != "" ? 
        donor!.desc : 
        (donor!.accountType == 2 ? "This user is an admin." : "It's empty here!"),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Styles.darkerGray, 
          fontSize: 14,
        ),
      ),
    ]);
  }

   Widget imageSection(){
   return Stack(
      children: [
        const SizedBox(
          height: 225,
          width: double.infinity,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            donor!.coverPhoto != '' ?
            donor!.coverPhoto:
            Styles.defaultCover, // Profile cover image
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0, // Adjust the position to place it lower than the cover
          left: (MediaQuery.of(context).size.width / 2) - 75, // Center the circle
          child: Container(
            width: 150, // Increase the width to prevent cropping
            height: 150, // Increase the height to prevent cropping
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                donor!.profilePhoto != '' ?
                donor!.profilePhoto:
                Styles.defaultProfile
                , // Circular image
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),


      ],
    );
  }
}