package com.chch.chch.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chch.chch.model.Chat;
import com.chch.chch.model.Community;
import com.chch.chch.service.ChatService;
import com.chch.chch.service.CommunityService;

@Controller
public class CommunityController {
	
	@Autowired
	private CommunityService coms;
	
	@Autowired
	private ChatService cs;
	
//	SB 커뮤니티 글 등록 화면
	@RequestMapping("communityInsertForm")
	public String communityInsertForm() {
		return "/community/communityInsertForm";
	}
	
//	SB 커뮤니티 글 등록
	@RequestMapping("communityInsert")
	public String communityInsert(Model model, HttpSession session, Community community) {
		String id = (String)session.getAttribute("id");
		int new_room_no = cs.currentLastRoom()+1;
		
		Chat chat = new Chat();
		int intRoom_no = new_room_no;
		String room_no = String.valueOf(intRoom_no);
		chat.setRoom_no(room_no);
		chat.setId(id);
		chat.setRoom_name(community.getCommunity_subject());
		
		cs.insertRoom(chat);
		
		community.setRoom_no(room_no);
		community.setHost_id(id);
		int result = coms.insert(community);
		
		int community_no = coms.selectByRoomNo(intRoom_no);
		
		model.addAttribute("result", result);
		model.addAttribute("community_no", community_no);
		
		return "/community/communityInsert";
	}
	
	@RequestMapping("communityDetail")
	public String communityDetail(Model model, HttpSession session, int community_no) {
		String id = (String)session.getAttribute("id");
		Community community = coms.select(community_no);
		String room_no = community.getRoom_no();
		int intRoom_no = Integer.parseInt(room_no);
		int participation = coms.participation(intRoom_no, id);
		community.setParticipation(participation);
		
		String room_name = coms.selectRoomName(intRoom_no);
		
		int currentMember = coms.currentMember(intRoom_no);
		
		model.addAttribute("id", id);
		model.addAttribute("community", community);
		model.addAttribute("room_name", room_name);
		model.addAttribute("currentMember", currentMember);
		return "/community/communityDetail";
	}
	
	@RequestMapping("communityMyList")
	public String communityMyList(Model model, HttpSession session, Community community) {
		String id = (String)session.getAttribute("id");
		List<Community> communityMyList = coms.communityMyList(id);
		
		
		for (int i=0; i < communityMyList.size(); i++) {
			communityMyList.get(i).setCurrentMember(coms.currentMember(Integer.parseInt(communityMyList.get(i).getRoom_no())));
		}
		
		model.addAttribute("communityMyList", communityMyList);
		
		return "/community/communityMyList";
	}
	
	@RequestMapping("communityAllList")
	public String communityAllList(Model model, HttpSession session, Community community) {
		List<Community> communityAllList = coms.communityAllList();
		
		for (int i=0; i < communityAllList.size(); i++) {
			communityAllList.get(i).setCurrentMember(coms.currentMember(Integer.parseInt(communityAllList.get(i).getRoom_no())));
		}
		
		model.addAttribute("communityAllList", communityAllList);
		
		return "/community/communityAllList";
	}
	
	@RequestMapping("joinRoom")
	public String joinChat(Model model, HttpSession session, String room_no) {
		String id = (String)session.getAttribute("id");
		
		int intRoom_no = Integer.parseInt(room_no);
		String room_name = coms.selectRoomName(intRoom_no);
		
		Community community = new Community();
		community.setRoom_no(room_no);
		community.setId(id);
		community.setRoom_name(room_name);
		
//		기존에 가입했던 방인지 확인
		int leaveHistory = coms.leaveHistoryChk(intRoom_no, id);
		int result = 0;
		if (leaveHistory > 0) {
			result = coms.rejoinRoom(intRoom_no, id);
		} else {
			result = coms.joinRoom(intRoom_no, id, room_name);
		}
		
		model.addAttribute("result", result);
		model.addAttribute("community", community);
		
		return "/community/joinRoom";
	}
	
	@RequestMapping("communityLeave")
	public String communityLeave(Model model, HttpSession session, int community_no) {
		String id = (String)session.getAttribute("id");
		
		Community community = coms.select(community_no);
		
		int intRoom_no = Integer.parseInt(community.getRoom_no());
		
		int result = coms.leaveRoom(id, intRoom_no);
		
		if (result > 0) {
		Chat chat = new Chat();
		chat.setRoom_no(community.getRoom_no());
		chat.setId(id);
		chat.setChat_content(id+"님이 퇴장하였습니다");
		cs.insertChat(chat);
		}
		
		model.addAttribute("result", result);
		return "/community/communityLeave";
	}
	
	@RequestMapping("communityDelete")
	public String communityDelete(Model model, HttpSession session, int community_no) {
		String id = (String)session.getAttribute("id");
		
		Community community = coms.select(community_no);
		
		String room_no = community.getRoom_no();
		int intRoom_no = Integer.parseInt(room_no);
		
		coms.banRoom(intRoom_no);
		
		int result = coms.communityDelete(id, community_no);
		
		model.addAttribute("result", result);
		
		return "/community/communityDelete";
	}
	
	
}


