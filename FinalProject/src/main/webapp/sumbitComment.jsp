<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.text.SimpleDateFormat, java.util.Date"%>

<%
Connection conn = null;
try {
	// DBCP
	//Context ctx = new InitialContext();
	// student스키마에 접근.
	// DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/student");
	//conn = ds.getConnection();

	// JDBC
	String driverName = "com.mysql.cj.jdbc.Driver";
	Class.forName(driverName);
	String dbURL = "jdbc:mysql://localhost:3306/webdb"; // student스키마에 접근
	conn = DriverManager.getConnection(dbURL, "root", "root");
} catch (Exception e) {
	e.printStackTrace();
}
%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String currentTime = formatter.format(new Date());

String postId = request.getParameter("postId");
String userName = request.getParameter("userName");
String userPw = request.getParameter("userPw");
String comment = request.getParameter("comment");

PreparedStatement stmt = null;
try {
	String sql = "INSERT INTO comments(post_id, user_name, user_pw, comment_content, create_date) VALUES (?, ?, ?, ?, ?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, postId);
	stmt.setString(2, userName);
	stmt.setString(3, userPw);
	stmt.setString(4, comment);
	stmt.setString(5, currentTime);

	int rowsAffected = stmt.executeUpdate();
	if (rowsAffected > 0) {
	    // 성공 응답
	    response.getWriter().write("{\"status\":\"success\", \"userName\":\"" + userName + "\", \"comment\":\"" + comment + "\",  \"currentTime\":\"" + currentTime + "\"}");
	} else {
	    // 실패 응답
	    response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to insert data.\"}");
	}
} catch (Exception e) {
	e.printStackTrace();
	out.print("An error occurred: " + e.getMessage());
}

conn.close();
stmt.close();
%>