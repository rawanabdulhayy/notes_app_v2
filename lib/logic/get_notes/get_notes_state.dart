import '../../models/note.dart';

abstract class NoteState{}

class NoteInitialState extends NoteState{}
class NoteLoadingState extends NoteState{}
class NoteLoadedState extends NoteState{
  final List<Note> displayedNotes;
  NoteLoadedState(this.displayedNotes);
}
class NoteErrorState extends NoteState{
  final String message;
  NoteErrorState(this.message);
}