import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class SearchFilterCubit extends Cubit<List<UserEntity>> {
  SearchFilterCubit() : super([]);

  void filterUsers(String query, List<UserEntity> users) {
    if (query.isEmpty) {
      emit([]);
    } else {
      final filtered = users.where((user) {
        final name = user.username?.toLowerCase() ?? "";
        final search = query.toLowerCase();
        return name.contains(search);
      }).toList();
      emit(filtered);
    }
  }

  void clearSearch() => emit([]);
}
