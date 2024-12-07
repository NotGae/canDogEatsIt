<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="javabeans.CommentEntity, javabeans.PostEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />
<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");

String postId = request.getParameter("postId");
int commentPage = 0;

ArrayList<CommentEntity> commentList = commentdb.getCommentArray(postId, commentPage);
PostEntity post = postdb.getPost(postId);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
label {
	display: block;
}
</style>
<link rel="stylesheet" href="./resource/main.css">
</head>
<body>

	<h1><%=post.getPostName()%></h1>
	<section class="post_content_container">
		<p>작성자: <%=post.getUserName()%> 조회수: <%=post.getViews()%></p>
		<p><%=post.getPostContent()%></p>

		<button class="vote_btn like">
			추천(<%=post.getLikeCnt()%>)
		</button>
		<button class="vote_btn dislike">
			비추천(<%=post.getDisLikeCnt()%>)
		</button>
	</section>


	<form method="POST" action="sumbitComment.jsp" class="comment_form">
		<label>닉네임: <input type="text" class="user_name" /></label> <label>비밀번호:
			<input type="password" class="user_pw" />
		</label> <label>댓글: <textarea name="comment" rows="4" cols="50"
				class="comment" placeholder="Write your comment here..."></textarea></label>
		<button type="submit">등록</button>
	</form>

	<ul class="comment_container">
		<%
		for (int i = 0; i < commentList.size(); i++) {
		%>
		<li class="comment" data-id="<%=commentList.get(i).getCommentId()%>">
			<%=commentList.get(i).getUserName()%>: <%=commentList.get(i).getCommentContent()%>
			<%=commentList.get(i).getCreateDate()%>
			<button class="vote_btn like">
				추천(<%=commentList.get(i).getLikeCnt()%>)
			</button>
			<button class="vote_btn dislike">
				비추천(<%=commentList.get(i).getDisLikeCnt()%>)
			</button>
		</li>
		<%
		}
		%>
	</ul>
	<ul class="comment_page_btn" data-parentId="<%=post.getPostId()%>">
		<li class="back_comment_page_btn comment_page_btn"><<</li>
		<li class="front_comment_page_btn comment_page_btn">>></li>
	</ul>
</body>
</html>