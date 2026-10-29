import 'dart:io';
import 'dart:typed_data';

/// PCM16 mono WAV 읽기·쓰기. 샘플은 −1..1.
void writeWav(File file, Float64List samples, {int rate = 22050}) {
  final dataBytes = samples.length * 2;
  final b = ByteData(44 + dataBytes);
  void tag(int at, String s) {
    for (var k = 0; k < 4; k++) {
      b.setUint8(at + k, s.codeUnitAt(k));
    }
  }

  tag(0, 'RIFF');
  b.setUint32(4, 36 + dataBytes, Endian.little);
  tag(8, 'WAVE');
  tag(12, 'fmt ');
  b.setUint32(16, 16, Endian.little); // fmt 청크 크기
  b.setUint16(20, 1, Endian.little); // PCM
  b.setUint16(22, 1, Endian.little); // mono
  b.setUint32(24, rate, Endian.little);
  b.setUint32(28, rate * 2, Endian.little); // byte rate
  b.setUint16(32, 2, Endian.little); // block align
  b.setUint16(34, 16, Endian.little); // bits
  tag(36, 'data');
  b.setUint32(40, dataBytes, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    final v = (samples[i].clamp(-1.0, 1.0) * 32767).round();
    b.setInt16(44 + i * 2, v, Endian.little);
  }
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(b.buffer.asUint8List());
}

/// RIFF/WAVE 가 아니면 [FormatException]. 16bit 가 아니면 샘플은 비어 있다.
({int rate, int channels, int bits, Float64List samples}) readWav(File file) {
  final bytes = file.readAsBytesSync();
  final b = ByteData.sublistView(bytes);
  String tag(int at) => String.fromCharCodes(bytes.sublist(at, at + 4));
  if (bytes.length < 12 || tag(0) != 'RIFF' || tag(8) != 'WAVE') {
    throw FormatException('RIFF/WAVE 아님: ${file.path}');
  }
  var rate = 0, channels = 0, bits = 0;
  var samples = Float64List(0);
  var at = 12;
  while (at + 8 <= bytes.length) {
    final id = tag(at);
    final size = b.getUint32(at + 4, Endian.little);
    final body = at + 8;
    if (id == 'fmt ') {
      channels = b.getUint16(body + 2, Endian.little);
      rate = b.getUint32(body + 4, Endian.little);
      bits = b.getUint16(body + 14, Endian.little);
    } else if (id == 'data' && bits == 16) {
      final n = size ~/ 2;
      samples = Float64List(n);
      for (var i = 0; i < n; i++) {
        samples[i] = b.getInt16(body + i * 2, Endian.little) / 32768;
      }
    }
    at = body + size + (size & 1);
  }
  return (rate: rate, channels: channels, bits: bits, samples: samples);
}
