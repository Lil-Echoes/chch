package com.chch.chch.service;

import java.util.List;

import com.chch.chch.model.Deal;

public interface DealService {
	/* ���Ÿ�� */
	List<Deal> list(String id);

	/* ���Ÿ�� ���� n => y */
	int update(int deal_no, String id);

	/* �ǸŸ�� */
	List<Deal> sales_list(String id);

	/* �ǸŸ�� ���� n => y */
	int sales_update(int deal_no, String id);




}
