import '../get_notes/get_notes_event.dart';

class DeleteNotesEvent extends NoteEvent{
  final String noteId;
  DeleteNotesEvent(this.noteId);
}
