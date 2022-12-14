package com.chch.chch.dao;

import java.util.List;

import com.chch.chch.model.Book;
import com.chch.chch.model.Report;
import com.chch.chch.model.Review;

public interface NewBookDao {

	List<Book> bookListAll(Book book);

	List<Book> bookListSelect(Book book);

	int getTotal(Book book);

	Book selectbook(int book_no);

	List<Review> reviewList(Review review);

	int review_cnt(int book_no);

	int getTotal(Review review);

	double star_avg(Review review);

	int selectReview_cnt(int book_no);

	List<Book> searchList(Book book);

	List<Report> reportList(Report report);

	int getTotal1(Report report);

	// HYC
		// 책 번호로 책 리스트 불러오기
		Book list(int book_no);

		// 책 구매시 수량 변경
		int update2(Book book);


}
