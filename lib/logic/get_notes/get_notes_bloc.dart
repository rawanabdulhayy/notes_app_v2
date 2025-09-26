import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app_firebase/logic/get_notes/get_notes_event.dart';
import 'package:notes_app_firebase/logic/get_notes/get_notes_state.dart';

import '../../models/note.dart';

class GetNoteBloc extends Bloc<NoteEvent, NoteState> {
  GetNoteBloc() : super(GetNoteInitialState()) {
    on<FetchNotesEvent>((event, emit) async {
      emit(GetNoteLoadingState());
      try {
        //each doc represents a note
        final snapshotOfTheCollection = await FirebaseFirestore.instance
            .collection("notes")
            .get();
        //returned document needs a .data
        final notes = snapshotOfTheCollection.docs
            .map((note) => Note.fromJson(note.data()))
            .toList();
        emit(GetNoteLoadedState(notes));
      } catch (e) {
        print(e);
        emit(GetNoteErrorState(e.toString()));
      }
    });
  }
}
