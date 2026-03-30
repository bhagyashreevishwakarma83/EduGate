package Mailer;

import java.io.InputStream;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Mailer {

    static String from;
    static String password;

    static {
        try {
            Properties config = new Properties();
            InputStream input = Mailer.class.getClassLoader()
                .getResourceAsStream("config.properties");
            config.load(input);
            from = config.getProperty("mail.from");
            password = config.getProperty("mail.password");
        } catch (Exception e) {
            throw new RuntimeException("Could not load config.properties", e);
        }
    }

    public static void send(String to, String sub, String msg) {

        Properties props = new Properties();
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
            new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, password);
                }
            });

        try {
            MimeMessage message = new MimeMessage(session);
            try {
                message.setFrom(new InternetAddress(from, "Admin Panel"));
            } catch (Exception e) {
                message.setFrom(new InternetAddress(from));
            }
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(sub);
            message.setText(msg);
            Transport.send(message);
            System.out.println("message sent successfully");

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}