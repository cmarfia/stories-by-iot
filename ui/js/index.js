const app = Elm.Main.init({ node: document.getElementsByTagName('main')[0] });
const polly = new AWS.Polly({ apiVersion: '2016-06-10' });
const audioElem = document.createElement('audio');
const imagesPreloaded = [];
const imagesToPreload = [];
const markdownOpts = {
    gfm: true,
    tables: false,
    breaks: false,
    sanitize: false,
    smartypants: true
};

const sendToElm = (command, data = {}) => app.ports.fromJavaScript.send({ command, data });

// Text-to-speech always enabled with polly.
AWS.config.region = 'us-east-1';
AWS.config.credentials = new AWS.CognitoIdentityCredentials({ IdentityPoolId: 'us-east-1:72e56431-5930-4bb9-a461-ac16bc848f6d' });
sendToElm('VOICE_LOADED');

const assetLoaded = (image) =>
    () => {
        const imageIndex = imagesToPreload.indexOf(image);
        if (imageIndex === -1) {
            return;
        }

        imagesToPreload.splice(imageIndex, 1);
        imagesPreloaded.push(image);
        if (imagesToPreload.length === 0) {
            sendToElm('IMAGES_LOADED');
        }
    };

const loadImage = (image) => {
    const img = new Image();
    img.src = image;
    img.onload = assetLoaded(image);
    return img;
}

const preloadImages = (images) => {
    for (let i = 0; i < images.length; ++i) {
        const image = images[i];
        if (imagesPreloaded.indexOf(image) && imagesToPreload.indexOf(image)) {
            imagesToPreload.push(image);
        }
    }

    if (imagesToPreload.length === 0) {
        sendToElm('IMAGES_LOADED');
    }

    for (let i = 0; i < imagesToPreload.length; ++i) {
        loadImage(imagesToPreload[i]);
    }
}

const speak = (text) => {
    audioElem.pause();

    if (text === '') {
        return;
    }

    const sanitizeTextDiv = document.createElement('div');
    sanitizeTextDiv.innerHTML = marked(text, markdownOpts);
    const sanitizedText = sanitizeTextDiv.innerText;

    const speechParams = {
        OutputFormat: "mp3",
        SampleRate: "16000",
        Text: sanitizedText,
        TextType: "text",
        VoiceId: "Justin"
    };

    const signer = new AWS.Polly.Presigner(speechParams, polly);
    signer.getSynthesizeSpeechUrl(speechParams, (error, url) => {
        if (error) {
            alert('Text to Speech is currently not available.')
            return;
        }

        audioElem.src = url;
        audioElem.play();
    });
}

app.ports.toJavaScript.subscribe((msg) => {
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
