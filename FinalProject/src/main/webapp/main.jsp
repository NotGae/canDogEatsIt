<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
    
<%
  Connection conn=null;
  try{
	 // DBCP
	 //Context ctx = new InitialContext();
	 // student스키마에 접근.
	 // DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/student");
	 //conn = ds.getConnection();
	 
	 // JDBC
	  String driverName = "com.mysql.cj.jdbc.Driver";
	  Class.forName(driverName);
	  String dbURL = "jdbc:mysql://localhost:3306/webDB"; // webDB스키마에 접근
	  conn = DriverManager.getConnection(dbURL, "root", "root");
  }catch(Exception e){ 
	 e.printStackTrace();
  }
%>
<%
request.setCharacterEncoding("UTF-8");
	
	// student스키마 안에 있는 student_info 테이블에 접근.
	String sql = "SELECT * FROM posts LIMIT 5";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// 파라미터 바인딩

	// List<"post객체"> post객체
	// SQL 실행
	ResultSet result = stmt.executeQuery();
	while(result.next()) {
		// post객체 리스트에 삽입.
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
<title>Can Dogs Eat It?</title>

</head>
<body>
	<jsp:include page="/include/nav.jsp"></jsp:include>

	<form class="search_form" method="GET" action="searchResult.jsp">
		<input type="text" name="searchValue" class="search_value" />
		<input type="text" name="commentPage" value=0 style="display: none;"/>
		<button tyep="submit" class="saerch_button">검색</button>
	</form>
</body>

<script>
	document.querySelector(".search_form")
			.addEventListener(
					"submit",
					function(event) {
						const inputField = document
								.querySelector(".search_value").value.trim();
						if (inputField === "") {
							// 입력값이 비어있으면 동작하지 않음
							event.preventDefault(); // 기본 폼 제출 동작 방지
						}
					});
</script>
</html>