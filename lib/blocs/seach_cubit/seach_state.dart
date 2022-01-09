import 'package:equatable/equatable.dart';
import 'package:social_app/model/user.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final List<MyUser> userList;
  final SearchStatus status;

  SearchState({required this.userList, required this.status});

  factory SearchState.initial() {
    return SearchState(
      userList: [],
      status: SearchStatus.initial,
    );
  }

  SearchState copyWith({
    List<MyUser>? userList,
    SearchStatus? status,
  }) {
    return new SearchState(
      userList: userList ?? this.userList,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [userList, status];
}
