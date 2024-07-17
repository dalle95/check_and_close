import '/common/entities/material.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeDatiEvent extends HomeEvent {
  final List<Material>? assets;
  final int? page;
  const HomeDatiEvent({
    this.assets,
    this.page,
  });
}
