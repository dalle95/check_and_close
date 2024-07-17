import '/common/entities/wo.dart';

abstract class WOListEvent {
  const WOListEvent();
}

class WOListDatiEvent extends WOListEvent {
  final List<WO>? wo;
  const WOListDatiEvent({
    this.wo,
  });
}
