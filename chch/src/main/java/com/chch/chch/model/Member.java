package com.chch.chch.model;

import java.sql.Date;

import lombok.Data;
 
@Data
public class Member {	
	private String id; //���̵�
	private String password; //��й�ȣ(��ȣȭ)
	private String email; //�̸���
	private String name; //�̸�
	private String address; //�ּ�
	private String address_detail; //���ּ�
	private String birth; //�������
	private String gender; //����(1,2,3,4)
	private String phone; //�޴���ȭ(01011112222)
	private Date reg_date; //������
	private String del; //Ż�𿩺�

	
}