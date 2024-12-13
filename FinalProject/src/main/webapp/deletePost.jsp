<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javabeans.CommentEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />
<jsp:useBean id="postdb" class="javabeans.PostDatabase"
	scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String postId = request.getParameter("postId");
String userPw = request.getParameter("userPw");

boolean success = postdb.deletePost(postId, userPw);
if (success) {
	// 성공 응답
	response.getWriter().write("{\"status\":\"success\", \"message\":\"Post deleted successfully.\"}");
} else {
	// 실패 응답
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to delete data.\"}");
}
%>