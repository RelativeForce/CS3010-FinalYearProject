"use strict";

exports.stop = function(audio){
  return function(){
    try {
      audio.stop();
      return true;
    }
    catch(e){
      return false;
    }
  } 
};

exports.isPlaying = function(audio){
  return function(){
    return audio.isPlaying();
  }
};

exports.mute = function(context){
  return function(){

    // Iterate over each of the audio streames in the context and mute them.
    for (var index = 0; index < context.audioStreams.length; index++) {
      context.audioStreams[index].mute();
    }

    return context;
  }
}

exports.unmute = function(context){
  return function(){

    // Iterate over each of the audio streames in the context and unmute them.
    for (var index = 0; index < context.audioStreams.length; index++) {
      context.audioStreams[index].unmute();
    }

    return context;
  }
}

exports.play = function(just){
  return function(nothing){
    return function(muted){
      return function(src){
        return function(){
          try {

            // Construct a new sound and start it playing.
            var audio = new sound(src, muted);
            audio.play();
            return just(audio);
          }
          catch(e){
            return nothing;
          }
        }
      }
    }
  }
}

function sound(src, muted) {

  var maxVolume = 0.5;

  this.sound = document.createElement("audio");
  this.sound.src = src;
  this.sound.setAttribute("preload", "auto");
  this.sound.setAttribute("controls", "none");
  this.sound.style.display = "none";
  this.sound.volume = maxVolume;
  document.body.appendChild(this.sound);

  this.play = function(){
    this.sound.play();
  }

  this.stop = function(){
    this.sound.pause();
  }

  this.mute = function(){
    this.sound.volume = 0.0;
  }

  this.unmute = function(){
    this.sound.volume = maxVolume;
  }

  this.src = src;

  this.isPlaying = function(){
    return !this.sound.ended;
  }

  if(muted){
    this.mute();
  }
}