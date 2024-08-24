import 'package:attrack/bloc/auth_bloc/auth_bloc.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_logout.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_show_update_user_details.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/homescreen/all_meetings.dart';
import 'package:attrack/screens/homescreen/notification_screen.dart';
import 'package:attrack/screens/homescreen/upcomming_meetings_view.dart';
import 'package:attrack/screens/homescreen/user_details_qr_view.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/utils/dialog/logout_dialog.dart';
import 'package:attrack/utils/dialog/user_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  final DBModel dbprovider;
  final String? error;
  final bool isLoading;
  const HomeScreen({
    super.key,
    required this.user,
    required this.dbprovider,
    this.error,
    this.isLoading = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    if (widget.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.error!),
          ),
        );
      });
    }

    _screens = [
      UserDetailsQrView(user: widget.user),
      const UpcommingMeetingsView(),
      const AllMeetings(),
    ];
  }

  void _logout() async {
    var shouldLogOut = await showLogOutDialog(context);
    if (shouldLogOut) {
      BlocProvider.of<AuthBloc>(context).add(
        const AuthEventLogout(),
      );
    }
  }

  void _editProfile() {
    if (!context.mounted) return;
    BlocProvider.of<AuthBloc>(context).add(
      AuthEventShowUpdateUserDetails(user: widget.user),
    );
  }

  void _showSettingsDialog() async {
    var res = await showSettingsDialog(context, widget.user);
    if (res == null) return;
    if (res == SettingOptions.editProfile) _editProfile();
    if (res == SettingOptions.logout) _logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E0E),
      appBar: _appBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF73FBFD),
        useLegacyColorScheme: false,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF322C2C),
        unselectedItemColor: Colors.white,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code,
              size: 30,
            ),
            label: 'QR Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_note,
              size: 30,
            ),
            label: 'Upcoming Meetings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_available_rounded,
              size: 30,
            ),
            label: 'Past Meetings',
          ),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'EEnTrack',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _showSettingsDialog();
                },
                child: const CircleAvatar(
                  radius: 18,
                  //backgroundImage: const AssetImage('assets/images/avatar.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
