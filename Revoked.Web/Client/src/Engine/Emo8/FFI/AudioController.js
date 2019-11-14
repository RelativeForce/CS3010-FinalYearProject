"use strict";

exports.newAudioController = function(controllerId){
  var sounds = [];

  function find(src){
    for (var index = 0; index < sounds.length; index++) {
      const element = sounds[index];
      if(element.src === src){
        return element;
      }
    }

    return undefined;
  }

  var stop = function(src){
    var sound = find(src);

    if(sound){
      sound.stop();
      return true;
    } else {
      return false;
    }
  };

  var isPlaying = function(src){
    var sound = find(src);
    return sound ? sound.isPlaying() : false;
  };

  var play = function(src){
    try{
      var audio = new sound(src);
      audio.play();
      sounds.push(audio);
      return true;
    }
    catch(e){
      return false;
    }
  };

  return {
    id: controllerId,
    stop: stop,
    isPlaying: isPlaying,
    play: play
  };
};

function sound(src) {
  this.sound = document.createElement("audio");
  this.sound.src = src;
  this.sound.setAttribute("preload", "auto");
  this.sound.setAttribute("controls", "none");
  this.sound.style.display = "none";
  document.body.appendChild(this.sound);

  this.play = function(){
    this.sound.play();
  }

  this.stop = function(){
    this.sound.pause();
  }

  this.src = src;

  this.isPlaying = function(){
    return !this.sound.ended;
  }
}