const AWS = require('aws-sdk'),
    SES = new AWS.SES(),
    processResponse = require('./process-response.js'),
    createTemplate = require('./create-template.js'),
    updateTemplate = require('./update-template.js');

exports.handler = async (event) => {
    const templateData = JSON.parse(event.body);

    return SES.getTemplate({ TemplateName: templateData.Template.TemplateName }).promise()
        .then(() => updateTemplate(templateData))
        .catch(err  => {
            if (err.code === 'TemplateDoesNotExist') {
                return createTemplate(templateData);
            } else {
                console.error(err, err.stack);
                const errorResponse = err.message;
                return processResponse(true, errorResponse, 500);
            }
        });
};
