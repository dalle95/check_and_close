abstract class QrCodeReaderEvent {
  const QrCodeReaderEvent();
}

class QRCodeDatiEvent extends QrCodeReaderEvent {
  final String qrCodeDati;
  const QRCodeDatiEvent(this.qrCodeDati);
}
