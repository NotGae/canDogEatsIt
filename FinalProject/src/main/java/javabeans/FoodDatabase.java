package javabeans;

import java.sql.*;
import java.util.ArrayList;
import javax.sql.*;
import javax.naming.*;

public class FoodDatabase {

	// DBCP
	private Context ctx = null;
	// student스키마에 접근.
	private DataSource ds = null;
	private Connection conn = null;
	private PreparedStatement stmt = null;
	private ResultSet result = null;

	public FoodDatabase() {

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

	public FoodEntity getFood(String FoodName) {
		connect();

		// student스키마 안에 있는 student_info 테이블에 접근.
		String sql = "SELECT * FROM foods WHERE food_name = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, FoodName);

			// SQL 실행
			result = stmt.executeQuery();
			String foodId = "";
			int likeCnt = -1, disLikeCnt = -1;
			String foodName = "";
			if (result.next()) {
				foodId = result.getString(1);
				foodName = result.getString(2);
				likeCnt = result.getInt(3);
				disLikeCnt = result.getInt(4);

				disconnect();
				stmt.close();
				result.close();
				return new FoodEntity(foodId, foodName, likeCnt, disLikeCnt);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public boolean setVote(String parentId, String voteType) {
		connect();
		String sql = null;
		if(voteType.equals("like")) {
			sql = "UPDATE foods SET like_cnt = like_cnt + 1 WHERE food_id = ?";
		} else if(voteType.equals("dislike")) {
			sql = "UPDATE foods SET dislike_cnt = dislike_cnt + 1 WHERE food_id = ?";
		} else {
			return false;
		}
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, parentId);

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
	
	public int getVote(String foodId, String voteType) {
		connect();
		String sql = null;
		if(voteType.equals("like")) {
			sql = "SELECT like_cnt FROM foods WHERE food_id = ?";
		} else if(voteType.equals("dislike")) {
			sql = "SELECT dislike_cnt FROM foods WHERE food_id = ?";
		} else {
			return -1;
		}
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, foodId);

			// SQL 실행
			result = stmt.executeQuery();
			if(result.next()) {
				int cnt = result.getInt(1);
				disconnect();
				stmt.close();
				result.close();
				return cnt;
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public boolean existsRows(String id) {
		connect();
		boolean isExists = false;
		String sql = "SELECT * FROM foods WHERE food_id = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, id);

			// SQL 실행
			result = stmt.executeQuery();
			if (result.next()) {
				isExists = true;
			} else {
				isExists = false; 
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		disconnect();
		try {
			result.close();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return isExists;
	}
}
