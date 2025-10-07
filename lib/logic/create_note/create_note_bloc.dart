import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_note_event.dart';
import 'create_note_state.dart';

class CreateNoteBloc extends Bloc<CreateNoteEvent, CreateNoteState> {
  //------------------approach 1: making the Firestore hard-coded.
  // CreateNoteBloc() : super(CreateNoteInitial()) {

  //------------------approach 2: making the Firestore dependency injectable instead.
  // By adding a final FirebaseFirestore firestore; field and passing it in the constructor.
  final FirebaseFirestore firestore;
  CreateNoteBloc({FirebaseFirestore? firestoreInstance}) : firestore = firestoreInstance ?? FirebaseFirestore.instance, super(CreateNoteInitial()) {
    // Handle SubmitNoteEvent
    on<SubmitNoteEvent>((event, emit) async {
      emit(CreateNoteLoading());
      try {
        final docRef = await firestore
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
        await firestore
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
