import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:notes_app_firebase/logic/delete_note/delete_notes_state.dart';
import 'package:notes_app_firebase/logic/get_notes/get_notes_state.dart';

import 'delete_notes_event.dart';

class DeleteNotesBloc extends Bloc<DeleteNotesEvent, NoteState> {
  DeleteNotesBloc() : super(DeleteNoteInitialState()) {
    on<DeleteNotesEvent>((event, emit) async {
      emit(DeleteNoteLoadingState());
      try {
        //each doc represents a note
        final snapshotOfTheCollection = await FirebaseFirestore.instance
            .collection("notes")
            .doc(event.noteId.toString())
            .delete();
        emit(DeleteNoteLoadedState());
      } catch (e) {
        print(e);
        emit(DeleteNoteFailedState(e.toString()));
      }
    });
  }
}
