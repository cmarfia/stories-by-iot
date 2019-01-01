void function (Elm) {
  var app = Elm.Main.init({ node: document.getElementsByTagName('main')[0] });

  // Add text-to-speech
  app.ports.loaded.send(true);
}(window.Elm);