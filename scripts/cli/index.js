const commands = require('./commands');

const menu = async () => {
    try {
        const option = await commands.menu();

        switch (option) {
            case 'change-application-info':
                await commands.info();
                break;

            case 'exit':
                process.exit(0);
                break;

            default:
                break;
        }
    } catch (error) {
        //
    }


    menu();
}

menu();