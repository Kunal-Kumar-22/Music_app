import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/theme.dart';

import 'package:music_app/songs.dart';
import 'package:fluttery_audio/fluttery_audio.dart';


class BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: new Material(
        color: accentColor,
        shadowColor: const Color(0x44000000),
        child: new Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
          child: new Column(
            children: <Widget>[
              new AudioPlaylistComponent(
                playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
                  final String songTitle = demoPlaylist.songs[playlist.activeIndex].songTitle;
                  final String artistName = demoPlaylist.songs[playlist.activeIndex].artist;
                  return new RichText(
                    text: new TextSpan(
                      text: '',
                      children: [
                        new TextSpan(
                          text: '${songTitle.toUpperCase()}\n',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            height: 1.5,
                          ),
                        ),
                        new TextSpan(
                          text: '${artistName.toUpperCase()}',
                          style: new TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12.0,
                            letterSpacing: 3.0,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
               },
              ),

              new Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                ),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(),
                    ),
                    new PrevButton(),
                    new Expanded(
                      child: new Container(),
                    ),
                    new PlayPauseButton(),
                    new Expanded(
                      child: new Container(),
                    ),
                    new NextButton(),
                    new Expanded(
                      child: new Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context , AudioPlayer player , Widget child ) {

        IconData icon = Icons.music_note;
        Function onPressed;
        Color buttonColor = lightAccentColor;

        if(player.state == AudioPlayerState.playing)
        {
          icon = Icons.pause;
          onPressed = player.pause;
          buttonColor = Colors.white;
        }
        else if(player.state == AudioPlayerState.paused || player.state == AudioPlayerState.completed)
        {
          icon = Icons.play_arrow;
          onPressed = player.play;
          buttonColor = Colors.white;
        }

        return new RawMaterialButton(
          shape: new CircleBorder(),
          fillColor: buttonColor,
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor.withOpacity(0.5),
          elevation: 10.0,
          onPressed: onPressed,
          highlightElevation: 5.0,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Icon(
              icon,
              size: 35.0,
              color: darkAccentColor,
            ),
          ),
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist , Widget child) {
        return new IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: new Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.next,
        );
      },
    );
  }
}

class PrevButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist , Widget child) {
        return new IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: new Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.previous,
        );
      },
    );
  }
}