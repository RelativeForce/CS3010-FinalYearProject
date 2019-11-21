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

exports.play = function(just){
  return function(nothing){
    return function(src){
      return function(){
        try {
          var audio = new sound(src);
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