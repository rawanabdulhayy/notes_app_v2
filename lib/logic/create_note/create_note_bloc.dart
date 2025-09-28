import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_note_event.dart';
import 'create_note_state.dart';

class CreateNoteBloc extends Bloc<CreateNoteEvent, CreateNoteState> {
  CreateNoteBloc() : super(CreateNoteInitial()) {
    // Handle SubmitNoteEvent
    on<SubmitNoteEvent>((event, emit) async {
      emit(CreateNoteLoading());
      try {
        final docRef = await FirebaseFirestore.instance
            .collection('notes')
            .add(event.note.toJson());

        // store the generated Firestore ID inside the document
        await docRef.update({'id': docRef.id});

        emit(CreateNoteLoaded());
      } catch (e) {
        emit(CreateNoteError(e.toString()));
      }
    });

    // Handle EditNoteEvent
    on<EditNoteEvent>((event, emit) async {
      emit(CreateNoteLoading());
      try {
        await FirebaseFirestore.instance
            .collection('notes')
            .doc(event.noteId)
            .update(event.updatedNote.toJson());
        emit(CreateNoteLoaded());
      } catch (e) {
        emit(CreateNoteError(e.toString()));
      }
    });
  }
}
