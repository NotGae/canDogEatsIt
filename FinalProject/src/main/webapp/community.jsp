<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="javabeans.PostEntity"%>
<%@ page import="java.util.ArrayList"%>

<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="request" />
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>Insert title here</title>
</head>
<%
int postPageOffset = 0;

ArrayList<PostEntity> posts = postdb.getPostArray(postPageOffset);
%>

<body>
	<ul class="post_container">
		<%
		for (PostEntity post : posts) {
		%>
		<li data-id="<%=post.getPostId()%>">작성자: <%=post.getUserName()%>,
			제목: <%=post.getPostName()%>, 조회수: <%=post.getViews()%>, 작성일시: <%=post.getCreateDate()%>,
			좋아요: <%=post.getLikeCnt()%>, 싫어요: <%=post.getDisLikeCnt()%></li>
		<%
		}
		%>
	</ul>
	<ul class="comment_page_btn">
		<li class="back_comment_page_btn comment_page_btn"><<</li>
		<li class="front_comment_page_btn comment_page_btn">>></li>
	</ul>
</body>
</html>