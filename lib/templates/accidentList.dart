import 'package:flutter/material.dart';

import '../commons/constants.dart';
import '../commons/globals.dart';
import '../commons/theme.dart';

Widget accidentList() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(deviceCorner),
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
            ),
            BoxShadow(
              color: AppTheme.theme.scaffoldBackgroundColor,
              spreadRadius: -3,
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(items[index].icon),
                    title: Text(
                      items[index].title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      items[index].description,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.grey.withOpacity(0.5),
                            Colors.grey.withOpacity(0.5),
                            Colors.transparent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: const [
                            0.05,
                            0.30,
                            0.70,
                            0.95
                          ]
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                child: SizedBox(
                  width: double.infinity, // Ensures the button takes the full width
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for the button
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(deviceCorner - 7), top: Radius.circular(14)),
                      ),
                    ),
                    child: Text(
                      "Action Button",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
