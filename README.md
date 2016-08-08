# HTML-909

Source code for [http://html909.com](http://html909.com)

## Getting started

Follow this to get the basic development env running

1. Install dependencies: `npm install && bower install`.
2. Run the development server: `grunt server`
3. Build the drum machine: `grunt build`

### Sound samples

Sound samples are not distributed with this repository, you need to find them from somewhere else and place the samples in `/app/sounds/` directory.

Sounds are expected to be WAV files and filenames for the samples matches to sound objects defined in `app/service/preset-storage.coffee`. Eg. sample for the sound `presets.sounds.snare_drum` should be located in `/app/sounds/snare_drum.wav`.

### Firebase URL

Html909.com uses Firebase as a JSON storage for tracks. You can use Firebase by editing `app/service/preset-storage.coffee` and setting your Firebase URL to `firebaseAppUrl` field.