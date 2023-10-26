import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer player = AudioPlayer();
  bool isPlayingInternetAudio = false;
  bool isPlayingAssetAudio = false;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> playAudioFromInternet() async {
    if (isPlayingAssetAudio) {
      await player.stop();
      setState(() {
        isPlayingAssetAudio = false;
      });
    }

    try {
      await player.play(
          "https://osanime.com/filedownload/2791199/crossing-field-(osanime.com).mp3");
      setState(() {
        isPlayingInternetAudio = true;
      });
    } catch (e) {
      print("Error playing internet audio: $e");
    }
  }

  Future<void> playAudioFromAsset() async {
    if (isPlayingInternetAudio) {
      await player.stop();
      setState(() {
        isPlayingInternetAudio = false;
      });
    }

    if (isPlayingAssetAudio) {
      await player.stop();
      setState(() {
        isPlayingAssetAudio = false;
      });
    } else {
      final audioCache = AudioCache();
      player.onPlayerStateChanged.listen((PlayerState s) {
        if (s == PlayerState.COMPLETED) {
          setState(() {
            isPlayingAssetAudio = false;
          });
        }
      });
      audioCache.play("audio.mp3");
      setState(() {
        isPlayingAssetAudio = true;
      });
    }
  }

  Future<void> stopAudio() async {
    if (isPlayingInternetAudio || isPlayingAssetAudio) {
      await player.stop();
      setState(() {
        isPlayingInternetAudio = false;
        isPlayingAssetAudio = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Play Audio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed:
                  isPlayingInternetAudio ? stopAudio : playAudioFromInternet,
              icon:
                  Icon(isPlayingInternetAudio ? Icons.stop : Icons.play_arrow),
              label: Text(isPlayingInternetAudio ? "Stop" : "Data Internet"),
              style: ElevatedButton.styleFrom(
                primary: isPlayingInternetAudio ? Colors.red : Colors.amber,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
              onPressed: isPlayingAssetAudio ? stopAudio : playAudioFromAsset,
              icon: Icon(isPlayingAssetAudio ? Icons.stop : Icons.play_arrow),
              label: Text(isPlayingAssetAudio ? "Stop" : "Data Asset"),
              style: ElevatedButton.styleFrom(
                primary: isPlayingAssetAudio ? Colors.red : Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
