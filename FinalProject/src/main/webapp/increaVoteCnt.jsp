<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javabeans.CommentEntity"%>
<%@ page import="javabeans.FoodEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />
	<jsp:useBean id="fooddb" class="javabeans.FoodDatabase"
	scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String voteType = request.getParameter("voteType");
String parentId = request.getParameter("parentId");
int updatedVoteCnt = -1;

if(fooddb.existsRows(parentId)) {
	fooddb.setVote(parentId, voteType);
	updatedVoteCnt = fooddb.getVote(parentId, voteType);
} else if(commentdb.existsRows(parentId)) {
	commentdb.setVote(parentId, voteType);
	updatedVoteCnt = commentdb.getVote(parentId, voteType);
} else {
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update vote data.\"}");
}

response.getWriter().write("{\"status\":\"success\",\"parentId\":\"" + parentId + "\", \"voteType\":\"" + voteType + "\", \"updatedVoteCnt\":\"" + updatedVoteCnt + "\"}");

%>