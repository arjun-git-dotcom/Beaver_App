import 'package:equatable/equatable.dart';

abstract class CredentialState extends Equatable {
  const CredentialState();
  @override
  List<Object?> get props => [];
}

class CredentialInitial extends CredentialState {
  @override
  List<Object?> get props => [];
}

class CredentialLoading extends CredentialState {
  @override
  List<Object?> get props => [];
}

class CredentialSuccess extends CredentialState {
  @override
  List<Object?> get props => [];
}

class CredentialFailure extends CredentialState {
  final String? errorText;
  const CredentialFailure([this.errorText]);
  @override
  List<Object?> get props => [errorText];
}
