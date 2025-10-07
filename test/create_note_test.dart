import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app_firebase/logic/create_note/create_note_bloc.dart';
import 'package:notes_app_firebase/logic/create_note/create_note_event.dart';
import 'package:notes_app_firebase/logic/create_note/create_note_state.dart';
import 'package:notes_app_firebase/models/note.dart';

// -------------------- MOCKS --------------------
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    // Default behavior — all tests will start from here
    when(() => mockFirestore.collection('notes')).thenReturn(mockCollection);
  });

  final testNote = Note(
    headLine: 'Test Headline',
    description: 'This is a test note description',
    createdAt: Timestamp.now(),
  );

  // ✅ CREATE NOTE SUCCESS
  blocTest<CreateNoteBloc, CreateNoteState>(
    'emits [Loading, Loaded] when note creation succeeds',
    build: () {
      // Chain: firestore.collection('notes').add(...) -> docRef -> update(...)
      when(() => mockFirestore.collection('notes')).thenReturn(mockCollection);
      when(() => mockCollection.add(any())).thenAnswer((_) async => mockDocRef);
      when(() => mockDocRef.id).thenReturn('mockDocId');
      when(() => mockCollection.doc('mockDocId')).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async => {});

      return CreateNoteBloc(firestoreInstance: mockFirestore);
    },
    act: (bloc) => bloc.add(SubmitNoteEvent(testNote)),
    expect: () => [
      isA<CreateNoteLoading>(),
      isA<CreateNoteLoaded>(),
    ],
  );

  // ❌ CREATE NOTE FAILURE
  blocTest<CreateNoteBloc, CreateNoteState>(
    'emits [Loading, Error] when note creation fails',
    build: () {
      when(() => mockFirestore.collection('notes')).thenReturn(mockCollection);
      when(() => mockCollection.add(any())).thenThrow(Exception('add failed'));
      return CreateNoteBloc(firestoreInstance: mockFirestore);
    },
    act: (bloc) => bloc.add(SubmitNoteEvent(testNote)),
    expect: () => [
      isA<CreateNoteLoading>(),
      isA<CreateNoteError>(),
    ],
  );

  // ✅ EDIT NOTE SUCCESS
  blocTest<CreateNoteBloc, CreateNoteState>(
    'emits [Loading, Loaded] when editing a note succeeds',
    build: () {
      when(() => mockFirestore.collection('notes')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async => {});
      return CreateNoteBloc(firestoreInstance: mockFirestore);
    },
    act: (bloc) => bloc.add(EditNoteEvent(noteId: '123', updatedNote: testNote)),
    expect: () => [
      isA<CreateNoteLoading>(),
      isA<CreateNoteLoaded>(),
    ],
  );

  // ❌ EDIT NOTE FAILURE
  blocTest<CreateNoteBloc, CreateNoteState>(
    'emits [Loading, Error] when editing a note fails',
    build: () {
      when(() => mockFirestore.collection('notes')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenThrow(Exception('update failed'));
      return CreateNoteBloc(firestoreInstance: mockFirestore);
    },
    act: (bloc) => bloc.add(EditNoteEvent(noteId: '123', updatedNote: testNote)),
    expect: () => [
      isA<CreateNoteLoading>(),
      isA<CreateNoteError>(),
    ],
  );
}
