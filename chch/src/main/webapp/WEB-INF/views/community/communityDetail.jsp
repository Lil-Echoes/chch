<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">@import url("/chch/resources/css/community.css");</style>

<script type="text/javascript">

	$(function() {
		$('#currentMemberChk').click(function() { currentMemberChk(); });
   		$('#communityDelete').click(function() { communityDelete(); });
   		$('#communityLeave').click(function() { communityLeave(); });
   		$('#communityJoin').click(function() { communityJoin(); });
	});
	
	function communityJoin() {
		var currentMember = ${currentMember};
		var maxMember = ${community.max_member };
		
		console.log(currentMember+"/"+ maxMember);
		
		
		
		if (currentMember >= maxMember ) {
			alert("가입 인원이 가득 찼습니다.");
			return false;
		} else {
			var date = new Date();
			var chatMsg = '${id}님이 입장하였습니다';
			var chat = "chat,${id},${community.room_no},"+chatMsg+","+date;
			sock.send(chat);
			
			location.href='joinRoom.do?room_no=${community.room_no}&room_name=${room_name}';
		};
	};
	
	
	function communityDelete() {
		location.href='communityDelete.do?community_no=${community.community_no }';
	}
	
	function communityLeave() {
		sendLeaveChat();
		location.href='communityLeave.do?community_no=${community.community_no }';
	}
	
	function sendLeaveChat() {
		
		var date = new Date();
		var chatMsg = '${id}님이 퇴장하였습니다';
		var chat = "chat,${id},${community.room_no},"+chatMsg+","+date;
		sock.send(chat);
	}

</script>

</head>
<body>
<main>
	<div class="main-container">
		<div class="content">
			<div class="detail-container">
				<span id="main-text">${community.community_subject }</span><span class="detail-member-text">${currentMember} / ${community.max_member }</span>
				<hr id="text-line">
			
				<input type="hidden" name="id" id="userId" value="${id}">
				<input type="hidden" name="room_name" id="room_name" value="${room_name }">
				<input type="hidden" name="room_no" id="room_no" value="${community.room_no }">
				<div class="detail-gender-age">
				
					<div>
						<div>
							카테고리
						</div>
						<div class="div2 detail-cate">
							${community.community_category }
						</div>
					</div>
				
				
					
					<div class="detail-gen-div">
						<div>
							성별
						</div>
						<div class="div2 detail-gender">
							${community.community_gender }
						</div>
					</div>
					<div class="detail-age-div">
						<div>
							연령 제한
						</div>
						<div class="div2 detail-age">
							${community.min_age }세 부터 ${community.max_age }세 까지
						</div>
					</div>
				</div>			
				
				<div>
					<div>
						활동 내용
					</div>
					<textarea class="detail-Ta" style="white-space:pre;" readonly="readonly">${community.community_content }</textarea>
				</div>
				
				
				<div >
					<div>
						장소
					</div>
					<div class="div2">
						${community.community_location }
					</div>
				</div>
								
				<c:if test="${community.participation == 0 }">
				<div>
					<button id="communityJoin">가입</button>
				</div>
				</c:if>
				
				<c:if test="${community.participation > 0 }">
				<div>
					<button  onclick="location.href='chat.do?room_no=${community.room_no}&room_name=${community.community_subject }'" id="goChatBtn">대화방으로</button>
				</div>
				<div class="btn-wrap">
					<c:if test="${community.host_id == id }">
						<div>
							<button id="communityDelete">모임 삭제</button>
						</div>
					</c:if>
					<c:if test="${community.host_id != id }">
						<div>
							<button id="communityLeave">모임 나가기</button>
						</div>
					</c:if>
				</div>
				</c:if>
				
			</div>	
				
		</div>
	</div>
</main>		
</body>
</html>