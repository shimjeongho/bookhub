<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
BookReview review = new BookReview();
review.setReviewContent("로그인 없이 테스트하는 리뷰입니다.");
review.setReviewStar(5);
review.setReviewTitle("임시 사용자 리뷰 제목");
review.setUserId("tempuser"); // 임시 유저 ID
review.setBookNo(10);        // 테스트할 책 번호

bookReviewMapper.insertReview(review);

					