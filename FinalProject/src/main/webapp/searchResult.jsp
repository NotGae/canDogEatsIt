<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page
	import="java.sql.*, javax.sql.*, javax.naming.*, java.util.ArrayList"%>
<%@ page import="javabeans.FoodEntity, javabeans.CommentEntity"%>

<%
request.setCharacterEncoding("UTF-8");

String searchValue = request.getParameter("searchValue");
int commentPage = Integer.parseInt(request.getParameter("commentPage"));
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
	<jsp:include page="/include/nav.jsp"></jsp:include>
	<jsp:useBean id="fooddb" class="javabeans.FoodDatabase" scope="page" />
	<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
		scope="request" />
	<%
	FoodEntity food = fooddb.getFood(searchValue);
	ArrayList<CommentEntity> commentList = commentdb.getCommentArray(food.getFoodId(), commentPage);
	%>
	<section class="food_container" data-id="<%=food.getFoodId()%>">
		<h1><%=food.getFoodName()%></h1>
		<button class="vote_btn like">
			추천(<%=food.getLikeCnt()%>)
		</button>
		<button class="vote_btn dislike">
			비추천(<%=food.getDisLikeCnt()%>)
		</button>
		</li>
	</section>
	<br />

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
	<ul class="comment_page_btn">
		<li class="back_comment_page_btn comment_page_btn"><<</li>
		<li class="front_comment_page_btn comment_page_btn">>></li>
	</ul>
</body>
<script>
	document
			.querySelector(".comment_form")
			.addEventListener(
					"submit",
					function(event) {
						event.preventDefault(); // 기본 폼 제출을 막음

						const userName = document.querySelector(".user_name").value;
						const userPw = document.querySelector(".user_pw").value;
						const comment = document.querySelector(".comment").value;
						const parentId = document
								.querySelector(".food_container").dataset.id;
						
						document.querySelector(".user_name").value = "";
						document.querySelector(".user_pw").value = "";
						document.querySelector(".comment").value = "";
						
						if(userName == '' || userPw == '' || comment == '') {
							return;
						}
						saveComment(parentId, userName, userPw, comment);
					}); // 한 번만 실행되도록 설정

	document.querySelectorAll(".vote_btn").forEach((btn) => {
		btn.addEventListener("click", (e) => {
			const targetBtn = e.currentTarget;
			const parentId = targetBtn.parentNode.dataset.id;
			const parentType = targetBtn.parentNode.classList;
			let voteType = null;
	        if (targetBtn.classList.contains("like")) {
	        	voteType = "like";
	            // parentId에 해당하는 객체의 like 증가 처리
	        } else if (targetBtn.classList.contains("dislike")) {
	        	voteType = "dislike";
	            // parentId에 해당하는 객체의 dislike 증가 처리
	        }
	        increamentVoteCnt(voteType, parentId);
		})
	});
	document.querySelectorAll(".comment_page_btn").forEach((item) => {
		item.addEventListener("click", (e) => {
			const target = e.currentTarget;
			if (target.classList.contains("back_comment_page_btn")) {
				// 여기서도 뭐 ajax하면 될듯.
	        } else if (target.classList.contains("front_comment_page_btn")) {
	        }
		});
	});
	
	let request = null;
	//댓글등록 버튼 누르면. post로 ajax요청보냄.
	function createRequest() {
		try {
			request = new XMLHttpRequest();
		} catch (failed) {
			request = null;
		}
		if (request == null)
			alert('Error creating request object!');
	}
	function saveComment(parentId, userName, userPw, comment) {
		createRequest();
		// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
		let url = "sumbitComment.jsp?";
		let qry = "userName=" + encodeURIComponent(userName) + "&userPw="
				+ encodeURIComponent(userPw) + "&comment="
				+ encodeURIComponent(comment) + "&parentId="
				+ encodeURIComponent(parentId);
		request.open("POST", url, true);
		request.onreadystatechange = updateComment;
		request.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		request.send(qry)
	}
	function increamentVoteCnt(voteType, parentId) {
		createRequest();
		if(voteType === null) return;
		
		let url = "increaVoteCnt.jsp?";
		let qry = "voteType=" + encodeURIComponent(voteType) + "&parentId=" + encodeURIComponent(parentId);
		request.open("POST", url, true);
		request.onreadystatechange = updateVote;
		request.setRequestHeader("Content-type",
				"application/x-www-form-urlencoded");
		request.send(qry)
	}
	function updateComment() {
		// 요청에 성공 시, 진행.
		if (request.readyState == 4 && request.status == 200) {
			const response = JSON.parse(request.responseText);
			if (response.status === "success") {
				const parentId = response.parentId;
				const userName = response.userName; // 서버에서 보낸 사용자 이름
				const comment = response.comment; // 서버에서 보낸 댓글 내용
				const currentTime = response.currentTime; // 서버에서 보낸 댓글 내용

				let commentContainer = document
						.querySelector(".comment_container");

				let htmlString = '<li class="comment" data_id="'  + parentId + '">'
						+ userName
						+ ": "
						+ comment
						+ " "
						+ currentTime
						+ "<button class='vote_btn like'>추천(0)</button><button class='vote_btn dislike'>비추천(0)</button></li>";
				// 새로운 댓글을 화면에 추가
				commentContainer.insertAdjacentHTML("afterbegin", htmlString);
			} else {
				console.error(response.message); // 오류 메시지 출력
			}
		}
	}
	function updateVote() {
		// 요청에 성공 시, 진행.
		if (request.readyState == 4 && request.status == 200) {
			const response = JSON.parse(request.responseText);
			if (response.status === "success") {
				const parentId = response.parentId;
				const voteType = response.voteType; 
				const updatedVoteCnt = response.updatedVoteCnt;
				
				const option = "[data-id=" + '"' + parentId + '"' + "]"
				let entity = document.querySelector(option);

				if (voteType === 'like') {
				    // 자식 태그 중 'like_cnt' 클래스를 가진 요소 찾기
				    const likeBtn = entity.querySelector(".like");
				    likeBtn.textContent = "추천(" + updatedVoteCnt + ")";
				} else if (voteType === 'dislike') {
				    // 자식 태그 중 'dislike_cnt' 클래스를 가진 요소 찾기
				    const dislikeBtn = entity.querySelector(".dislike");
				    dislikeBtn.textContent = "비추천(" + updatedVoteCnt + ")";
				} else {
				    console.error(response.message); // 오류 메시지 출력
				}
			} else {
				console.error(response.message); // 오류 메시지 출력
			}
		}
	}
	
</script>
</html>