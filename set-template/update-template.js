const AWS = require('aws-sdk'),
    processResponse = require('./process-response.js'),
    SES = new AWS.SES();

module.exports = (templateData) => {
    console.log("Updating existing email template", templateData.Template.TemplateName);

    return SES.updateTemplate(templateData).promise()
        .then(() => processResponse(null, 200))
        .catch(err => {
            console.error(err, err.stack);
            const errorResponse = err.message;
            return processResponse(true, errorResponse, 500);
        });
};
