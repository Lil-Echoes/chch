<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:if test="${result > 0}">
		<script type="text/javascript">
			alert("등록 성공");
			location.href="authorEach.do?author_no="+${author_work.author_no};
		</script>
	</c:if>
	<c:if test="${result == 0}">
		<script type="text/javascript">
			alert("등록 실패");
			history.go(-1);
		</script>
	</c:if>
</body>
</html>