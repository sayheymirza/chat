const { checkbox, input, select } = require('@inquirer/prompts');
const fs = require('fs');
const path = require('path');
const util = require('node:util');
const exec = util.promisify(require('node:child_process').exec);

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

            console.log(`> Changing application name to ${config['name']}`);
            await execSync(`dart run rename_app:main all="${config['name']}"`);

            console.log(`> Changing application api branch to ${config['branch']}`);
            process.chdir(path.join(__dirname, '..', '..', 'lib', 'app'));
            await execSync(`git checkout ${config['branch']}`)
            process.chdir(__dirname);

            console.log(`> Changing application logo`);
            await execSync(`dart run flutter_launcher_icons:generate -f ./apps/${app}/flutter_launcher_icons.yaml`);
        } catch (error) {
            console.error(error);
            process.exit(1);
        }
    }
}
