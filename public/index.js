void function(Elm) {
  var app = Elm.Main.init({ node: document.getElementsByTagName('main')[0] });

  if (!window.speechSynthesis) {
    app.ports.loaded.send(true);
    return;
  }

  app.ports.loaded.send(true);
  return;

  var synth = window.speechSynthesis;
  var voice = null;

  function populateVoiceList() {
    if (voice !== null) {
      return;
    }

    voices = synth.getVoices();
    for(i = 0; i < voices.length ; i++) {
      var thisVoice = voices[i];
      if (thisVoice.name === 'Google US English') {
        voice = thisVoice;
        app.ports.loaded.send(true);
        break;
      }
    }
  }
  
  function speak (text){
    var utterance = new SpeechSynthesisUtterance(text);

    if (voice) {
      utterance.voice = voice;
    }
    
    synth.speak(utterance);
  }
  
  if (!speechSynthesis.onvoiceschanged) {
    speechSynthesis.onvoiceschanged = populateVoiceList;
  }

  populateVoiceList();
  app.ports.speak.subscribe(speak);
}(window.Elm);