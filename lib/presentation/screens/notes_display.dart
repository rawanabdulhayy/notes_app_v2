import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:notes_app_firebase/logic/create_note/create_note_bloc.dart';
import 'package:notes_app_firebase/presentation/screens/create_note.dart';

import '../../core/app_colors/app_colors.dart';
import '../../models/note.dart';

class NotesDisplay extends StatefulWidget {
  const NotesDisplay({super.key});

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

List<Note> dummyNotes = [
  Note(
    id: 1,
    headLine: "Meeting",
    description:
        "Excepteur sint occaecat cupidatat non proiden, Excepteur sint occaecat cupidatat non proiden.",
    createdAt: Timestamp.fromDate(DateTime(2025, 9, 26, 9, 0)), // 9:00 am
  ),
  Note(
    id: 2,
    headLine: "Buying Fruits",
    description: "Apple, Orange, Banana, Guava.",
    createdAt: Timestamp.fromDate(DateTime(2025, 9, 26, 11, 0)), // 11:00 am
  ),
  Note(
    id: 3,
    headLine: "Address",
    description: "4140 Parker Rd. Allentown, New Mexico 31134",
    createdAt: Timestamp.fromDate(DateTime(2025, 9, 26, 11, 30)), // 11:30 am
  ),
  Note(
    id: 4,
    headLine: "Packing",
    description: "Dress, Shoe, Watch, Toothbrush, Paste.",
    createdAt: Timestamp.fromDate(DateTime(2025, 9, 26, 13, 0)), // 1:00 pm
  ),
  Note(
    id: 5,
    headLine: "Health checkup",
    description: "Duis aute irure dolor in reprehenderit in voluptate.",
    createdAt: Timestamp.fromDate(DateTime(2025, 9, 26, 16, 0)), // 4:00 pm
  ),
];

class _NotesDisplayState extends State<NotesDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 138.0, left: 43, right: 43),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return BlocProvider(
                              create: (context) => CreateNoteBloc(),
                              child: CreateNotePage(),
                            );
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      //width and height in elevated buttons -- denoted by minimum size property (width, height)
                      minimumSize: Size(164, 48),
                      backgroundColor: Colors.white, // button background color
                      foregroundColor:
                          AppColors.primaryColor, // text (and icon) color
                      // In textField, borderRadius was nested under the border property, nested under InputDecoration.
                      // In elevated button, borderRadius was nested under the shape property, nested under ElevatedButton,styleFrom.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          5,
                        ), // rounded corners
                      ),
                    ),
                    child: Text("Add Note"),
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  //so that it shrinks to the needed width according to available spacing
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      //width and height in elevated buttons -- denoted by minimum size property (width, height)
                      minimumSize: Size(164, 48),
                      backgroundColor: Colors.white, // button background color
                      foregroundColor:
                          AppColors.primaryColor, // text (and icon) color
                      // In textField, borderRadius was nested under the border property, nested under InputDecoration.
                      // In elevated button, borderRadius was nested under the shape property, nested under ElevatedButton,styleFrom.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          5,
                        ), // rounded corners
                      ),
                    ),
                    child: Text("Log Out"),
                  ),
                ),
              ],
            ),
          ),
          // so instead of a column with embedded row that holds the last two within, he had a row that holds a column and an item aside.
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: dummyNotes.length,
              itemBuilder: (BuildContext context, int index) {
                final note = dummyNotes[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ), // gives the illusion of list view separated.
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ), //text doesn’t touch edges.
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.secondaryColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.headLine,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    //added expanded for forcing the available parent space only, the one available AFTER all other children have taken up their needed space.
                                    // Without Expanded:
                                    // Text says “I’ll take as much as I need,” → time widget may get pushed off, overflow occurs.
                                    // With Expanded:
                                    // Text only gets the bounded leftover width, so ellipsis works.
                                    // ⚖️ Rule of thumb
                                    // Inside a Row, TextOverflow.ellipsis almost always needs Expanded or Flexible.
                                    // Inside a Column, it usually works without them (since vertical constraints are different).
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      note.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 10),
                          child: Align(
                            //fixed at bottom right while the column have rhe expanded -- remianing soace within the rwo
                            alignment: Alignment.bottomRight,
                            child: Text(
                              //todo: figure out what this line even does?
                              DateFormat(
                                'hh:mm a',
                              ).format(note.createdAt.toDate()),
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 📌 Expanded
// Forces the widget to take all remaining space in the main axis of the Row or Column.
// If there are 2 Expanded children in a Row, they share the space equally (unless you use flex: to change proportions).
// Example:
// Row(
// children: [
// Expanded(child: Container(color: Colors.red)),   // takes 50%
// Expanded(child: Container(color: Colors.blue)),  // takes 50%
// ],
// )
// 📌 Flexible
// Lets the child be as big as it wants (based on its own size), but it can shrink if there isn’t enough space.
// Unlike Expanded, it doesn’t force the child to fill all the available space.
// Example:
// Row(
// children: [
// Flexible(child: Container(width: 300, color: Colors.red)),
// Flexible(child: Container(width: 300, color: Colors.blue)),
// ],
// )
// If the screen is only 500px wide, each one will shrink proportionally to fit without overflowing.
// ⚖️ Key Difference
// Expanded = fill all space (stretch).
// Flexible = fit content, but shrink if necessary (don’t overflow).
// 👉 In Your Case
// If you want both buttons equal width and filling the row → use Expanded.
// If you want buttons to keep their natural width but avoid overflow → use Flexible.
