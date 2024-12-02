<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>

<%
Connection conn = null;
try {
	// JDBC
	String driverName = "com.mysql.cj.jdbc.Driver";
	Class.forName(driverName);
	String dbURL = "jdbc:mysql://localhost:3306/webDB"; // webDB스키마에 접근
	conn = DriverManager.getConnection(dbURL, "root", "root");
} catch (Exception e) {
	e.printStackTrace();
}
%>
<%
request.setCharacterEncoding("UTF-8");

String searchValue = request.getParameter("searchValue");
int commentPage = Integer.parseInt(request.getParameter("commentPage"));
// student스키마 안에 있는 student_info 테이블에 접근.
String sql = "SELECT * FROM foods WHERE food_name = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
// 파라미터 바인딩
stmt.setString(1, searchValue);

// SQL 실행
ResultSet result = stmt.executeQuery();
String foodId = "" ,foodName = "", likeCnt = "", disLikeCnt = "";
if (result.next()) {
	foodId = result.getString(1);
	foodName = result.getString(2);
	likeCnt = result.getString(3);
	disLikeCnt = result.getString(4);
} else {
	foodName = "결과가 없습니다.";
}

//student스키마 안에 있는 student_info 테이블에 접근.
sql = "SELECT user_name, comment_content, create_date, like_cnt, dislike_cnt FROM comments WHERE post_id = ? LIMIT ?, 1";
stmt = conn.prepareStatement(sql);
//파라미터 바인딩
stmt.setString(1, foodId);
stmt.setInt(2, commentPage);
//SQL 실행
result = stmt.executeQuery();
// List<comment>
String userName = "", content = "", createDate = "", comLikeCnt = "", comDisLikeCnt = "";
if (result.next()) {
	// comment 빈즈에 저장.
	userName = result.getString(1);
	content = result.getString(2);
	createDate = result.getString(3);
	comLikeCnt = result.getString(4);
	comDisLikeCnt = result.getString(5);
}
%>
<%
conn.close();
result.close();
stmt.close();
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
	<section class="food_container" data-id="<%=foodId%>">
		<h1><%=foodName%></h1>
		<button>
			추천(<%=likeCnt%>)
		</button>
		<button>
			비추천(<%=disLikeCnt%>)
		</button>
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
		<li class="comment"><%=userName%>: <%=content%> <%=createDate%>
			<button>
				추천(<%=comLikeCnt%>)
			</button>
			<button>
				비추천(<%=comDisLikeCnt%>)
			</button></li>
	</ul>
	
	<ul>
	<li>1</li>
	</ul>
</body>
<script>
document.querySelector(".comment_form").addEventListener("submit", function(event) {
    event.preventDefault();  // 기본 폼 제출을 막음

    const userName = document.querySelector(".user_name").value;
    const userPw = document.querySelector(".user_pw").value;
    const comment = document.querySelector(".comment").value;
    const postId = document.querySelector(".food_container").dataset.id;

    saveComment(postId, userName, userPw, comment);
});  // 한 번만 실행되도록 설정
 
let request = null;
//댓글등록 버튼 누르면. post로 ajax요청보냄.
function createRequest() {
  try {
    request = new XMLHttpRequest();
  } catch (failed) {
    request = null;
  }
  if (request == null) alert('Error creating request object!');
}
function saveComment(postId, userName, userPw, comment) {
  createRequest();
  // ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
  let url = "sumbitComment.jsp?";
  let qry = "userName=" + encodeURIComponent(userName) + "&userPw=" + encodeURIComponent(userPw) + "&comment=" + encodeURIComponent(comment) + "&postId=" + encodeURIComponent(postId);
  console.log(qry);
  request.open("POST", url, true);
  request.onreadystatechange = updatePage;
  request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  request.send(qry)
}
function updatePage() {
  // 요청에 성공 시, 진행.
  if (request.readyState == 4 && request.status == 200) {
	const response = JSON.parse(request.responseText);
	if (response.status === "success") {
      const userName = response.userName;  // 서버에서 보낸 사용자 이름
      const comment = response.comment;    // 서버에서 보낸 댓글 내용
      const currentTime = response.currentTime;    // 서버에서 보낸 댓글 내용

      let commentContainer = document.querySelector(".comment_container");
      
      let htmlString = '<li class="comment">' + userName + ":" + comment + " " + currentTime + "<button>추천(0)</button><button>비추천(0)</button></li>";
      // 새로운 댓글을 화면에 추가
      commentContainer.insertAdjacentHTML("beforeend", htmlString);
    } else {
      console.error(response.message); // 오류 메시지 출력
    }
  }
}
</script>
</html>