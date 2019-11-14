"use strict";

exports.playAudio = function(audioId){
  try{
    var audio = new sound("/audio/" + audioId);
    audio.play();
    
    return true;
  }
  catch(e){
    return false;
  }
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
}