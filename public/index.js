void function (Elm) {
  var imagesPreloaded = [];
  var imagesToPreload = [];
  var app = Elm.Main.init({ node: document.getElementsByTagName('main')[0] });

  function sendToElm(command, data = {}) {
    app.ports.fromJavaScript.send({ command, data });
  }

  function assetLoaded(image) {
    return function () {
      var imageIndex = imagesToPreload.indexOf(image);
      if (imageIndex === -1) {
        return;
      }

      imagesToPreload.splice(imageIndex, 1);
      imagesPreloaded.push(image);
      if (imagesToPreload.length === 0) {
        sendToElm('IMAGES_LOADED')
      }
    };
  }

  function loadImage(image) {
    var img = new Image();
    img.src = image;
    img.onload = assetLoaded(image);
    return img;
  }

  function preloadImages(images) {
    for (var i = 0; i < images.length; ++i) {
      var image = images[i];
      if (imagesPreloaded.indexOf(image) && imagesToPreload.indexOf(image)) {
        imagesToPreload.push(image);
      }
    }

    if (imagesToPreload.length === 0) {
      sendToElm('IMAGES_LOADED')
    }

    for (var i = 0; i < imagesToPreload.length; ++i) {
      loadImage(imagesToPreload[i]);
    }
  }

  app.ports.toJavaScript.subscribe(function (msg) {
    switch (msg.command) {
      case "PRELOAD_IMAGES":
        if (!Array.isArray(msg.data)) {
          return;
        }

        if (msg.data.length > 0) {
          preloadImages(msg.data);
        } else if (imagesToPreload.length === 0) {
          sendToElm('IMAGES_LOADED')
        }
        break;
    }
  });
}(window.Elm);
