package com.chch.chch.service;

import com.chch.chch.model.Member;

public interface MemberService {
	
	//���̵� �ߺ��˻�
	Member select(String id);
	//�̸��� �ߺ��˻�
	Member selectEmail(String email);

	//�ʱ� ȸ������
	int insert(Member member);
	

}