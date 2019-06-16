void function (window, document, Elm) {
    window.storybook = window.storybook || {};
    window.storybook.init = (node, flags) => {
        const app = Elm.Main.init({ node, flags });
        const audioElem = document.createElement('audio');
        const imagesPreloaded = [];
        const imagesToPreload = [];

        const sendToElm = (command, data = {}) => app.ports.fromJavaScript.send({ command, data });

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

        const speak = (audioLink) => {
            audioElem.pause();

            if (audioLink === '') {
                return;
            }

            audioElem.src = audioLink;
            audioElem.play();
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
    };
}(window, document, Elm);
