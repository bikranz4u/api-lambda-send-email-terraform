module.exports = (body, statusCode) => {
    const status = statusCode;
    const headers = { 'Content-Type': 'application/json' };

    return {
        statusCode: status,
        body: body ? JSON.stringify(body) : '',
        headers: headers
    };
};
