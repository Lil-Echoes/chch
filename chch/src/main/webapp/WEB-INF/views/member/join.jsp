<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:if test="${result > 0}">
		<script type="text/javascript">
			alert("환영합니다");
			location.href="loginForm.do";
		</script>
	</c:if>
	<c:if test="${result == 0}">
		<script type="text/javascript">
			alert("회원가입 실패");
			history.go(-1);
		</script>
	</c:if>
	<c:if test="${result == -1}">
		<script type="text/javascript">
			alert("아이디가 중복되었습니다");
			history.go(-1);
		</script>
	</c:if>
</body>
</html>