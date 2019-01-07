void (function (Elm, marked) {
  AWS.config.region = 'us-east-1';
  AWS.config.credentials = new AWS.CognitoIdentityCredentials({ IdentityPoolId: 'us-east-1:72e56431-5930-4bb9-a461-ac16bc848f6d' });
  var polly = new AWS.Polly({ apiVersion: '2016-06-10' });
  var audioElem = document.getElementById('audioPlayback');
  var canUsePolly = true;
  var imagesPreloaded = [];
  var imagesToPreload = [];
  var synthVoice = null;
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

  function populateVoiceList() {
    if (synthVoice !== null) {
      return;
    }

    synthVoice = undefined;
    var voices = window.speechSynthesis.getVoices();
    for (var i = 0; i < voices.length; i++) {
      var voice = voices[i];
      if (voice.name === 'Google US English') {
        synthVoice = voice;
      }
    }

    sendToElm('VOICE_LOADED');
  }

  function speakFallback(text) {
    window.speechSynthesis.cancel();

    if (text === '') {
      return;
    }

    var utterance = new window.SpeechSynthesisUtterance(text);

    if (synthVoice) {
      utterance.voice = synthVoice;
    }

    window.speechSynthesis.speak(utterance);
  }

  function speak(text) {
    var sanitizeTextDiv = document.createElement('div');
    sanitizeTextDiv.innerHTML = marked(text, {
      gfm: true,
      tables: false,
      breaks: false,
      sanitize: false,
      smartypants: true
    });
    var sanitizedText = sanitizeTextDiv.innerText;

    if (!canUsePolly) {
      speakFallback(sanitizedText);
      return;
    }

    if (audioElem === null) {
      audioElem = document.getElementById('audioPlayback');

      if (audioElem === null) {
        canUsePolly = false;
        speakFallback(sanitizedText);
        return;
      }
    }


    audioElem.pause();

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
        canUsePolly = false;
        speakFallback(sanitizedText);
      } else {
        audioElem.src = url;
        audioElem.play();
      }
    });
  }

  if (window.speechSynthesis && !window.speechSynthesis.onvoiceschanged) {
    speechSynthesis.onvoiceschanged = populateVoiceList;
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
