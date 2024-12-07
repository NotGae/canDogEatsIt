<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="javabeans.PostEntity"%>
<%@ page import="java.util.ArrayList"%>

<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>Insert title here</title>
<style>
.post_container li {
	border: 1px solid black;
}
</style>
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
		<li><a href="postDetail.jsp?postId=<%=post.getPostId()%>">작성자:
				<%=post.getUserName()%>, 제목: <%=post.getPostName()%>, 조회수: <%=post.getViews()%>,
				좋아요: <%=post.getLikeCnt()%>, 싫어요: <%=post.getDisLikeCnt()%>, 작성일시: <%=post.getCreateDate()%>
		</a></li>
		<%
		}
		%>
	</ul>
	<ul class="comment_page_btn">
		<li class="back_comment_page_btn comment_page_btn"><<</li>
		<li class="front_comment_page_btn comment_page_btn">>></li>
	</ul>
</body>
<script>
document.querySelector(".post_container").addEventListener("click", (e) => {
    const targetPost = e.target;
    // 클릭한 요소가 .vote_btn인지 확인
    console.log(targetPost);
});
</script>
</html>