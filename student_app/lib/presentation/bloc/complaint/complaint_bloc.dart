import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/complaint_repository.dart';
import 'complaint_event.dart';
import 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final ComplaintRepository complaintRepository;

  ComplaintBloc({required this.complaintRepository})
      : super(ComplaintInitial()) {
    on<LoadUserComplaints>(_onLoadUserComplaints);
    on<LoadAllComplaints>(_onLoadAllComplaints);
    on<SubmitNewComplaint>(_onSubmitNewComplaint);
    on<UpvoteComplaint>(_onUpvoteComplaint);
    on<RefreshComplaints>(_onRefreshComplaints);
  }

  Future<void> _onLoadUserComplaints(
    LoadUserComplaints event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(ComplaintLoading());
    try {
      final complaints = await complaintRepository.getComplaintsByUserId(
        userId: event.userId,
      );
      emit(ComplaintLoaded(complaints: complaints));
    } catch (e) {
      emit(ComplaintError(e.toString()));
    }
  }

  Future<void> _onLoadAllComplaints(
    LoadAllComplaints event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(ComplaintLoading());
    try {
      final complaints = await complaintRepository.getAllComplaints(
        category: event.category,
        status: event.status,
      );
      emit(ComplaintLoaded(complaints: complaints));
    } catch (e) {
      emit(ComplaintError(e.toString()));
    }
  }

  Future<void> _onSubmitNewComplaint(
    SubmitNewComplaint event,
    Emitter<ComplaintState> emit,
  ) async {
    final currentState = state;
    emit(ComplaintSubmitting());
    try {
      final imageUrls = await complaintRepository.uploadComplaintImages(
        complaintId: 'temp_id', // Mock ID for upload
        imagePaths: event.imageUrls,
      );

      final newComplaint = await complaintRepository.submitComplaint(
        userId: event.userId,
        category: event.category,
        // subCategory: event.subCategory, // Not in interface
        title: event.title,
        description: event.description,
        location: event.location,
        imagePaths: imageUrls,
      );

      emit(const ComplaintOperationSuccess('Complaint submitted successfully!'));
      
      // Reload complaints after successful submission
      // In a real app with streams, this might be auto-handled, but here we can force a reload or just emit loaded with new item
      // For simplicity, let's trigger a reload of user complaints if we were viewing them
      add(LoadUserComplaints(event.userId));
      
    } catch (e) {
      emit(ComplaintError(e.toString()));
      // Restore previous loaded state if possible, or stay in error
    }
  }

  Future<void> _onUpvoteComplaint(
    UpvoteComplaint event,
    Emitter<ComplaintState> emit,
  ) async {
    try {
      await complaintRepository.upvoteComplaint(
        complaintId: event.complaintId,
        // userId: event.userId, // Not in interface
      );
      // We don't emit a new state here as stream should handle update, 
      // or we can reload depending on architecture. 
      // With MockRepository streaming, listing should auto-update if we are listening to stream.
      // But since we are using Future-based loading here for simplicity first:
      add(LoadUserComplaints(event.userId)); 
    } catch (e) {
      // Show snackbar error ideally, but BLoC handles state
    }
  }

  Future<void> _onRefreshComplaints(
    RefreshComplaints event,
    Emitter<ComplaintState> emit,
  ) async {
    try {
      final complaints = await complaintRepository.getComplaintsByUserId(
        userId: event.userId,
      );
      emit(ComplaintLoaded(complaints: complaints));
    } catch (e) {
      emit(ComplaintError(e.toString()));
    }
  }
}
