package com.drumstore.web.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailSender {
    private static final String FROM_EMAIL = ConfigUtils.get("email.sender");
    private static final String PASSWORD = ConfigUtils.get("email.password");

    public static void sendPasswordResetEmail(String toEmail, String resetToken) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Đặt Lại Mật Khẩu - Drum Store");

            String resetLink = "http://localhost:8080/forgot-password?token=" + resetToken;
            String htmlContent = String.format("""
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body {
                            font-family: 'Segoe UI', Arial, sans-serif;
                            line-height: 1.6;
                            color: #333;
                        }
                        .container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #f9fafb;
                        }
                        .header {
                            text-align: center;
                            padding: 20px 0;
                            background-color: #fcc419;
                            border-radius: 8px 8px 0 0;
                        }
                        .header h1 {
                            color: #1B2832;
                            margin: 0;
                            font-size: 24px;
                        }
                        .content {
                            background-color: #ffffff;
                            padding: 30px;
                            border-radius: 0 0 8px 8px;
                            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        }
                        .reset-button {
                            display: inline-block;
                            padding: 12px 24px;
                            background-color: #fcc419;
                            color: #1B2832;
                            text-decoration: none;
                            border-radius: 6px;
                            font-weight: bold;
                            margin: 20px 0;
                            transition: background-color 0.3s ease;
                        }
                        .reset-button:hover {
                            background-color: #f0b400;
                        }
                        .footer {
                            text-align: center;
                            margin-top: 20px;
                            color: #666;
                            font-size: 14px;
                        }
                        .warning {
                            background-color: #fff3cd;
                            border: 1px solid #ffeeba;
                            color: #856404;
                            padding: 12px;
                            border-radius: 4px;
                            margin-top: 20px;
                            font-size: 14px;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🥁 Drum Store</h1>
                        </div>
                        <div class="content">
                            <h2>Xin chào quý khách,</h2>
                            <p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn tại Drum Store.</p>
                
                            <p>Để đặt lại mật khẩu, vui lòng nhấn vào nút bên dưới:</p>
                
                            <div style="text-align: center;">
                                <a href="%s" class="reset-button">Đặt Lại Mật Khẩu</a>
                            </div>
                
                            <div class="warning">
                                <strong>Lưu ý:</strong>
                                <ul style="margin: 5px 0; padding-left: 20px;">
                                    <li>Liên kết này sẽ hết hạn sau 30 phút</li>
                                    <li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>
                                </ul>
                            </div>
                
                            <p>Nếu bạn gặp khó khăn khi nhấn vào nút trên, có thể copy và paste đường link sau vào trình duyệt:</p>
                            <p style="word-break: break-all; font-size: 14px; color: #666;">%s</p>
                        </div>
                
                        <div class="footer">
                            <p>Email này được gửi tự động, vui lòng không trả lời.</p>
                            <p>&copy; 2025 Drum Store. All rights reserved.</p>
                        </div>
                    </div>
                </body>
                </html>
                """, resetLink, resetLink);

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);

        } catch (MessagingException e) {
            throw new RuntimeException("Lỗi khi gửi email: " + e.getMessage());
        }
    }
} 