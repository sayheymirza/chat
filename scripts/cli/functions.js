const fs = require('fs');
const path = require('path');
const util = require('node:util');
const exec = util.promisify(require('node:child_process').exec);

const execSync = async (command = '') => {
    const result = await exec(command);

    if (result.stderr) {
        console.error(result.stderr);
    }
}

module.exports = {
    async info(app) {
        const config = JSON.parse(fs.readFileSync(path.join(__dirname, 'apps', app, 'config.json')));

        try {
            console.log(`> Changing application id to ${config['id']}`);
            await execSync(`dart run change_app_package_name:main ${config['id']}`);

            console.log(`> Changing google services application id to ${config['id']}`);
            await this.changeGoogleServices(config['id']);

            console.log(`> Changing application deep link to ${config['id']}`);
            await this.changeDeepLink(config['id']);

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
    async changeDeepLink(id = '') {
        const convert = require('xml-js');
        const prettier = require('prettier');

        const file = path.join(__dirname, '..', '..', 'android', 'app', 'src', 'main', 'AndroidManifest.xml');

        const input = fs.readFileSync(file);


        const data = JSON.parse(convert.xml2json(input, { compact: true }));
        for (let intent of data['manifest']['application']['activity']['intent-filter']) {
            if (intent['data'] && intent['data']['_attributes'] && intent['data']['_attributes']['android:scheme'] == 'app') {
                intent['data']['_attributes']['android:host'] = id;
            }
        }

        const output = await prettier.format(convert.json2xml(JSON.stringify(data), { compact: true }), {
            parser: 'html',
            tabWidth: 2,
            htmlWhitespaceSensitivity: "ignore"
        });

        fs.writeFileSync(file, output);
    },
    async changeGoogleServices(id = '') {
        const file = path.join(__dirname, '..', '..', 'android', 'app', 'google-services.json');

        const input = JSON.parse(fs.readFileSync(file).toString());
        input['client'][0]['client_info']['android_client_info']['package_name'] = id;

        fs.writeFileSync(file, JSON.stringify(input, null, 2));
    },
    async changePubspec(flavor) {
        const yaml = require('yaml');

        const file = path.join(__dirname, '..', '..', 'pubspec.yaml');

        const input = yaml.parse(fs.readFileSync(file).toString());

        delete input['dependencies']['flutter_poolakey'];
        delete input['dependencies']['myket_iap'];

        switch (flavor) {
            case 'cafebazaar':
                input['dependencies']['flutter_poolakey'] = {
                    'path': './lib/flavors/cafebazaar/flutter_poolakey'
                };
                break;

            case 'myket':
                input['dependencies']['myket_iap'] = '^1.1.6';
                break;
            default:
                break;
        }

        fs.writeFileSync(file, yaml.stringify(input));
    },
}