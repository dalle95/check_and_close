import 'package:check_and_close/common/entities/wo.dart';

import '/common/entities/woprocess.dart';

abstract class WODetailEvent {
  const WODetailEvent();
}

class WODetailDatiEvent extends WODetailEvent {
  final WO? wo;
  final List<WOProcess>? woprocess;
  const WODetailDatiEvent({
    this.wo,
    this.woprocess,
  });
}

class WOUpdateDetailDatiEvent extends WODetailEvent {
  final WOProcess? woprocess;
  const WOUpdateDetailDatiEvent({
    this.woprocess,
  });
}
