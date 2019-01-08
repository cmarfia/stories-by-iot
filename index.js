void (function (Elm, marked) {
  var app = Elm.Main.init({ node: document.getElementsByTagName('main')[0] });
  var polly = new AWS.Polly({ apiVersion: '2016-06-10' });
  var audioElem = document.createElement('audio');
  var imagesPreloaded = [];
  var imagesToPreload = [];
  var markdownOpts = {
    gfm: true,
    tables: false,
    breaks: false,
    sanitize: false,
    smartypants: true
  };

  function sendToElm(command, data = {}) {
    app.ports.fromJavaScript.send({ command, data });
  }

  // Text-to-speech always enabled with polly.
  AWS.config.region = 'us-east-1';
  AWS.config.credentials = new AWS.CognitoIdentityCredentials({ IdentityPoolId: 'us-east-1:72e56431-5930-4bb9-a461-ac16bc848f6d' });
  sendToElm('VOICE_LOADED');

  function assetLoaded(image) {
    return function () {
      var imageIndex = imagesToPreload.indexOf(image);
      if (imageIndex === -1) {
        return;
      }

      imagesToPreload.splice(imageIndex, 1);
      imagesPreloaded.push(image);
      if (imagesToPreload.length === 0) {
        sendToElm('IMAGES_LOADED');
      }
    }
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
      sendToElm('IMAGES_LOADED');
    }

    for (var i = 0; i < imagesToPreload.length; ++i) {
      loadImage(imagesToPreload[i]);
    }
  }

  function speak(text) {
    audioElem.pause();

    if (text === '') {
      return;
    }

    var sanitizeTextDiv = document.createElement('div');
    sanitizeTextDiv.innerHTML = marked(text, markdownOpts);
    var sanitizedText = sanitizeTextDiv.innerText;

    var speechParams = {
      OutputFormat: "mp3",
      SampleRate: "16000",
      Text: sanitizedText,
      TextType: "text",
      VoiceId: "Justin"
    };

    var signer = new AWS.Polly.Presigner(speechParams, polly);
    signer.getSynthesizeSpeechUrl(speechParams, function (error, url) {
      if (error) {
        alert('Text to Speech is currently not available.')
        return;
      }

      audioElem.src = url;
      audioElem.play();
    });
  }

  app.ports.toJavaScript.subscribe(function (msg) {
    switch (msg.command) {
      case 'PRELOAD_IMAGES':
        if (!Array.isArray(msg.data)) {
          return;
        }

        if (msg.data.length > 0) {
          preloadImages(msg.data);
        } else if (imagesToPreload.length === 0) {
          sendToElm('IMAGES_LOADED');
        }
        break
      case 'SPEAK':
        speak(msg.data || '');
        break
    }
  })
})(window.Elm, window.marked);
