package com.chch.chch.dao;

import com.chch.chch.model.Member;

public interface MemberDao {

	//���̵� �ߺ��˻�
	Member select(String id);
	//�̸��� �ߺ��˻�
	Member selectEmail(String email);

	//�ʱ� ȸ������
	int insert(Member member);


}