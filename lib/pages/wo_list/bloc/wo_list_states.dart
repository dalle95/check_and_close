import '/common/entities/wo.dart';

class WOListState {
  const WOListState({
    this.wo = const [],
  });

  final List<WO>? wo;

  WOListState copyWith({
    List<WO>? wo,
  }) {
    return WOListState(
      wo: wo ?? this.wo,
    );
  }
}
