void function (Elm) {
  var app = Elm.Main.init({ node: document.getElementsByTagName('main')[0] });

  setTimeout(function () {
    // Add text-to-speech.. simulating loading time.
    app.ports.loaded.send(true);
  }, 800);
}(window.Elm);