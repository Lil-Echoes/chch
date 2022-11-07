package com.chch.chch.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chch.chch.model.Member;
import com.chch.chch.service.MailSendService;
import com.chch.chch.service.MemberService;


@Controller
public class MemberController {
	@Autowired
	private JavaMailSender jms;
	@Autowired
	private MemberService ms;
	@Autowired
	private BCryptPasswordEncoder bpe; //��й�ȣ ��ȣȭ
	private String emailChk;
	
	@RequestMapping("main")
	public String main(HttpSession session) {
		String id = (String)session.getAttribute("id");
		return "main";
	}
	
	//�ʱ� ȸ������ ȭ��
	@RequestMapping("/member/joinForm")
	public String joinForm() {
		return "/member/joinForm";
	}
	
	//���̵� �ߺ��˻�
	@RequestMapping(value = "idDepChk", produces = "text/html;charset=utf-8")
	@ResponseBody //jsp�� �������� �ٷ� ������ ����
	public String idDepChk(String id, Model model) {
		String msg = "";
		Member member = ms.select(id);
		if(member == null) msg = "��� ������ ���̵� �Դϴ�";
		else msg = "�̹� ������̴� �ٸ� ���̵� ����ϼ���";
		return msg;
	}
	
	//ȸ������ ���� ���� �̸����� ������ �̸��� ����
	@RequestMapping(value="emailChk", produces="text/html;charset=utf-8")
	@ResponseBody
	public String emailChk(String email, Model model) {
		String msg = "";
		Member member = ms.selectEmail(email);
		if(member == null) {
			MailSendService mailsend = new MailSendService();
			emailChk = mailsend.joinEmail(email, jms);
			System.out.println("Controller�� �Ѿ�� �����ڵ� : " + emailChk);			
		}else {
			msg = "�ߺ��� �̸��� �Դϴ�";
		}
		return msg;
	}
	
	//ȸ������ ���� ���� ������ȣ�� ���Ϸ� ������ ������ȣ�� ��ġ�ϴ��� Ȯ��
	@RequestMapping(value="emailConfirm", produces="text/html;charset=utf-8")
	@ResponseBody
	public String emailConfirm(String emailConfirm, Model model) {
		System.out.println("���� ������ȣ : " + emailConfirm);
		System.out.println("���Ϸ� ���� ������ȣ : " + emailChk);
		String msg = "";
		if(emailChk.equals(emailConfirm)) {
			msg = "y";
		}else  {
			msg = "n";
		}
		return msg;
	}
	
	//ȸ������
	@RequestMapping("/member/join")
	public String join(Member member, Model model, HttpSession session){
		int result = 0;
		//member�� ȭ�� �Է��� ������, member2�� db�� �ִ� ������
		Member member2 = ms.select(member.getId());
		if(member2 == null) {
			String encPass = bpe.encode(member.getPassword()); //��й�ȣ ��ȣȭ
			member.setPassword(encPass);
			result = ms.insert(member);
		}else result = -1;//�̹� ������ �Է�������
		model.addAttribute("result", result);
		return "/member/join";
	}
	
	//�α��� ȭ��
	@RequestMapping("/member/loginForm")
	public String loginForm() {
		return "/member/loginForm";
	}
	
	//�α���
	@RequestMapping("/member/login")
	public String login(Member member, Model model, HttpSession session) {
		int result = 0;
		Member member2 = ms.select(member.getId());
		if (member2 == null || member2.getDel().equals("y")) result = -1; //���� ���̵�
		//bpe.matches db�� ��й�ȣ�� �޾ƿ� ��й�ȣ�� ��� ��ȣȭ �� ���·� ������ ��
		else if (bpe.matches(member.getPassword(), member2.getPassword())) {
			result = 1; //���� -> ���̵�� ��й�ȣ�� ��ġ�Ѵ�
			session.setAttribute("id", member.getId());
		}
		model.addAttribute("result", result);
		return "/member/login";
	}

}