# tayo: An Elbi Donation System Mobile Application
### CMSC 23-U4L Project Group 3

![Untitled design](https://github.com/user-attachments/assets/cc217125-a853-4e30-a1d7-31a019046960)

## Developers
- Axel Balitaan
- Nathan Jahziel Muncal
- Erix Laud Reyes

## Program Description

### Overview
"Tayo" is a mobile application designed to streamline the donation process within Elbi. Developed using the Flutter framework for the front-end and Firebase for the back-end, this application provides a seamless and efficient platform for managing and facilitating donations. The app supports three distinct user roles: Admin, Organization, and Donor, each with unique functionalities to suit their specific roles.

## Getting Started

### Clone the Repository:
```bash
git clone https://<token>@github.com/aobalitaan/CMSC-23-Project-Group3.git
```

### Setup FlutterBase and Dependencies:
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=cmsc-23-project-group3
flutter pub get
```

### User Views and Functionalities

#### Donor View
- The Donors’ View platform features a homepage listing organizations where donors can send their contributions. Upon selecting an organization, donors can access the donation form, which requires them to enter various details. These include selecting the donation item category (Food, Clothes, Cash, Necessities, Others), choosing whether the items are for pickup or drop-off, specifying the weight of the items in kg or lbs, and optionally uploading a photo of the items using the phone camera. Donors also need to provide the date and time for pickup or drop-off, the address for pickup (with the option to save multiple addresses), and a contact number for pickup. For drop-off donations, the platform generates a QR code that the organization scans to update the donation status. Additionally, donors have the option to cancel their donations. The profile section allows users to manage their personal information.

#### Organization View
- The Homepage features a list of donations. Under the Donation section, organizations can check the information entered by donors and update the status of each donation, categorizing them as Pending, Confirmed, Scheduled for Pick-up, Complete, or Canceled. The Donation drives section showcases all charity and donation drives, allowing organizations to create, read, update, and delete (CRUD) entries. Organizations can link donations to specific drives and must include photos as proof of where the donations ended up. Additionally, auto-SMS and notifications are sent to donors to inform them of the final destination of their donations. The Profile section includes details about the organization, such as the organization name, information about the organization, and the current status for donations (open or close).

#### Admin View
- In the Admin’s View, administrators are provided with essential functionalities for managing the platform. They can securely sign in through authentication to access the admin dashboard, where they gain oversight of all registered organizations and their associated donations. This comprehensive view enables administrators to monitor the platform's activity effectively. Additionally, administrators have the authority to approve organization sign-ups, ensuring that only legitimate entities are granted access. Furthermore, administrators can access a list of all donors who have contributed to the platform, facilitating further analysis and management of donor engagement.

