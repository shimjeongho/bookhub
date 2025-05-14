package kr.co.bookhub.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.co.bookhub.vo.Book;
import kr.co.bookhub.vo.Post;
import kr.co.bookhub.vo.PostCategory;
import kr.co.bookhub.vo.PostReply;

public interface PostMapper {
	/**
	 * 사용자가 키워드를 입력하면, 해당 키워드를 가진 도서 목록들을 가져온다.
	 * @param keyword
	 * @return
	 */
	public List<Book> bookKeywordSearch(String keyword); 
	
	
	/**
	 * 사용자의 아이디를 가져와서, 사용자의 현재 대여 중인 도서 목록을 뽑아온다.
	 * @param userId
	 * @return
	 */
	public List<Book> userLoanBookSearch(String userId);
	
	
	/**
	 * 입력폼에서 전달받은 값을 담은 Post 객체를 인자값으로 전달하여, 
	 * 객체 안의 값을 꺼내, insert 쿼리문의 값으로 활용하여 DB에 insert한다.
	 * @param post
	 */
	public void insertBookPost(Post post); 
	
	/**
	 * 게시판 문의 유형의 정보를 조회해서 반환 받는다. 
	 * 각 게시판 유형에 대한 번호와 이름을 조회해서 반환받는다.
	 * @return 게시판 유형 번호, 게시판 유형 이름
	 */
	public List<PostCategory> selectPostCategoryInfo();
	
		/**
		 * 모든 게시글들을 조회한다.
		 * - 각 게시판의 문의 유형에 따라 조회 결과도 다르게 해야한다. 
		 * - 공개 여부가 'Y'이고, 삭제 여부가 'N'인 경우만 조회한다.
		 * @param condition.postCateNo : 게시판 유형 고유 번호
		 * @param condition.searchType : 게시글 검색 유형
		 * @param condition.searchKeyword : 게시글 검색어
		 * @param condition.pageNo : 현재 페이지 번호 
		 * @param condition.sort : 정렬 기준
		 * @param condition.offset : 오프셋 값 
		 * @param condition.rows : 페이지 당 조호되는 데이터 개수
		 * 
		 * @return 여러 개의 게시글
		 */
	public List<Post> getPosts(Map<String, Object> condition);
	
	/**
	 * 페이징 처리를 위한 전체 데이터 개수를 조회한다. 
	 * - map 객체 안에는 postCateNo값이 할당 되어 있기 때문에, 
	 * - 들어 있는 값에 따라서 문의 유형별 게시글의 전체 개수를 조회할 수 있다.
	 * @param condition.postCateNo : 게시판 유형 고유 번호
	 * @param condition.pageNo : 현재 페이지 번호
	 * 
	 * @return 전체 데이터 개수
	 */
	public int getTotalRows(Map<String, Object> condition);
	
	/**
	 * - 쿼리 스트링으로 받은 게시판 번호를 추출하여 해당 메소드의 인자값으로 활용한다. 
	 * - 게시판 번호로, 그 번호를 가진 게시판의 모든 정보를 가져온다. 
	 * => 게시글 제목, 내용, 작성일자
	 * => 문의 도서의 표지, 제목, 저자, 출판사, 출판일
	 * => 사용자 아이디, 사용자 이름 (사용자 아이디는, 해당 게시글의 수정 및 삭제 기능 권한을 부여 여부를 결정하기 위해 필요한 자원이다.)
	 * @param postNo
	 * @return
	 */
	public Post selectPostBypostNo(int postNo);
	
	/**
	 * 게시글의 객체를 받아와서, 게시글의 정보를 수정한다. 
	 * @param psot
	 */
	public void updatePost(Post post); 
	
	/**
	 * 사용자가 게시글의 제목을 키워드로 검색할 경우 연관된 게시글들이 조회된다.
	 * @param keyword
	 * @return 여러 개의 게시글들
	 */
	public List<Post> selectPostByTitleKeyword(String keyword);
	
	/**
	 * 사용자가 사용자의 이름으로 검색할 경우, 그 이름으로 작성된 게시글들이 조회된다.
	 * @param name
	 * @return 여러 개의 게시글들
	 */
	public List<Post> selectPostByUserName(String name);
	
	/**
	 * 게시글 상세 페이지에 있는, 댓글을 등록하는 기능
	 * @param postReply
	 */
	public void insertPostReply(PostReply postReply);
	
	/**
	 *  postNo값을 가진 특정 게시글의 부모 댓글들을 전부 가져온다.
	 *  즉, PARENT_NO가 NULL인 것들을 가져온다.
	 * @param condition.postNo 게시글 번호
	 * @return 부모 댓글
	 */
	public List<PostReply> getParentPostReplies(Map<String, Object> condition);
	
	/**
	 * postNo 값을 가진 특정 게시글의 대댓글들을 전부 가져온다. 
	 * 즉, PARENT_NO가  IS NOT NULL인 것들을 조회한다.
	 * @param condition
	 * @return
	 */
	public List<PostReply> getChildPostReplies(Map<String, Object> condition);
	
	/**
	 *  댓글 테이블에서 새롭게 설정된 값을 업데이트 한다.
	 * @param postReply
	 */
	public void updatePostReply(PostReply postReply);
	
	/**
	 * postNo 값을 가진 게시글의 postReplyNo 값을 가진 댓글을 찾아서 조회 하기
	 * 
	 * @param postReplyNo
	 * @param postNo
	 * @return
	 */
	public PostReply getPostReply(@Param("postReplyNo") int postReplyNo, @Param("postNo") int postNo);
	
	/**
	 * 부모 댓글의 총 개수를 가져온다.
	 * 게시글의 번호로 부모 댓글의 갯수를 가져온다.
	 * @param conditon.postNo
	 * @return
	 */
	public int totalRowsParentReply(Map<String, Object> conditon);
}