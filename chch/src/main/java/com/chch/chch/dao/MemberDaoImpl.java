package com.chch.chch.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.chch.chch.model.Member;


@Repository
public class MemberDaoImpl implements MemberDao{
	@Autowired
	private SqlSessionTemplate sst;

	//���̵� �ߺ��˻�
	public Member select(String id) {
		return sst.selectOne("memberns.select", id);
	}
	//�̸��� �ߺ��˻�
	public Member selectEmail(String email) {
		return sst.selectOne("memberns.selectEmail", email);
	}

	//�ʱ� ȸ������
	public int insert(Member member) {
		return sst.insert("memberns.insert", member);
	}

}