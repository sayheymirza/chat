const fs = require('fs');
const path = require('path');

module.exports = {
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