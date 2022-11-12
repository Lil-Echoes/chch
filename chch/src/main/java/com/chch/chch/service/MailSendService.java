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


	// 난수 발생
	public void makeRandomNumber() {
		// 난수의 범위 111111 ~ 999999 (6자리 난수)
		Random r = new Random();
		int checkNum = r.nextInt(888888) + 111111;
		authNumber = checkNum;
	}

	// 이메일 보낼 양식
	public String joinEmail(String email, JavaMailSender jms) {
		makeRandomNumber();
		this.jms=jms;
		System.out.println("인증받을 이메일 : " + email);
		String setFrom = ".com"; // email-config에 설정한 자신의 이메일 주소를 입력
		String toMail = email;
		String title = "책첵 회원 가입 인증 이메일 입니다."; // 이메일 제목
		String content = "책첵을 방문해주셔서 감사합니다." + // html 형식으로 작성
				"<br><br>" + "인증 번호는 " + authNumber + "입니다." + "<br>" + "해당 인증번호를 인증번호 확인란에 기입하여 주세요."; // 이메일 내용 삽입
		mailSend(jms, setFrom, toMail, title, content);

		return Integer.toString(authNumber);
	}

	// 이메일 전송 메소드
	public void mailSend(JavaMailSender jms, String setFrom, String toMail, String title, String content) {
		MimeMessage mm = jms.createMimeMessage();
		// true 매개값을 전달하면 multipart 형식의 메세지 전달이 가능.문자 인코딩 설정도 가능하다.
		try {
			MimeMessageHelper mmh = new MimeMessageHelper(mm, true, "utf-8");
			mmh.setFrom("helen1282@naver.com");
			mmh.setTo(toMail);
			mmh.setSubject(title);
			// true 전달 > html 형식으로 전송 , 작성하지 않으면 단순 텍스트로 전달.
			mmh.setText(content, true);
			jms.send(mm);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
