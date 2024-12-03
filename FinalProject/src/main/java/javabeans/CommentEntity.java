package javabeans;

import java.util.Date;
import java.text.SimpleDateFormat;

public class CommentEntity {
	
    private int commentId;
	private int postId;
	private String userName;
//	private String userPw;
	private String commentContent;
	private String createDate;
	private int likeCnt;
	private int disLikeCnt;
	
	public CommentEntity() {}
	
	public CommentEntity(int commentId, int postId, String userName, String commentContent, String createDate, int likeCnt, int disLikeCnt) {
	    this.commentId = commentId;
	    this.postId = postId;
	    this.userName = userName;
//	    this.userPw = userPw;
	    this.commentContent = commentContent;
	    this.createDate = createDate;
	    this.likeCnt = likeCnt;
	    this.disLikeCnt = disLikeCnt;
	}
	
	public int getCommentId() {
		return commentId;
	}
	public void setCommentId(int commentId) {
		this.commentId = commentId;
	}
	public int getPostId() {
		return postId;
	}
	public void setPostId(int postId) {
		this.postId = postId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
//	public String getUserPw() {
//		return userPw;
//	}
//	public void setUserPw(String userPw) {
//		this.userPw = userPw;
//	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currentDate = formatter.format(new Date());
		this.createDate = currentDate;
	}
	public int getLikeCnt() {
		return likeCnt;
	}
	public void setLikeCnt(int likeCnt) {
		this.likeCnt = likeCnt;
	}
	public int getDisLikeCnt() {
		return disLikeCnt;
	}
	public void setDisLikeCnt(int disLikeCnt) {
		this.disLikeCnt = disLikeCnt;
	}
	
	
	
}
