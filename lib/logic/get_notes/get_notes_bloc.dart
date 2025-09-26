import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app_firebase/logic/get_notes/get_notes_event.dart';
import 'package:notes_app_firebase/logic/get_notes/get_notes_state.dart';

import '../../models/note.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitialState()) {
    on<LoadNotesEvent>((event, emit) async {
      emit(NoteLoadingState());
      try {
        //each doc represents a note
        final snapshotOfTheCollection = await FirebaseFirestore.instance
            .collection("notes")
            .get();
        //returned document needs a .data
        final notes = snapshotOfTheCollection.docs
            .map((note) => Note.fromJson(note.data()))
            .toList();
        emit(NoteLoadedState(notes));
      } catch (e) {
        print(e);
        emit(NoteErrorState(e.toString()));
      }
    });
  }
}
