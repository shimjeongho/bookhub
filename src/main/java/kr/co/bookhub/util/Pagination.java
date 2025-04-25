package kr.co.bookhub.util;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class Pagination {
   private int rows = 10;
   private int pages = 5;   
   private int currentPage;
   private int offset;
   private int totalRows;
   private int totalPages;
   private int totalBlocks;
   private int currentBlock;
   private int beginPage;
   private int endPage;
   private boolean isFirst;
   private boolean isLast;
   private int prevPage;
   private int nextPage;
   /**
    * 요청한 페이지번호, 총 데이터갯수를 전달받아서 Pagination을 초기화한다.
    * @param pageNo 요청한 페이지번호
    * @param totalRows 총 데이터 갯수
    */
   public Pagination(int pageNo, int totalRows) {
      this.currentPage = pageNo;
      this.totalRows = totalRows;
      init();
   }
   
   /**
    * 요청한 페이지번호, 총 데이터갯수, 한 페이지당 표시할 행의 갯수를
    * 전달받아서 Pagination을 초기화한다.
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
      // 총 페이지 갯수 계산하기
      totalPages = Math.ceilDiv(totalRows, rows);
      
      // 요청한 페이지 번호가 잘못된 값일 때 값 조정하기
      if (currentPage < 1) {
         currentPage = 1;
      }
      if (currentPage > totalPages) {
         currentPage = totalPages;
      }
      
      // 요청한 페이지 번호에 맞는 offset값 계산하기
      offset = (currentPage - 1) * rows;
      
      // 총 블록 갯수 계산하기
      totalBlocks = Math.ceilDiv(totalPages, pages);
      // 현재 블록 번호 계산하기
      currentBlock = Math.ceilDiv(currentPage, pages);
      // 현재 블록 번호의 시작 페이지 번호 계산하기
      beginPage = (currentBlock - 1) * pages + 1;
      // 현재 블록 번호의 끝 페이지 번호 계산하기
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