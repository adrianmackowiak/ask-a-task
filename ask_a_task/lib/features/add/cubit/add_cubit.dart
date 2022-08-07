import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ask_a_task/repositories/items_repository.dart';

part 'add_state.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit(this._itemsRepository) : super(const AddState());

  final ItemsRepository _itemsRepository;

  Future<void> add(
    String title,
    String description,
    String imageURL,
    DateTime releaseDate,
  ) async {
    try {
      await _itemsRepository.add(
          title: title, description: description, imageURL: imageURL, releaseDate: releaseDate);

      emit(const AddState(saved: true));
    } catch (error) {
      emit(AddState(errorMessage: error.toString()));
    }
  }
}
