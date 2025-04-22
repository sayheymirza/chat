const { select } = require('@inquirer/prompts');
const fs = require('fs');
const path = require('path');
const util = require('node:util');
const exec = util.promisify(require('node:child_process').exec);

const functions = require('./functions');

const execSync = async (command = '') => {
    const result = await exec(command);

    if (result.stderr) {
        console.error(result.stderr);
    }
}

module.exports = {
    menu() {
        return select({
            message: 'What do you want to do?',
            choices: [
                {
                    name: 'Change application info (name, id, logo)',
                    value: 'change-application-info'
                },
                {
                    name: 'Change flavor',
                    value: 'change-flavor',
                },
                {
                    name: 'Build',
                    value: 'build'
                },
                {
                    name: 'Exit',
                    value: 'exit'
                }
            ],
        });
    },
    async info() {
        const apps = fs.readdirSync(
            path.join(__dirname, 'apps')
        );

        const app = await select({
            message: 'Choose your app:',
            choices: apps.map((app) => ({ name: app, value: app }))
        });

        await functions.info(app);
    },
    async build() {
        const flavor = await select({
            message: 'Choose your flavor:',
            choices: [
                {
                    name: 'Google Play AAB',
                    value: 'google-play-aab'
                },
                {
                    name: 'Google Play',
                    value: 'google-play'
                },
                {
                    name: 'Cafebazaar AAB',
                    value: 'cafebazaar-aab'
                },
                {
                    name: 'Cafebazaar',
                    value: 'cafebazaar'
                },
                {
                    name: 'Direct',
                    value: 'direct'
                },
                {
                    name: 'Web',
                    value: 'web'
                }
            ]
        });

        switch (flavor) {
            case 'google-play-aab':
                await exec('flutter build appbundle --flavor google_play  --target lib/flavors/google-play/main.dart');
                break;
            case 'cafebazaar-aab':
                await exec('flutter build appbundle --flavor cafebazaar  --target lib/flavors/cafebazaar/main.dart');
                break;
            case 'google-play':
                await exec('flutter build apk --flavor google_play --target lib/flavors/google-play/main.dart --split-per-abi');
                break;
            case 'cafebazaar':
                await exec('flutter build apk --flavor cafebazaar --target lib/flavors/cafebazaar/main.dart --split-per-abi');
                break;
            case 'direct':
                await exec('flutter build apk --flavor direct --target lib/flavors/direct/main.dart  --split-per-abi');
                break;
            case 'web':
                await exec('flutter build web --target lib/flavors/web/main.dart');
                break;

            default:
                break;
        }
    },
    async flavor() {
        const flavor = await select({
            message: 'Choose your flavor:',
            choices: [
                {
                    name: 'Cafebazaar',
                    value: 'cafebazaar'
                },
                {
                    name: 'Myket',
                    value: 'myket'
                },
                {
                    name: 'Empty',
                    value: 'empty'
                },
            ],
            default: 'empty'
        });

        await functions.changePubspec(flavor);
        console.log('> Running flutter pub get');
        await execSync('flutter pub get');
    },
}
