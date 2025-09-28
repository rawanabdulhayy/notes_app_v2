import '../../models/note.dart';
import '../get_notes/get_notes_state.dart';

class DeleteNoteInitialState extends NoteState{}
class DeleteNoteLoadingState extends NoteState{}
class DeleteNoteLoadedState extends NoteState{
}
class DeleteNoteFailedState extends NoteState{
  final String message;
  DeleteNoteFailedState(this.message);
}