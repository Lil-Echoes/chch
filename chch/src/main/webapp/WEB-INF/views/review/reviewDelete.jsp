<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
			alert("리뷰가 삭제되었습니다.");
			history.back();
		</script>
	</c:if>
	<c:if test="${result == 0}">
		<script type="text/javascript">
			alert("리뷰 삭제 실패");
			history.back();
		</script>
	</c:if>
</body>
</html>