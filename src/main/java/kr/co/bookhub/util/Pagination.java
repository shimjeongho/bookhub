package kr.co.bookhub.util;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class Pagination {
	
	// 한 페이지당 표시할 게시글 개수 - 10개를 보여준다. 
   private int rows = 20; 

   // 한 페이지당 보여줄 블록의 개수 - 1~5번까지 보여준다.
   private int pages = 5;
   
   // 현재 사용자가 요청한 페이지 번호
   private int currentPage;
   
   // DB에서 게시글의 시작 위치값.
   private int offset; 
   
   // 전체 게시글 개수
   private int totalRows;
   
   // 전체 페이지 개수
   private int totalPages;
   
   // 전체 블록 개수
   private int totalBlocks;
   
   // 현재 페이지의 블록 번호
   private int currentBlock;
   
   // 현재 페이지에서 첫번째 블록 번호
   private int beginPage;
   
   // 현재 페이지에서 마지막 블록 번호
   private int endPage;
   
   // 현재 페이지가 1인지
   private boolean isFirst;
   
   // 현재 페이지가 마지막 페이지 인지.
   private boolean isLast; 
   
   // 이전 페이지
   private int prevPage;
   
   // 다음 페이지
   private int nextPage;
   
   /**
    * 요청한 페이지번호, 총 게시글 개수를 전달 받으면, 
    * 위의 필드 멤버들이 초기화 된다.
    * @param pageNo 요청한 페이지번호
    * @param totalRows 총 데이터 갯수
    */
   public Pagination(int pageNo, int totalRows) {
      this.currentPage = pageNo;
      this.totalRows = totalRows;
      init();
   }
   
   
   /**
    * 요청한 페이지번호, 총 게시글 개수, 한 페이지당 표시할 행의 개수를 전달받으면 
    * 위의 
    * @param pageNo
    * @param totalRows
    * @param rows
    */
   public Pagination(int pageNo, int totalRows, int rows) {
      this.currentPage = pageNo;
      this.totalRows = totalRows;
      this.rows = rows;
      init();
   }
   
   private void init() {
      // 총 페이지 개수 계산하기
      totalPages = Math.ceilDiv(totalRows, rows);
      
      // 현재 페이지 번호가 1이하인 경우 1로 재설정
      if (currentPage < 1) {
         currentPage = 1;
      }
      // 현재 페이지 번호가 전체 페이지 수 보다 클 경우 = 마지막 페이지보다 클 경우
      // 마지막 페이지 번호로 재설정
      if (currentPage > totalPages) {
         currentPage = totalPages;
      }
      
      // 현재 페이지에 맞게 offset 값을 설정.
      offset = (currentPage - 1) * rows;
      
      // 총 블록 개수 계산
      totalBlocks = Math.ceilDiv(totalPages, pages); 
      
      // 현재 블록 번호 계산
      currentBlock = Math.ceilDiv(currentPage, pages);
      
      // 현재 페이지의 첫번째 블록 번호
      beginPage = (currentBlock - 1) * pages + 1;
      
      // 현재 페이지의 마지막 블록 값 설정.
      endPage = currentBlock * pages;
      if (currentBlock == totalBlocks) {
         endPage = totalPages;
      }
      
      // 요청한 페이지가 1 페이지인 경우 true다.
      isFirst = currentPage == 1;
      
      // 요청한 페이지가 마지막 페이지인 경우 true다.
      isLast = currentPage == totalPages;
      
      // 이전/다음 페이지번호 계산하기
      prevPage = currentPage - 1; 
      nextPage = currentPage + 1; 
   }
}