

const nodemailer = require('nodemailer');

const sendEmail = async (options) => {
    const transporter = nodemailer.createTransport({
        service:"gmail",
        host: "smtp.gmail.com",
        port: 587,
        auth: {
            user: "gandouzakrem48@gmail.com",
            pass: "ykfv nhvu vuxi qocr"
        }
    });

    const emailOptions = {
        from: 'Capgemini-santé support <support@capgemini.com>',
        to: options.email,
        subject: options.subject,
        text: options.message
    };

    await transporter.sendMail(emailOptions);
};

module.exports = sendEmail;
