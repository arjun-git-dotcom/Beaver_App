import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentUidCubit extends Cubit<String?> {
  CurrentUidCubit() : super(null);

  setUid(String uid) => emit(uid);
}
