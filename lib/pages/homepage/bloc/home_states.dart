import '/common/entities/material.dart';

class HomeState {
  const HomeState({
    this.assets = const [],
    this.page = 0,
  });

  final List<Material>? assets;
  final int page;

  HomeState copyWith({
    List<Material>? assets,
    int? page,
  }) {
    return HomeState(
      assets: assets ?? this.assets,
      page: page ?? this.page,
    );
  }
}
