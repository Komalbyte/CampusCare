import 'package:equatable/equatable.dart';
import '../../../domain/entities/complaint_entity.dart';

abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ComplaintInitial extends ComplaintState {}

/// Loading state (fetching data)
class ComplaintLoading extends ComplaintState {}

/// Loaded state (showing list of complaints)
class ComplaintLoaded extends ComplaintState {
  final List<ComplaintEntity> complaints;
  final bool hasReachedMax;

  const ComplaintLoaded({
    required this.complaints,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [complaints, hasReachedMax];
}

/// Operation success (e.g., submitted successfully updates list, but UI might want a separate signal)
class ComplaintOperationSuccess extends ComplaintState {
  final String message;

  const ComplaintOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// Operation loading (e.g. submitting)
class ComplaintSubmitting extends ComplaintState {}

/// Error state
class ComplaintError extends ComplaintState {
  final String message;

  const ComplaintError(this.message);

  @override
  List<Object> get props => [message];
}
