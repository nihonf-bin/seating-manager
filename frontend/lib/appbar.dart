import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_seating_chart/appstate.dart';
import 'package:online_seating_chart/styles.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class MyAppbar extends StatefulWidget {
  const MyAppbar({super.key, required this.title});
  final String title;

  @override
  State<MyAppbar> createState() => _MyAppbarState();
}

class _MyAppbarState extends State<MyAppbar> {
  int index = 0;
  
  @override
  Widget build(BuildContext context) {
    final double sw = Styles.screenWidth(context);
    final dropdownTextStyle = WidgetStateProperty.all(GoogleFonts.inter().copyWith(
      fontSize: Styles.responsiveSize(sw*0.014, 16, 24)));

    return AppBar(
      title: Text(widget.title, style: GoogleFonts.inter().copyWith(
        fontSize: Styles.responsiveSize(sw*0.014, 20, 24),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2
      )),
      backgroundColor: Styles.primaryColor,
      foregroundColor: Styles.white,
      actions: [
        Row(
          children: [
            DropdownMenu(
              width: Styles.responsiveSize(sw*0.208, 250, 350),
              textStyle: GoogleFonts.inter().copyWith(
                fontSize: Styles.responsiveSize(sw*0.014, 16, 24),
                color: Styles.primaryColor,
                fontWeight: FontWeight.w600
              ),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Styles.white),
                elevation: WidgetStatePropertyAll(0),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Styles.white,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Styles.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Styles.white),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Styles.white),
                ),
                hintStyle: GoogleFonts.inter().copyWith(
                  fontSize: Styles.responsiveSize(sw*0.014, 16, 24),
                  color: Styles.white
                ),
              ),
              initialSelection: '4階 - テクノプロジェクト',
              requestFocusOnTap: false,  // This prevents text editing behavior
              onSelected: (value) {
                switch (value) {
                  case '4階 - テクノプロジェクト':
                    index = 0;
                    break;
                  case '5階 - テクノプロジェクト':
                    index = 1;
                    break;
                  case '6階 - テクノプロジェクト':
                    index = 2;
                    break;
                } 
                Provider.of<ApplicationState>(context, listen: false).setIndex(index);
              },
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: '4階 - テクノプロジェクト',
                  label: '4階 - テクノプロジェクト',
                  style: ButtonStyle(
                    textStyle: dropdownTextStyle,
                  )
                ),
                DropdownMenuEntry(
                  value: '5階 - テクノプロジェクト',
                  label: '5階 - テクノプロジェクト',
                  style: ButtonStyle(
                    textStyle: dropdownTextStyle,
                  )
                ),
                DropdownMenuEntry(
                  value: '6階 - テクノプロジェクト',
                  label: '6階 - テクノプロジェクト',
                  style: ButtonStyle(
                    textStyle: dropdownTextStyle,
                  )
                ),
              ],
            ),
            SizedBox(width: sw * 0.01),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to login page
                  context.go('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 55, 75),
                  foregroundColor: Styles.white,
                ),
                child: Text('Logout'),
              ),
            ),
          ],
        )
      ]
    );
  }
}