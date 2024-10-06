const commands = require('./commands');

const menu = async () => {
    try {
        const option = await commands.menu();

        switch (option) {
            case 'change-application-info':
                await commands.info();
                break;

            case 'change-flavor':
                await commands.flavor();
                break;

            case 'build':
                await commands.build();
                break;

            case 'exit':
                process.exit(0);
                break;

            default:
                break;
        }
    } catch (error) {
        console.error(error);
    }


    menu();
}

menu();