const { select } = require('@inquirer/prompts');
const fs = require('fs');
const path = require('path');
const util = require('node:util');
const exec = util.promisify(require('node:child_process').exec);

const functions = require('./functions');

const execSync = (command = '') => {
    return exec(command);
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

        const config = JSON.parse(fs.readFileSync(path.join(__dirname, 'apps', app, 'config.json')));

        try {
            console.log(`> Changing application id to ${config['id']}`);
            await execSync(`dart run change_app_package_name:main ${config['id']}`);

            console.log(`> Changing application deep link to ${config['id']}`);
            await functions.changeDeepLink(config['id']);

            console.log(`> Changing application name to ${config['name']}`);
            await execSync(`dart run rename_app:main all="${config['name']}"`);

            console.log(`> Changing application api branch to ${config['branch']}`);
            process.chdir(path.join(__dirname, '..', '..', 'lib', 'app'));
            await execSync(`git checkout ${config['branch']}`)
            process.chdir(__dirname);

            console.log(`> Changing application logo`);
            await execSync(`flutter pub run flutter_launcher_icons -f ./scripts/cli/apps/${app}/flutter_launcher_icons.yaml`);
            fs.rmSync(path.join(__dirname, `../../android/app/src/main/res/mipmap-anydpi-v26`), {
                recursive: true,
                force: true
            });
        } catch (error) {
            console.error(error);
            process.exit(1);
        }
    },
    async build() {
        const flavor = await select({
            message: 'Choose your flavor:',
            choices: [
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
            case 'cafebazaar-aab':
                await exec('flutter build appbundle --flavor cafebazaar  --target lib/flavors/cafebazaar/main.dart');
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
