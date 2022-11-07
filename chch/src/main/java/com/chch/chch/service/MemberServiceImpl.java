package com.chch.chch.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chch.chch.dao.MemberDao;
import com.chch.chch.model.Member;


@Service
public class MemberServiceImpl implements MemberService{
	@Autowired
	private MemberDao md;

	//���̵� �ߺ��˻�
	public Member select(String id) {
		return md.select(id);
	}
	//�̸��� �ߺ��˻�
	public Member selectEmail(String email) {
		return md.selectEmail(email);
	}

	//�ʱ� ȸ������
	public int insert(Member member) {
		return md.insert(member);
	}

}