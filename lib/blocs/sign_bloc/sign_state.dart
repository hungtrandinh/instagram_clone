import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:social_app/model/confimpassword.dart';
import 'package:social_app/model/email.dart';
import 'package:social_app/model/name.dart';
import 'package:social_app/model/password.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.confirmedPassword = const ConfirmedPassword.pure(),
      this.status = FormzStatus.pure,
      this.errorMessage,
      this.name = const NameInput.pure()});
  final NameInput name;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [email, password, confirmedPassword, status, name];

  SignUpState copyWith(
      {Email? email,
      Password? password,
      ConfirmedPassword? confirmedPassword,
      FormzStatus? status,
      String? errorMessage,
      NameInput? name}) {
    return SignUpState(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        name: name ?? this.name);
  }
}
