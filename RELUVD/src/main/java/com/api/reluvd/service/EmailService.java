 package com.api.reluvd.service;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.stereotype.Service;

@Service
public class EmailService {

	public boolean sendEmail(String subject,String message,String to)
	{
		boolean flag=false;
		String from="reluvd.official@gmail.com";
		//variable for gmail
		String host="smtp.gmail.com";
		//get the system properties
		Properties properties=System.getProperties();
		//host set
		properties.put("mail.smtp.host",host);
		properties.put("mail.smtp.port","465");
		properties.put("mail.smtp.ssl.enable",true);
		properties.put("mail.smtp.auth",true);
		//step1: to get session object 
		Session session=Session.getInstance(properties, new Authenticator()
				{
			@Override
			protected PasswordAuthentication getPasswordAuthentication()
			{
				return new PasswordAuthentication("reluvd.official@gmail.com","djpp ehhk kwnv hxiv");
			}
				});
	
		//step2:compose the message
		MimeMessage m =new MimeMessage(session);//multipurpose internet mail extension..matlab it can not only send text but also attachments
		try
		{
			m.setFrom(from);
			m.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
			m.setSubject(subject);
			m.setText(message);
			Transport.send(m);
			flag=true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return flag;
	}
}
