class QRCodeReaderState {
  const QRCodeReaderState({
    this.qrCodeDati = "",
  });

  final String qrCodeDati;

  QRCodeReaderState copyWith({
    String? qrCodeDati,
  }) {
    return QRCodeReaderState(
      qrCodeDati: qrCodeDati ?? this.qrCodeDati,
    );
  }
}
