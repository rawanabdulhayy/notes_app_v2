import '../../models/note.dart';

abstract class NoteState{}

class GetNoteInitialState extends NoteState{}
class GetNoteLoadingState extends NoteState{}
class GetNoteLoadedState extends NoteState{
  final List<Note> displayedNotes;
  GetNoteLoadedState(this.displayedNotes);
}
class GetNoteErrorState extends NoteState{
  final String message;
  GetNoteErrorState(this.message);
}