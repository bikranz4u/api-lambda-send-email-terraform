const AWS = require('aws-sdk'),
    processResponse = require('./process-response.js'),
    SES = new AWS.SES();

module.exports = (templateData) => {
    console.log("Creating new email template", templateData.Template.TemplateName);

    return SES.createTemplate(templateData).promise()
        .then(() => processResponse(null, 201))
        .catch(err => {
            console.error(err, err.stack);
            const errorResponse = err.message;
            return processResponse(true, errorResponse, 500);
        });
};
