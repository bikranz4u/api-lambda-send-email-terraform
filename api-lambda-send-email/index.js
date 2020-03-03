const AWS = require('aws-sdk'),
    SES = new AWS.SES(),
    processResponse = require('./process-response.js'),
    FROM_EMAIL = process.env.FROM_EMAIL;

exports.handler = (event) => {
    if (!event.body) {
        return Promise.resolve(processResponse('Please specify email parameter', 400));
    }
    const emailData = JSON.parse(event.body);

    if (!emailData.email) {
        return Promise.resolve(processResponse('Please specify email parameter', 400));
    }

    const destination = {
        ToAddresses: [emailData.email] // SES expects this to be a string array
    }

    if (emailData.ccEmails) {
        destination.CcAddresses = emailData.ccEmails;
    }

    console.log('Email template data', JSON.stringify(emailData));

    const templatedEmailParams = {
        Destination: destination,
        Template: emailData.templateName,
        Source: FROM_EMAIL,
        TemplateData: JSON.stringify(emailData),
    };

    // check if template exists before trying to send an email with it.
    return SES.getTemplate({ TemplateName: templatedEmailParams.Template }).promise()
        .then(() => sendTemplatedEmail(templatedEmailParams))
        .catch(err  => {
            if (err.code === 'TemplateDoesNotExist') {
                let englishTemplateName = getEnglishTemplateName(templatedEmailParams.Template);

                console.warn('Template name ' + templatedEmailParams.Template
                    + ' does not exist. Attempting to use ' + englishTemplateName);

                templatedEmailParams.Template = englishTemplateName;

                return sendTemplatedEmail(templatedEmailParams);
            } else {
                console.error(err, err.stack);
                const errorResponse = err.message;
                return processResponse(errorResponse, 500);
            }
        });
};

function sendTemplatedEmail(templatedEmailParams) {
    return SES.sendTemplatedEmail(templatedEmailParams).promise()
        .then(() => (processResponse()))
        .catch(err => {
            console.error(err, err.stack);
            const errorResponse = err.message;
            return processResponse(errorResponse, 500);
        });
}

function getEnglishTemplateName(localizedTemplateName) {
    // get just the template name without the language code. e.g, "MyTemplate-ja" becomes "MyTemplate"
    let templateName = localizedTemplateName.substring(0, localizedTemplateName.lastIndexOf('-'));

    return templateName + "-en";
}
