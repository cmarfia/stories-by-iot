void function(Elm) {
  var app = Elm.Main.init({ node: document.getElementsByTagName('main')[0] });

  if (!window.speechSynthesis) {
    return;
  }

  var synth = window.speechSynthesis;
  var voice = synth.getVoices()[0];
  app.ports.speak.subscribe(function(text) {
    document.getElementById('voices').innerText = JSON.stringify(window.speechSynthesis.getVoices().map(function(voice) { return voice.name; }), null, '\t');
    var utterance = new SpeechSynthesisUtterance(text);
    utterance.voice = voice;
    //utterance.pitch = 1;
    //utterance.rate = 1;
    synth.speak(utterance);
  });
}(window.Elm);