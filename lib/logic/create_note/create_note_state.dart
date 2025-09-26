abstract class CreateNoteState {}

class CreateNoteInitial extends CreateNoteState {
}
class CreateNoteLoading extends CreateNoteState {}
class CreateNoteLoaded extends CreateNoteState {}
class CreateNoteError extends CreateNoteState {
  final String message;

  CreateNoteError(this.message);
}