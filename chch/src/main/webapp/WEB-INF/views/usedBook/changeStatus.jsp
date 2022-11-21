<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<c:if test="${result > 0 }">
	<script type="text/javascript">
		alert("게시글의 상태가 변경되었습니다.")
		location.href="usedDetail.do?used_no=${used_no}";
	</script>
</c:if>
<c:if test="${!(result == 0) }">
	<script type="text/javascript">
		alert("입력 실패")
		history.back();
	</script>
</c:if>
<c:if test="${!(result < 0) }">
	<script type="text/javascript">
		alert("로그인 해주세요")
		history.back();
	</script>
</c:if>

</body>
</html>