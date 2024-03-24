

const nodemailer = require('nodemailer');

const sendEmail = async (options) => {
    const transporter = nodemailer.createTransport({
        host: "sandbox.smtp.mailtrap.io",
        port: 2525,
        auth: {
            user: "7c4abb9330525c",
            pass: "0d7ac612045bd9"
        }
    });

    const emailOptions = {
        from: 'CineFlix support <support@cineflix.com>',
        to: options.email,
        subject: options.subject,
        text: options.message
    };

    await transporter.sendMail(emailOptions);
};

module.exports = sendEmail;
