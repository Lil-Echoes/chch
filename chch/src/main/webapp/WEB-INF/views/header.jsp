<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="UTF-8">
<title>header</title>
<style type="text/css">@import url("/chch/resources/css/header.css");</style>

<c:set var="path" value="${pageContext.request.contextPath }"></c:set>
<c:set var="ipAdd" value="//172.30.1.10:8080"></c:set>
<c:set var="ip" value="http:${ipAdd}/chch"></c:set>
<link rel="stylesheet" type="text/css"href="${path }/resources/bootstrap/css/bootstrap.min.css">
<script type="text/javascript" src="${path}/resources/bootstrap/js/jquery.js"></script>
<script type="text/javascript" src="${path}/resources/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${path}/resources/bootstrap/js/sockjs.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<style type="text/css">@import url("/chch/resources/css/font.css");</style>

<script type="text/javascript">
	function openCloseMenu(){
	    let status = $('.hideBookMenu').css('display');
	    if (status =='block') {
	        $('.hideBookMenu').hide();
	    } else {
	        $('.hideBookMenu').show();
	    }
	}

	var socket  = null;
	var id = '${id}';
	
	$(document).ready(function(){
		
	    // 웹소켓 연결
	    sock = new SockJS("<c:url value='/echo.do'/>");
	    socket = sock;
	    
	    sock.onopen = function() {
		    console.log('open ws')
	    };
		
	    // 데이터를 전달 받았을때 
	    sock.onmessage = onMessage; // toast 생성
	    
	    loadUnreadFn();
	    
	});
	    
	function onMessage(evt){
		
		var msg = evt.data;
	
		appendMessage(msg);
	}	
		
	function appendMessage(msg) {
		var split1 = msg.split(',');
		var cmd = split1[0];
		var room_no = split1[2];
		
		if (msg != null && msg.trim() != '' && cmd == 'chat') {
			
			console.log(msg);
			
			var check1;
			var check2;
			if (document.location.href.includes('?')) {
				check1 = document.location.href.split("?");
				check11 = check1[0].substr(-7);		// 해당 페이지의 주소 확인
				if (check1[1].includes('&')) {
					check2 = check1[1].split("&");
					check22 = check2[0];// 해당 페이지의 파라미터 값을 가져옴
					console.log(check2);
				} else {
					check22=0;
				}
			} else {
				check11=0;
				check22=0;;
			}
			
			var check3 = document.location.href.split("/");
			console.log(check3[4]);
			
			if (check11=='chat.do' && check22=='room_no='+room_no) {	//'chat.do'에 해당하는 주소이고 room_no가 동일할 때 메세지를 append
				
				var sender = split1[1];
				var room_no = split1[2];
				var message = split1[3]
				var send_time = split1[4];
				var lastSender = split1[7];
				
				var decodeMsg = decodeURIComponent(message);
				
				checkRoom(id, room_no);
				
				
				var s_time = timeChange(send_time);
				
				if (split1[0] == "chat" && room_no == "${room_no}") {
					
					if (sender == "${id}") {
						$('#chatMessage').append(
								"<div class='to'>"
									+ "<div class='sendTime'>" + s_time + "</div>"
									+ "<div class='content2'>" + decodeMsg + "</div>"
								+ "</div>");
						var objDiv = document.getElementById("chatMessage");
						objDiv.scrollTop = objDiv.scrollHeight;
						
					} else {
						
						var scrT = $("#chatMessage").scrollTop();
						
						if ($("#chatMessage")[0].scrollHeight - scrT >=605 ) {
							var a = 0;
							$('#alert').css('display','block');
							$('#alert').children().remove();
							$('#alert').append("<strong>"+sender+" : "+decodeMsg+"</strong>");
						} else {
							var a = 1;
						}
						
						if (lastSender != sender) {
							$('#chatMessage').append(
									"<div class='from'>"
										+ "<div>"
											+ "<div class='sender'>" + sender + "</div>"
											+ "<div class='flex-row'>"
												+ "<div class='content1'>" + decodeMsg  + "</div>"
												+ "<div class='sendTime'>" + s_time + "</div>"
											+ "</div>"
										+ "</div>"
									+ "</div>");
							
						} else if (lastSender == sender) {
							$('#chatMessage').append(
									"<div class='from'>"
									+ "<div>"
										+ "<div class='flex-row'>"
											+ "<div class='content1'>" + decodeMsg + "</div>"
											+ "<div class='sendTime'>" + s_time + "</div>"
										+ "</div>"
									+ "</div>"
								+ "</div>");
						}
						
						if (a==1) {
							$("#chatMessage").scrollTop($("#chatMessage")[0].scrollHeight);
						}
						
						
					}
				}
			} else if (check11 == 'chat.do' && check22 != 'room_no='+room_no) {
				
				var sender = split1[1];
				var room_no = split1[2];
				var message = split1[3]
				// var send_time = split1[4];
			    var loadUnread = split1[5];
				
			    var decodeMsg = decodeURIComponent(message);
			    
				var view =sender+"님의 메세지 : "+decodeMsg;
			    				
			    setTimeout(function() {
			    	$("#noticePopUp").children().remove();
				    $("#noticePopUp").val(view);
				    loadUnreadFn();
			    }, 300);
			    
			} else if (check3[4] == 'noticeMain.do') {
				
				var sender = split1[1];
				var room_no = split1[2];
				var message = split1[3]
				// var send_time = split1[4];
			    var loadUnread = split1[5];
				
			    var decodeMsg = decodeURIComponent(message);
			    
				var view =sender+"님의 메세지 : "+decodeMsg;
			    				
				setTimeout(function() {
			    	$("#noticePopUp").children().remove();
				    $("#noticePopUp").val(view);
				    $("#unreadChat").children().remove();
					$("#unreadChat").val(loadUnreadChat);
				    loadUnreadFn();
			    }, 300);
				
			} else {						// 해당 채팅방 안에 있지 않을 때는 notice에 알림
				
				var sender = split1[1];
				var room_no = split1[2];
				var message = split1[3]
				// var send_time = split1[4];
			    var loadUnread = split1[5];

			    var roomUnread = split1[6];
				
			    var decodeMsg = decodeURIComponent(message);
			    
				var view =sender+"님의 메세지 : "+decodeMsg;
			    				
				if (check3[4] == 'chatMemberList.do') {
					var content = document.querySelector('#room'+room_no);
					var parent = content.parentNode;
					
					setTimeout(function() {
						document.querySelector('#room_no'+room_no).innerText=roomUnread;
						document.querySelector('#msgRoom_no'+room_no).innerText=decodeMsg;
						parent.insertBefore(content, parent.firstChild);
					}, 300);
					
				}
				
				setTimeout(function() {
					$("#noticePopUp").children().remove();
				    $("#noticePopUp").val(view);
				    loadUnreadFn();
			    }, 300);
				
			}
			
		} else if (msg != null && msg.trim() != '' && split1[0] == 'notice'){
			
		    var view = split1[2];
	    	$("#noticePopUp").children().remove();
		    $("#noticePopUp").val(view);
	    	
	    } else if (msg != null && msg.trim() != '' && split1[0] == 'inquiryReply'){
			
		    var view = "문의 "+split1[2]+"에 대한 답변이 완료되었습니다.";
		    
		    setTimeout(function() {
		    	$("#noticePopUp").children().remove();
			    $("#noticePopUp").val(view);
			    loadUnreadFn();
		    }, 300);
	    	
	    } else if (msg != null && msg.trim() != '' && split1[0] == 'joinRoom'){
			
		    var view = split1[1]+"님이 "+split1[3]+" 대화방에 참여하였습니다.";
		    
		    setTimeout(function() {
				$("#noticePopUp").children().remove();
			    $("#noticePopUp").val(view);
			    loadUnreadFn();
		    }, 300);
		    
	    	
	    } else if (msg != null && msg.trim() != '' && split1[0] == 'status') {
	    	
	    	var view="";
	    	
			for (var i = 1; i < split1.length; i++) {
				view = view+"<div>"+split1[i]+"</div>";
			}
		    
			view = "<div>현재 접속자</div>"+view;
			
		    $("#PopUp").children().remove();
		    $("#PopUp").append(view);
	    }
		
	};
	
	function timeChange(time) {
		
		var hour1 = time.substr(16, 2);
		var minutes = time.substr(19, 2);
		var ampm;
		if (hour1 <12) {
			ampm = '오전';
			var changedTime = ampm+" "+hour1+" "+minutes;
		} else {
			ampm = '오후'
			hour2 = String(hour1 -12);
			var changedTime = ampm+" "+hour2+" "+minutes;
		}
		
		
		return changedTime;
	}
	
	function loadUnreadFn() {
		
		var id = '${id}';
		
		$.post('loadUnread.do', 'id='+id, function(data) {
			if (data == 0) {
				$("#unreadNotice").val("");
			} else {
				$("#unreadNotice").val(data);
			}
		});
		
	}
	
	function checkRoom(id, room_no) {
		$(function() {
			$.ajax({
				url : "checkRoom.do?id="+id+"&room_no="+room_no,
				async : true,
				type : "POST",
				dataType : "html",
				cache : false
			});
		});
	}
	
