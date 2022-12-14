package com.chch.chch.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chch.chch.model.Inquiry;
import com.chch.chch.service.InquiryService;

@Controller
public class InquiryController {
	
	@Autowired
	private InquiryService ins;
	
	@RequestMapping("inquiryMain")
	public String inquiryMain () {
		return "/inquiry/inquiryMain";
	}
	
	@RequestMapping("inquiryMainForList")
	public String inquiryMainForList () {
		return "/inquiry/inquiryMainForList";
	}
	
	@RequestMapping("inquiryMainForAdmin")
	public String inquiryMainForAdmin (Model model, String id) {
		model.addAttribute("id", id);
		return "/inquiry/inquiryMainForAdmin";
	}
	
	
	@RequestMapping("faq")
	public String faq (Model model, String inquiryNumber) {
		model.addAttribute("inquiryNumber", inquiryNumber);
		return "/inquiry/nolay/faq";
	}
	
	@RequestMapping("inquirySelect")
	public String inquirySelect (Model model, String inquiryNumber) {
		
		model.addAttribute("inquiryNumber", inquiryNumber);
		
		return "/inquiry/nolay/inquirySelect";
	}
	
	@RequestMapping("inquiryForm")
	public String inquiryForm (Model model, int page) {
		
		model.addAttribute("page", page);
		
		return "/inquiry/nolay/inquiryForm";
	}
	
	@RequestMapping("inquiry")
	public String inquiry (Model model, HttpSession session, Inquiry inquiry) {
		String id = (String)session.getAttribute("id");
		
		inquiry.setId(id);
		inquiry.setInquiry_subject(inquiry.getInquiry_subject().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")); 
		inquiry.setInquiry_content(inquiry.getInquiry_content().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
		
		int result = ins.inquirySubmit(inquiry);
		
		model.addAttribute("result", result);
		
		return "/inquiry/inquiry";
	}
	
	@RequestMapping("inquiryList")
	public String inquiryList (Model model, HttpSession session, String inquiryNumber, String pageNum) {
		String id = (String)session.getAttribute("id");
		
		final int ROW_PER_PAGE = 10;
		final int PAGE_PER_BLOCK = 10;
		if (pageNum == null || pageNum.equals("")) pageNum = "1";
		int currentPage = Integer.parseInt(pageNum);
		int startRow = (currentPage - 1) * ROW_PER_PAGE + 1;
		int endRow = startRow + ROW_PER_PAGE - 1;
		int total = ins.getTotal();
		int totalPage = (int) Math.ceil((double)total/ROW_PER_PAGE);
		int startPage = currentPage - (currentPage - 1) % PAGE_PER_BLOCK;
		int endPage = startPage + PAGE_PER_BLOCK - 1;
		
		if (endPage > totalPage) endPage = totalPage;
		List<Inquiry> inquiryList = ins.inquiryList(startRow, endRow, id);
		
		model.addAttribute("inquiryList", inquiryList);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("PAGE_PER_BLOCK", PAGE_PER_BLOCK);
		model.addAttribute("inquiryNumber", inquiryNumber);
		
		return "/inquiry/nolay/inquiryList";
	}
	
	@RequestMapping("inquiryListForAdmin")
	public String inquiryListForAdmin (Model model, HttpSession session, String inquiryNumber, String pageNum, String id) {
		final int ROW_PER_PAGE = 10;
		final int PAGE_PER_BLOCK = 10;
		if (pageNum == null || pageNum.equals("")) pageNum = "1";
		int currentPage = Integer.parseInt(pageNum);
		int startRow = (currentPage - 1) * ROW_PER_PAGE + 1;
		int endRow = startRow + ROW_PER_PAGE - 1;
		int total = ins.getTotal();
		int totalPage = (int) Math.ceil((double)total/ROW_PER_PAGE);
		int startPage = currentPage - (currentPage - 1) % PAGE_PER_BLOCK;
		int endPage = startPage + PAGE_PER_BLOCK - 1;
		
		if (endPage > totalPage) endPage = totalPage;
		List<Inquiry> inquiryList = ins.inquiryList(startRow, endRow, id);
		
		model.addAttribute("inquiryList", inquiryList);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("PAGE_PER_BLOCK", PAGE_PER_BLOCK);
		model.addAttribute("inquiryNumber", inquiryNumber);
		model.addAttribute("memberId", id);
		
		return "/inquiry/nolay/inquiryListForAdmin";
	}
	
	
	@RequestMapping(value = "replyCheck", produces = "text/html;charset=utf-8")
	public String replyCheck (@RequestParam("inquiry_no") String inquiry_no, Model model) {
		
		int inquiry_no2=Integer.parseInt(inquiry_no);
		int result = ins.replyCheck(inquiry_no2);
		
		model.addAttribute("result", result);
		
		return "/inquiry/nolay/inquiryList";
	}
	
	@RequestMapping(value = "loadUnreadInquiry", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String loadUnreadInquiry(HttpSession session, Model model) {
		
		String id = (String)session.getAttribute("id");
		
		int result = ins.unreadInquiryCount(id);
		
		String unreadInquiryCount = String.valueOf(result);
		
		return unreadInquiryCount;
	}
	
}
