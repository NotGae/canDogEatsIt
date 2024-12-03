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
String entityType = request.getParameter("entityType");
int parentId = Integer.parseInt(request.getParameter("parentId"));
int updatedVoteCnt = -1;

if(entityType.equals("food_container")) {
	fooddb.setVote(parentId, voteType);
	updatedVoteCnt = fooddb.getVote(parentId, voteType);
} else if(entityType.equals("comment")) {
	commentdb.setVote(parentId, voteType);
	updatedVoteCnt = commentdb.getVote(parentId, voteType);
} else {
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update vote data.\"}");
}

response.getWriter().write("{\"status\":\"success\",\"parentId\":\"" + parentId + "\", \"voteType\":\"" + voteType + "\", \"updatedVoteCnt\":\"" + updatedVoteCnt + "\", \"entityType\":\"" + entityType + "\"}");

%>