</script>


</head>
<body>
<header>
	<nav>
		
		<div class="header-container">
			<div class="header-content">
				<!-- 로고, 검색, 알림 wrap -->
				<div class="top-container">
						<!-- 로고, 검색 -->
						<ul class="img-search-wrap">
							<!-- 로고 이미지 -->
							<li>
								<a href="${path}/main.do">
									<img id="logoImg" alt="이미지가 없습니다" src="/chch/resources/images/chackcheckCheckLogo2-1.png">
								</a>
							</li>
							<!-- 검색 -->
							<li>
							<form action="searchBook.do">
							<p>
							<input id="searchInput" name="keyword" type="text" placeholder="검색어를 입력하세요">
							<button id="searchimg"><img id="search" src="/chch/resources/images/search.png"></button>
							</p>
							</form>
							</li>
							
							<!-- 알림 종 -->
							
								<c:if test="${not empty id }">
								<li>
									<ul>
									
									<li>
										<input type="text" name="unreadNotice" id="unreadNotice" style="resize: none; border: none; width: 25px; background-color: #ffffff; color: #808080; " readonly="readonly">
									</li>
																
									<li>
											<a href="noticeMain.do">
												<img id="bell" src="/chch/resources/images/bell.png">
											</a>
									</li>
									</ul>
								</li>
								</c:if>
							<li>
								<textarea name="noticePopUp" id="noticePopUp" readonly="readonly"></textarea>
							</li>
						</ul>
					
				</div>
			
			

			
				<div class="bottom-container">
				
					<!-- 신작도서 and bookMenu wrap -->
					<div class="cate">
					
						<div class="cate-sub">
						
						<button class="bookMenuBtn" onclick="openCloseMenu()"><img id="hamburger" alt="" src="/chch/resources/images/hamburger.png"> </button>
						
						<a class="cate-c newBook" href="newList.do?book_kind=all&order=recent">신작도서▼</a>
						<a class="cate-c usedBook" href="usedList.do">중고도서</a>
						<a class="cate-c" href="usedAddForm.do">판매하기</a>
						<a class="cate-c" href="writing.do">나도 작가</a>
						<a class="cate-c" href="communityAllList.do">모임</a>
						<a class="cate-c" href="mypageMain.do">마이페이지</a>
						<a class="cate-c" href="inquiryMain.do">고객센터</a>
						<!-- <a class="cate-c" href="communityMain.do">모임</a>
						<a class="cate-c" href="chatMemberList.do">채팅방</a> -->
						<c:if test="${id == 'a' }">
							<a class="cate-c" href="adminMain.do">관리자</a>
						</c:if>
						
						<div class="cate-c-sub">
							<c:if test="${empty id }">
								<a href="loginForm.do" class="top-t" >로그인</a>
								<a class="top-t">|</a>
								<a href="joinForm.do" class="top-t" >회원가입</a>
								
							</c:if>
							<c:if test="${not empty id }">
								<a href="" class="top-t" >장바구니</a>
								<a class="top-t">|</a>
								<a href="logout.do" class="top-t" >로그아웃</a>
								
							</c:if>
						</div>
						
						
						</div>
					</div>
								
				</div>
		
						<div class="hideBookMenu">
							<!-- 신작도서 bookMenu -->
							<div class="bookMenu">
									<!-- IT -->
											<ul class="submenu">
												<li class="li-main-c"><a href="newList.do?book_kind=IT&order=recent" class="nav-class1">IT</a></li>
												
												<li class="li-c"><a href="newList.do?book_kind=IT-프로그래밍언어&order=recent" class="a">프로그래밍언어</a></li>
												<li class="li-c"><a href="newList.do?book_kind=IT-컴퓨터공학&order=recent" class="a">컴퓨터공학</a></li>
												<li class="li-c"><a href="newList.do?book_kind=IT-해킹/보안&order=recent" class="a">해킹/보안</a></li>
												<li class="li-c"><a href="newList.do?book_kind=IT-그래픽/디자인&order=recent" class="a">그래픽/디자인</a></li>
												<li class="li-c"><a href="newList.do?book_kind=IT-OS/데이터베이스&order=recent" class="a">OS/데이터베이스</a></li>
											</ul>
									
									<!-- 문학 -->
											<ul class="submenu">
												<li class="li-main-c"><a href="newList.do?book_kind=문학&order=recent" class="nav-class1">문학</a></li>
												
												<li class="li-c"><a href="newList.do?book_kind=문학-한국소설&order=recent" class="a">한국소설</a></li>
												<li class="li-c"><a href="newList.do?book_kind=문학-해외소설&order=recent" class="a">해외소설</a></li>
												<li class="li-c"><a href="newList.do?book_kind=문학-시&order=recent" class="a">시</a></li>
												<li class="li-c"><a href="newList.do?book_kind=문학-에세이&order=recent" class="a">에세이</a></li>
												<li class="li-c"><a href="newList.do?book_kind=문학-고전문학&order=recent" class="a">고전문학</a></li>
											</ul>

									
									<!-- 역사 -->
											<ul class="submenu">
												<li class="li-main-c"><a href="newList.do?book_kind=역사&order=recent" class="nav-class1">역사</a></li>
												
												<li class="li-c"><a href="newList.do?book_kind=역사-한국사/한국문화&order=recent" class="a">한국사/한국문화</a></li>
												<li class="li-c"><a href="newList.do?book_kind=역사-동양사/동양문화&order=recent" class="a">동양사/동양문화</a></li>
												<li class="li-c"><a href="newList.do?book_kind=역사-서양사/서양문화&order=recent" class="a">서양사/서양문화</a></li>
												<li class="li-c"><a href="newList.do?book_kind=역사-세계사/세계문화&order=recent" class="a">세계사/세계문화</a></li>
												<li class="li-c"><a href="newList.do?book_kind=역사-역사학이론/비평&order=recent" class="a">역사학이론/비평</a></li>
											</ul>

									
									<!-- 과학 -->
											<ul class="submenu">
												<li class="li-main-c"><a href="newList.do?book_kind=과학&order=recent" class="nav-class1">과학</a></li>
												
												<li class="li-c"><a href="newList.do?book_kind=과학-공학&order=recent" class="a">공학</a></li>
												<li class="li-c"><a href="newList.do?book_kind=과학-물리학&order=recent" class="a">물리학</a></li>
												<li class="li-c"><a href="newList.do?book_kind=과학-생명과학&order=recent" class="a">생명과학</a></li>
												<li class="li-c"><a href="newList.do?book_kind=과학-천문학&order=recent" class="a">천문학</a></li>
												<li class="li-c"><a href="newList.do?book_kind=과학-화학&order=recent" class="a">화학</a></li>
											</ul>
									
									<!-- 경제 -->
											<ul class="submenu">
												<li class="li-main-c"><a href="newList.do?book_kind=경제&order=recent" class="nav-class1">경제</a></li>
												
												<li class="li-c"><a href="newList.do?book_kind=경제-경제&order=recent" class="a">경제</a></li>
												<li class="li-c"><a href="newList.do?book_kind=경제-경영&order=recent" class="a">경영</a></li>
												<li class="li-c"><a href="newList.do?book_kind=경제-투자/재테크&order=recent" class="a">투자/재테크</a></li>
												<li class="li-c"><a href="newList.do?book_kind=경제-마케팅/세일즈&order=recent" class="a">마케팅/세일즈</a></li>
												<li class="li-c"><a href="newList.do?book_kind=경제-CEO/비즈니스&order=recent" class="a">CEO/비즈니스</a></li>
											</ul>
									
									
							</div>
							<!-- 신작도서 bookMenu끝	 -->			
						</div>
		
			</div>
		</div>
	
	</nav>
</header>
</body>
</html>