import 'package:attrack/bloc/auth_bloc/auth_bloc.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_logout.dart';
import 'package:attrack/bloc/auth_bloc/events/auth_event_show_update_user_details.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/homescreen/past_events/past_events_view.dart';
import 'package:attrack/screens/homescreen/notification_screen.dart';
import 'package:attrack/screens/homescreen/upcomming_meetings/upcomming_meetings_view.dart';
import 'package:attrack/screens/homescreen/user_details_qr/user_details_qr_view.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/utils/colors.dart';
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
  int _currentIndex = 1;
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
      UpcommingMeetingsView(
        user: widget.user,
        db: widget.dbprovider,
      ),
      PastEventsView(
        user: widget.user,
        db: widget.dbprovider,
      ),
    ];
  }

  void _logout() async {
    var shouldLogOut = await showLogOutDialog(context);
    if (shouldLogOut) {
      // ignore: use_build_context_synchronously
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
      backgroundColor: tPrimaryColor,
      appBar: _appBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF73FBFD),
        useLegacyColorScheme: false,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: tSecondaryColor,
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
            label: 'Upcoming Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_available_rounded,
              size: 30,
            ),
            label: 'Past Events',
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
      backgroundColor: tPrimaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'AtTrack',
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
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _showSettingsDialog();
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: widget.user.photoUrl != null
                      ? NetworkImage(widget.user.photoUrl!)
                      : null,
                  child: widget.user.photoUrl == null
                      ? Text(widget.user.name[0])
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
