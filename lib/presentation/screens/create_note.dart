import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_firebase/logic/create_note/create_note_bloc.dart';
import 'package:notes_app_firebase/logic/create_note/create_note_event.dart';
import 'package:notes_app_firebase/logic/create_note/create_note_state.dart';
import 'package:notes_app_firebase/presentation/screens/notes_display.dart';
import '../../core/app_colors/app_colors.dart';
import '../../logic/delete_note/delete_notes_bloc.dart';
import '../../logic/get_notes/get_notes_bloc.dart';
import '../../logic/get_notes/get_notes_event.dart';
import '../../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Note? existingNote; //nullability for either created or edited.
  final String? noteId;
  const CreateNotePage({super.key, this.existingNote, this.noteId});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //law lwidget mwguda, fill in the textfield with the model's note values.
    if (widget.existingNote != null) {
      headlineController.text = widget.existingNote!.headLine;
    }
  }

  void _submitNote() {
    //validation comes first
    if (headlineController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields!')));
      return;
    }
    //prepping the to-be-created or the to-be-edited note.
    final note = Note(
      headLine: headlineController.text,
      description: descriptionController.text,
      createdAt: widget.existingNote?.createdAt ?? Timestamp.now(),
    );
    //ba3d ma gahezt el variable, handle cases ba2a, if gdeeda aw already mwguda.
    if (widget.existingNote != null && widget.noteId != null) {
      context.read<CreateNoteBloc>().add(
        EditNoteEvent(noteId: widget.noteId!, updatedNote: note),
      );
    } else {
      context.read<CreateNoteBloc>().add(SubmitNoteEvent(note));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNoteBloc, CreateNoteState>(
      listener: (context, state) {
        if (state is CreateNoteLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              //we can have a ternary operator within the Text widget bounds.
              content: Text(
                widget.existingNote != null
                    ? "Note was updated successfully!"
                    : "Note was created successfully!",
              ),
            ),
          );
        // is failing silently, because inside your CreateNotePage you don’t actually have access to the GetNoteBloc from the notes list.
        //   context.read<GetNoteBloc>().add(FetchNotesEvent());
          ///we provided both because the navigated page needs both, not because I have anything to do with both as the create page speaking.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => GetNoteBloc()..add(FetchNotesEvent()),
                  ),
                  BlocProvider(
                    create: (context) => DeleteNotesBloc(),
                  ),
                ],
                child: NotesDisplay(),
              ),
            ),
          );

        } else if (state is CreateNoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.message} was encountered!")),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Padding(
            padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    "Create New Note",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Headline Label
                Text(
                  "Head line",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),

                // Headline Input
                TextField(
                  controller: headlineController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter Note Address",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    fillColor: AppColors.secondaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Label
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),

                // Description Input (multiline)
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: Colors.white),
                  //------------maxLines property added------------
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Enter Your Description",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    fillColor: AppColors.secondaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Spacer(),

                // Select Media Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement select media logic
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text("Select Media"),
                ),
                const SizedBox(height: 12),

                // Create Button
                ElevatedButton(
                  onPressed: state is CreateNoteLoading
                      ? null
                      : () {
                          _submitNote();
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    widget.existingNote == null ? "Create" : "Update",
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
