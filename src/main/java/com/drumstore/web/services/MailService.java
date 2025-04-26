package com.drumstore.web.services;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;
import java.util.UUID;

public class MailService {
    static final String from = "flourinee@gmail.com"; // thay đổi
    static final String password = "jalaxigukuvlqsct"; // thay đổi

    // gửi email
    public boolean sendEmail(String to, String subject, String content) {
        // Properties for SMTP connection
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Authenticator for SMTP
        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        // Create a mail session with authentication
        Session session = Session.getInstance(props, auth);

        try {
            // Create a new email message
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject(subject);
            msg.setSentDate(new Date());
            msg.setContent(content, "text/html; charset=UTF-8");

            // Send email
            Transport.send(msg);
            System.out.println("Email sent successfully");
            return true;
        } catch (Exception e) {
            System.out.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // tạo mã xác thực ngẫu nhiên
    public String generateVerificationCode() {
        return UUID.randomUUID().toString();
    }


    public void sendVerificationEmail(String toEmail, String verificationCode) {
        String subject = "Mã OTP xác thực";
        String content = "Mã OTP của bạn là: <strong>" + verificationCode + "</strong>. " +
                "Mã này có hiệu lực trong 5 phút. Vui lòng sử dụng mã này để xác thực.";

        // Sử dụng hàm gửi email của bạn để gửi
        sendEmail(toEmail, subject, content);
    }

}

