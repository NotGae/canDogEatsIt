package javabeans;

import java.sql.*;
import java.util.ArrayList;
import javax.sql.*;
import javax.naming.*;

public class CommentDatabase {
	// DBCP
	private Context ctx = null;
	// student스키마에 접근.
	private DataSource ds = null;

	private Connection conn = null;
	private PreparedStatement stmt = null;
	private ResultSet result = null;

	public CommentDatabase() {

		try {
			ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:comp/env/jdbc/webdb");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	void connect() {
		try {
			conn = ds.getConnection();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	void disconnect() {
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public ArrayList<CommentEntity> getCommentArray(int postId, int offset) {
		connect();
		ArrayList<CommentEntity> list = new ArrayList<>();

		try {
			// student스키마 안에 있는 student_info 테이블에 접근.
			String sql = "SELECT comment_id, post_id, user_name, comment_content, create_date, like_cnt, dislike_cnt FROM comments WHERE post_id = ? ORDER BY create_date DESC LIMIT ?, 5";
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setInt(1, postId);
			stmt.setInt(2, offset);
			// SQL 실행
			result = stmt.executeQuery();
			// List<comment>
			while (result.next()) {
				// int commentId, int postId, String userName, String commentContent, String
				// createDate, int likeCnt, int disLikeCnt
				CommentEntity comment = new CommentEntity(result.getInt(1), result.getInt(2), result.getString(3),
						result.getString(4), result.getString(5), result.getInt(6), result.getInt(7));
				list.add(comment);
			}
			disconnect();
			stmt.close();
			result.close();

			return list;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

	public int addComment(int postId, String userName, String userPw, String comment, String currnetTime) {
		connect();
		boolean success = false;
	    ResultSet generatedKeys = null;
	    
	    
		try {
			String sql = "INSERT INTO comments(post_id, user_name, user_pw, comment_content, create_date) VALUES (?, ?, ?, ?, ?)";
			stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			stmt.setInt(1, postId);
			stmt.setString(2, userName);
			stmt.setString(3, userPw);
			stmt.setString(4, comment);
			stmt.setString(5, currnetTime);

			int rowsAffected = stmt.executeUpdate();
			int commentId = -1;
			if (rowsAffected > 0) {
				// 성공 응답
				success = true;
				// 생성된 Primary Key 가져오기
	            generatedKeys = stmt.getGeneratedKeys();
	            System.out.println(generatedKeys);
	            if (generatedKeys.next()) {
	                int newCommentId = generatedKeys.getInt(1);
	                System.out.println(newCommentId);
	                // 해당 행 정보 다시 조회
	                String query = "SELECT comment_id FROM comments WHERE comment_id = ?";
	                PreparedStatement selectStmt = conn.prepareStatement(query);
	                selectStmt.setInt(1, newCommentId);
	                ResultSet rs = selectStmt.executeQuery();
	                if (rs.next()) {
	                    // 가져온 데이터 처리
	                	commentId = rs.getInt(1);
		                disconnect();
		                rs.close();
		                selectStmt.close();
		                stmt.close();
	                }
	            }
	            return commentId;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			disconnect();
			stmt.close();
			result.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	
	public boolean setVote(int parentId, String voteType) {
		connect();
		String sql = null;
		if(voteType.equals("like")) {
			sql = "UPDATE comments SET like_cnt = like_cnt + 1 WHERE comment_id = ?";
		} else if(voteType.equals("dislike")) {
			sql = "UPDATE comments SET dislike_cnt = dislike_cnt + 1 WHERE comment_id = ?";
		} else {
			return false;
		}
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setInt(1, parentId);

			// SQL 실행
			int rowsAffected = stmt.executeUpdate();

			disconnect();
			stmt.close();
			if(rowsAffected != 0) {
				return true;
			} else {
				return false;
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public int getVote(int commentId, String voteType) {
		connect();
		String sql = null;
		if(voteType.equals("like")) {
			sql = "SELECT like_cnt FROM comments WHERE comment_id = ?";
		} else if(voteType.equals("dislike")) {
			sql = "SELECT dislike_cnt FROM comments WHERE comment_id = ?";
		} else {
			return -1;
		}
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setInt(1, commentId);

			// SQL 실행
			result = stmt.executeQuery();
			if(result.next()) {
				int cnt = result.getInt(1);
				disconnect();
				result.close();
				stmt.close();
				return cnt;
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
}
