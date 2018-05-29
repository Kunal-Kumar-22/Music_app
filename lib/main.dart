import 'package:flutter/material.dart';
import 'package:music_app/AudioRadialSeekBar.dart';
import 'package:music_app/BottomControls.dart';
import 'package:music_app/songs.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_app/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new AudioPlaylist(
      playlist: demoPlaylist.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.playing,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.chevron_left),
            color: Colors.black12,
            onPressed: () {},
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.menu),
              color: Colors.black12,
              onPressed: () {},
            ),
          ],
        ),
        body: new Column(
          children: <Widget>[

            //seek_bar
            new Expanded(
              child: new AudioPlaylistComponent(
                playlistBuilder: (BuildContext context , Playlist playlist , Widget child) {
                  String albumArtUrl = demoPlaylist.songs[playlist.activeIndex].albumArtUrl;
                  return new AudioRadialSeekBar(
                    albumArtUrl: albumArtUrl,
                  );
                },
              ),
            ),

            //visualizer
            new Container(
              width: double.infinity,
              height: 125.0,
              child: new Visualizer(
                builder: (BuildContext context , List<int> fft) {
                  return new CustomPaint(
                    painter: new VisualizerPainter(
                      fft: fft,
                      height: 125.0,
                      color: accentColor,
                    ),
                  );
                },
              ),
            ),

            //information and controls
            new BottomControls(),
          ],
        ),
      ),
    );
  }


}

class VisualizerPainter extends CustomPainter {

  final List<int> fft;
  final double height;
  final Color color;
  final Paint wavePaint;

  VisualizerPainter({
    this.fft,
    this.height,
    this.color,
  }) : wavePaint = new Paint()
    ..color = color.withOpacity(0.5)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    _renderWaves(canvas, size);
  }

  void _renderWaves(Canvas canvas, Size size) {
    final histogramLow = _createHistogram(fft, 15, 2, ((fft.length) / 4).floor());
    final histogramHigh = _createHistogram(fft, 15, (fft.length / 4).ceil(), (fft.length / 2).floor());

    _renderHistogram(canvas, size, histogramLow);
    _renderHistogram(canvas, size, histogramHigh);
  }

  void _renderHistogram(Canvas canvas, Size size, List<int> histogram) {
    if (histogram.length == 0) {
      return;
    }

    final pointsToGraph = histogram.length;
    final widthPerSample = (size.width / (pointsToGraph - 2)).floor();

    final points = new List<double>.filled(pointsToGraph * 4, 0.0);

    for (int i = 0; i < histogram.length - 1; ++i) {
      points[i * 4] = (i * widthPerSample).toDouble();
      points[i * 4 + 1] = size.height - histogram[i].toDouble();

      points[i * 4 + 2] = ((i + 1) * widthPerSample).toDouble();
      points[i * 4 + 3] = size.height - (histogram[i + 1].toDouble());
    }

    Path path = new Path();
    path.moveTo(0.0, size.height);
    path.lineTo(points[0], points[1]);
    for (int i = 2; i < points.length - 4; i += 2) {
      path.cubicTo(
          points[i - 2] + 10.0, points[i - 1],
          points[i] - 10.0, points [i + 1],
          points[i], points[i + 1]
      );
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  List<int> _createHistogram(List<int> samples, int bucketCount, [int start, int end]) {
    if (start == end) {
      return const [];
    }

    start = start ?? 0;
    end = end ?? samples.length - 1;
    final sampleCount = end - start + 1;

    final samplesPerBucket = (sampleCount / bucketCount).floor();
    if (samplesPerBucket == 0) {
      return const [];
    }

    final actualSampleCount = sampleCount - (sampleCount % samplesPerBucket);
    List<int> histogram = new List<int>.filled(bucketCount, 0);

    // Add up the frequency amounts for each bucket.
    for (int i = start; i <= start + actualSampleCount; ++i) {
      // Ignore the imaginary half of each FFT sample
      if ((i - start) % 2 == 1) {
        continue;
      }

      int bucketIndex = ((i - start) / samplesPerBucket).floor();
      histogram[bucketIndex] += samples[i];
    }

    // Massage the data for visualization
    for (var i = 0; i < histogram.length; ++i) {
      histogram[i] = (histogram[i] / samplesPerBucket).abs().round();
    }

    return histogram;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}












