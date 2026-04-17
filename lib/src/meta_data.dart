import 'dart:typed_data';

/// Represents metadata information about an audio track.
class MetaData {
  /// The title of the track.
  final String title;

  /// The artist of the track.
  final String artist;

  /// The album the track belongs to.
  final String album;

  /// The genre of the track.
  final String genre;

  /// The year the track was released.
  final int year;

  /// The track number on the album.
  final int trackNumber;

  /// The disc number if the album has multiple discs.
  final int discNumber;

  /// An optional thumbnail image associated with the track, represented as a byte array.
  final Uint8List? thumbnail;

  /// Creates a new MetaData instance with the provided information.
  MetaData({
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.year,
    required this.trackNumber,
    required this.discNumber,
    this.thumbnail,
  });

  /// Factory constructor to create a MetaData instance from a JSON map.
  factory MetaData.fromJson(Map<String, dynamic> json) {

    final year = json['tyer'] != null ? int.tryParse(json['tyer'].toString()) ?? 0 : 0;

    return MetaData(
      title: json['tit2'] ?? '',
      artist: json['tpe1'] ?? '',
      album: json['talb'] ?? '',
      genre: json['tcon'] ?? '',
      year: year,
      trackNumber: json['trck'] != null ? int.parse(json['trck'].split('/')[0]) : json['trackNumber'] ?? 0,
      discNumber: json['discnumber'] ?? json['discNumber'] ?? 0,
      thumbnail: json['thumbnail'] != null
          ? Uint8List.fromList(List<int>.from(json['thumbnail']))
          : null,
    );
  }
}

/*
/// Sample metatdata output from symphonia
[log] Metadata JSON: 
{
  "channels":"2",
  "frame_count":"9416448",
  "tcon":"Drum & Bass",
  "sample_rate":"44100",
  "codec":"0x1003",
  "trck":"1/1",
  "tit2":"Itro - All For You (feat. SILIAS) [NCS Release]","tbpm":"172","talb":"All For You ","tpe1":"Itro feat. SILIAS","tpe2":"Itro feat. SILIAS","tenc":"LAME in FL Studio 21","tyer":"2023","tcom":"Kelvin Rowaan, Mark van Egmond","tpos":"1/1","duration_seconds":"213.52489795918368"}
*/
