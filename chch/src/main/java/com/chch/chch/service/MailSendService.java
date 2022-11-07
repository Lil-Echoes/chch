package com.chch.chch.service;

import java.util.Random;
import javax.mail.internet.MimeMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

@Component
public class MailSendService {
	private JavaMailSender jms;
	private int authNumber;


	// ���� �߻�
	public void makeRandomNumber() {
		// ������ ���� 111111 ~ 999999 (6�ڸ� ����)
		Random r = new Random();
		int checkNum = r.nextInt(888888) + 111111;
		authNumber = checkNum;
	}

	// �̸��� ���� ���
	public String joinEmail(String email, JavaMailSender jms) {
		makeRandomNumber();
		this.jms=jms;
		System.out.println("�������� �̸��� : " + email);
		String setFrom = ".com"; // email-config�� ������ �ڽ��� �̸��� �ּҸ� �Է�
		String toMail = email;
		String title = "åý ȸ�� ���� ���� �̸��� �Դϴ�."; // �̸��� ����
		String content = "åý�� �湮���ּż� �����մϴ�." + // html �������� �ۼ�
				"<br><br>" + "���� ��ȣ�� " + authNumber + "�Դϴ�." + "<br>" + "�ش� ������ȣ�� ������ȣ Ȯ�ζ��� �����Ͽ� �ּ���."; // �̸��� ���� ����
		mailSend(jms, setFrom, toMail, title, content);

		return Integer.toString(authNumber);
	}

	// �̸��� ���� �޼ҵ�
	public void mailSend(JavaMailSender jms, String setFrom, String toMail, String title, String content) {
		MimeMessage mm = jms.createMimeMessage();
		// true �Ű����� �����ϸ� multipart ������ �޼��� ������ ����.���� ���ڵ� ������ �����ϴ�.
		try {
			MimeMessageHelper mmh = new MimeMessageHelper(mm, true, "utf-8");
			mmh.setFrom("helen1282@naver.com");
			mmh.setTo(toMail);
			mmh.setSubject(title);
			// true ���� > html �������� ���� , �ۼ����� ������ �ܼ� �ؽ�Ʈ�� ����.
			mmh.setText(content, true);
			jms.send(mm);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

}